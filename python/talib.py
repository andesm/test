import numpy as np
import talib as ta

with open('fx_test.csv', "r") as f:
    data = np.array([v.rstrip() for v in f.readlines()], dtype = float)

st_sma = ta.SMA(data, timeperiod = 5)
mt_sma = ta.SMA(data, timeperiod = 21)
macd, macd_signal, _ = ta.MACD(data)

for d in range(len(data)):
    print(data[d], st_sma[d], mt_sma[d], macd[d], macd_signal[d], sep = ',')

