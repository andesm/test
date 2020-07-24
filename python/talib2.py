import numpy as np
import talib as ta
import random

class Position:
    def __init__(self, loss_cut, profit):
        self.loss_cut = loss_cut
        self.profit = profit
        self.posi_rate = 0

        self.total_lot = 100000
        self.posi_lot = 0
        self.posi_lot_rate = 1
        self.posi = ''
        self.trade = 0
        self.now_rate = 0
        
    def set_now_rate(self, now_rate):
        self.now_rate = now_rate

    def get_result(self):
        return self.total_lot, self.trade

    def profit_long(self):
        if self.posi == 'l':
            self.total_lot = self.total_lot + ((self.posi_lot / self.posi_rate) - (self.posi_lot / self.now_rate)) * self.now_rate
            #print("Profit Long : %8d %6.2f %6.2f %6.2f" % (self.total_lot, self.now_rate, self.posi_rate, self.now_rate - self.posi_rate))
            self.posi = ''
            
    def profit_short(self):
        if self.posi == 's':
            self.total_lot = self.total_lot - ((self.posi_lot / self.posi_rate) - (self.posi_lot / self.now_rate)) * self.now_rate
            #print("Profit  : %8d %6.2f %6.2f %6.2f" % (self.total_lot, self.now_rate, self.posi_rate, self.now_rate - self.posi_rate))
            self.posi = ''

    def cell_condition_long(self):
        return self.posi == 'l' and (self.now_rate - self.posi_rate < self.loss_cut or self.profit < self.posi_rate - self.now_rate)
            
    def cell_condition_short(self):
        return self.posi == 's' and (self.posi_rate - self.now_rate < self.loss_cut or self.profit < self.now_rate - self.posi_rate)
            
    def trade_long(self):
        self.posi= 'l'    
        self.posi_rate = self.now_rate
        self.posi_lot = self.total_lot * self.posi_lot_rate
        self.trade += 1
        #print("Trade Long : %8d %6.2f" % (self.total_lot, self.now_rate))

    def trade_short(self):
        self.posi= 's'    
        self.posi_rate = self.now_rate
        self.posi_lot = self.total_lot * self.posi_lot_rate
        self.trade += 1
        #print("Trade Short : %8d %6.2f" % (self.total_lot, self.now_rate))
        
class FX_Trade:
    def __init__(self, data):
        self.data = data

    def _trade_condition_long(self, d):
        return self.trade_condition_long(d)

    def _trade_condition_short(self, d):
        return self.trade_condition_short(d)
    
    def back_test(self, order_logic, loss_cut, profit):

        posi = Position(loss_cut, profit)
        
        #for d in range(len(self.data) - 1440 * 90, len(self.data)):
        for d in range(1, len(self.data)):
            posi.set_now_rate(self.data[d])
            if self._trade_condition_long(d):
                posi.profit_short()
                posi.trade_long()
            elif self._trade_condition_short(d):
                posi.profit_long()
                posi.trade_short()
            elif posi.cell_condition_long():
                posi.profit_long()
            elif posi.cell_condition_short():
                posi.profit_short()
               
        return posi.get_result()

class OrderLogicSMA(FX_Trade):
    def __init__(self, data, short_period, medium_period):
        FX_Trade.__init__(self, data)
        self.st_sma = ta.SMA(self.data, timeperiod = short_period)
        self.mt_sma = ta.SMA(self.data, timeperiod = medium_period)
 
    def trade_condition_long(self, d):
        return self.st_sma[d - 1] < self.mt_sma[d - 1] and self.mt_sma[d] < self.st_sma[d]
        
    def trade_condition_short(self, d):
        return self.mt_sma[d - 1] < self.st_sma[d - 1] and self.st_sma[d] < self.mt_sma[d]        

class OrderLogicRCI(FX_Trade):
    def __init__(self, data, short_period, medium_period, long_period):
        FX_Trade.__init__(self, data)
        self.st_rci = _RCI(short_period)
        self.mt_rci = _RCI(medium_period)
        self.lt_rci = _RCI(long_period)
 
    def trade_condition_long(self, d):
        return self.st_rci < -75 and self.mt_rci < self.st_rci and self.lt_rci < self.mt_rci
        
    def trade_condition_short(self, d):
        return 75 < self.st_rci and self.st_rci < self.mt_rci and self.mt_rci < self.lt_rci

    def _RCI(self, n):
        rci = [0 for day in range(len(self.data))]
        for day in range(n, len(self.data)):
            dc = [[0 for i in range(3)] for j in range(n)]
            for t in range(n):
                dc[t][0] = self.data[day - t]
                dc[t][1] = t + 1
            dc = sorted(dc ,key = lambda x: x[0])
            for t in range(n):
                dc[t][2] = t + 1
            d = 0
            for t in range(n):
                d += (dc[t][1] - dc[t][2]) * (dc[t][1] - dc[t][2])
            
            rci[day] = (1 - 6 * d / (n * (n * n - 1))) * 100
            
        return rci

def main(data, short_period, medium_period, l, p):
    loss_cut = -l * 0.1
    profit = p * 0.1

    order_logic = OrderLogicSMA(data, short_period, medium_period)
       
    total_lot, trade = order_logic.back_test(order_logic, loss_cut, profit)

    print(short_period, medium_period, loss_cut, profit, total_lot, trade)

    
if __name__ == '__main__':
    with open('fx.csv', "r") as f:
        data = np.array([v.rstrip() for v in f.readlines()], dtype = float)

    for short_period in range(2, 12, 5):
        for medium_period in range(short_period + 1, 14, 5):
            #for l in range(1, 40, 2):
            #    for p in range(1, 20, 2):
            main(data, short_period, medium_period, 100, 100)

    #for i in range(1):
    #    short_period = random.choice(range(2, 198))
    #    medium_period = random.choice(range(short_period + 1, 200))
    #    l = random.choice(range(1, 40))
    #    p = random.choice(range(1, 20))

