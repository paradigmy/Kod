from functools import reduce

print(reduce(lambda a,b:(a+b),[1,2,3,4,5,6]))
# ((1+2)+3)+4...  = 21
 
print(reduce(lambda a,b:(a-b),[1,2,3,4,5,6]))
# ((1-2)-3)-4... = -19

print(map(lambda x: x*x, [1,2,3,4,5]))

print(list(map(lambda x: x*x, [1,2,3,4,5])))

print(list(filter(lambda y:y>10,map(lambda x: x*x, [1,2,3,4,5]))))


print(reduce((lambda x, y: x * y), [1, 2, 3, 4]))
print(reduce((lambda x, y: x + y), [1, 2, 3, 4]))
print(reduce((lambda x, y: x - y), [1, 2, 3, 4]))

#def compose(f, g):
#    return lambda *a, **b: f(g(*a, **b))

# f.g
def compose(f, g):
    return lambda x: f(g(x))

print(compose(
            lambda x: x+1,
            lambda x: x*3
            )(10))

def composeMany(*fs):
    return reduce(compose, fs)

print(composeMany(
            lambda x: x+1,
            lambda x: x+2,
            lambda x: x*3
            )(100))


print(reduce(
            compose,
            [
              lambda x: x+1,
              lambda x: x+2,
              lambda x: x*3]
            )(100)
    )
