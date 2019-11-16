# slova z pismen A..F dlzky len

def slova(len):
        if len == 0:
                return [""]
        else:
                return [ ch+slovo for slovo in slova(len-1) for ch in ['A', 'B','C','D','E', 'F']]
                
print(slova(3))


def words(len):
        ws = []
        words1(len,"", ws)
        return ws

def words1(len, word, ws):
        if len == 0:
                ws.append(word)
        else:
                for ch in ['A', 'B', 'C', 'D', 'E', 'F']:
                     words1(len-1, ch+word, ws)

print(words(3))
