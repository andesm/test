import numpy as np
import talib as ta

with open('fx.csv', "r") as f:
    data = np.array([int(float(v.rstrip()) * 100)  for v in f.readlines()], dtype = float)

st_sma = ta.SMA(data, timeperiod = 5)

cdef int a = 5
cdef int b = 11
cdef int c
c = (int)(b / a)
print(c)


