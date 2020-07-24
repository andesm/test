import math

skip = 0
for i in range(10):
    n = (1 + math.sqrt(1 + 8 * skip)) / 2 + 1
    skip = int(((n - 1) * n ) / 2)
    print(skip)

