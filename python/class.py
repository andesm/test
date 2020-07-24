class Test:
    a = 2
    def test1(self):
        self.a += 2
        print(self.a)

test = Test()
test.test1()
test.test1()
test.test1()
print(test.a)

a = [1, 2, 3]
b = a
a[1] = 5
print(a)
print(b)
