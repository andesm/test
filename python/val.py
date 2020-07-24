
x = 1
z = 5

class t:
    def t(self):
        global x
        x = z
        print(x)

print(x)
y = t()
y.t()
print(x)

