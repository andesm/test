import numpy as np

data = np.loadtxt('fx_full.csv', delimiter=",", usecols=(3, 4, 5, 6))

for i in range(1, len(data)):
    print(data[i, 3])


