
class Super:
    def __init__(self, x):
        self.x = x

class Sub(Super):
    def __init__(self, x, y):
        Super.__init__(self, x)
        self.y = y

    def p(self):
        print(self.x)

a = Sub(1, 2)
a.p()
