#input.sk/struct2017/08.html

import functools
import time
import sys

sys.setrecursionlimit(10**9)

@functools.lru_cache(maxsize=None)          # dekorátor
def fib(n):
    if n < 2:
        return n
    return fib(n-1) + fib(n-2)

print(*(fib(n) for n in range(10)))
t1 = time.perf_counter()
#print(fib(12345))
t2 = time.perf_counter()
print('Seconds:', t2 - t1)

def fibIterativne(n, a, b):
    while n > 1:
        c = a
        a = b
        b = b+c
        n = n - 1
    return a


print(*(fib(n) for n in range(10)))
t1 = time.perf_counter()
print(fibIterativne(1234567,1,1))
t2 = time.perf_counter()
print('Seconds:', t2 - t1)
