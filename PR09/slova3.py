def words(len):
        if len == 0:
                return [""]
        else:
                return (ch+slovo
                        for slovo in words(len-1)
                        for ch in 'ABCDEF')
for m in words(3):
	print(m)

for m in words(8):
	print(m)

#for m in list(words(8)):
#	print(m)

#print(list(words(8)))
