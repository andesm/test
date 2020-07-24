import numpy as np
import talib as ta

with open('fx.csv', "r") as f:
    data = np.array([v.rstrip() for v in f.readlines()], dtype = float)
    sma = ta.SMA(data, timeperiod = 5)

    
    
print(data, sma)

