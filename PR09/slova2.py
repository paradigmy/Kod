def words(len):
        if len == 0:
                return [""]
        else:
                return [ ch+slovo
                         for slovo in words(len-1)
                         for ch in 'ABCDEF']
print(words(3))

# a co toto...
print(words(8))

print(len(words(8)))

#for m in words(8):
#	print(m)
