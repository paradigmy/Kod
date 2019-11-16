def fibonacci():
    x, y = 0, 1
    while True:
        yield x
        x, y = y, x + y

g = fibonacci()
for _ in range(20):
    print(next(g))

# toto sa zacykli, lebo ich je vela
#for f in fibonacci():
#    print(f)

def integers(n):
    while True:
        yield n
        n += 1
        
def sieve(d, sieved):
    for x in sieved:
        if (x % d != 0):
            yield x

def eratosten(ints):
    while True:
        first = next(ints)
        yield first
        ints = sieve(first, ints)
	
def take(n,g):
    for i in range(n):
        yield next(g)
	
print(list(take(100,eratosten(integers(2)))))



def zip(gen1, gen2):
    while True:
        yield next(gen1), next(gen2)
    
print(list(take(10,zip(integers(1), integers(2)))))

def tail(gen):
    next(gen)
    while True:
    	yield next(gen)

print(list(take(10,zip(integers(1), tail(integers(1))))))
print(list(take(10,zip(integers(1), tail(integers(1))))))

#fib in python
   	
def fib():
    yield 1
    yield 1
    for (x,y) in zip(fib(),tail(fib())):
        yield x+y
print("...")    
print(list(take(20,fib())))
        
#for f in fib():
#    print(f)
