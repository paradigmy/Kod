def words(k, current = ''):
  if len(current) == k:
    return [current]
  result = []
  for ch in 'ABCDEF':
    result += words(k, current + ch)
  return result

print(words(3))

# a co toto...
print(words(8))
