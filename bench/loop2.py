a = 0
i = 0
s = 1
while (i <= 100000000):
    a = a + s * i
    i = i + 1
    s = - s
print(a)
