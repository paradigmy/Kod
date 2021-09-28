def fact1(n):
    """
    nerekurzivny faktorial, cyklus for  
    """
    f=1
    for i in range(1,n):  # 1,2,.., n-1
        f *= i+1
    return f

def fact2(n):
    """
    rekurzivny faktorial, nepouziva priradenie
    """
    if n==1:
        return 1
    else:
        return n*fact2(n-1)
    
def times3(a,b):
    """
    rekurzivny faktorial, nepouziva priradenie, nepouziva nasobenie
    """
    if a == 0:
        return 0
    else:
        return times3(a-1,b)+b;

def fact3(n):
    if n==1:
        return 1
    else:
        return times3(n,fact3(n-1))
    
def times4(a,b):
    """
    rekurzivny faktorial, nepouziva priradenie, nepouziva nasobenie, nepouziva ziadne ciselne konstanty
    """
    if a-a == a:
        return a
    else:
        return times3(a-(a/a),b)+b;

def fact4(n):
    if n == n//n:
        return n
    else:
        return times4(n,fact4(n-(n//n)))

###############################################################
#  priklady obmedzeneho Pythona s jedinou globalnou premennou a
###############################################################

a = 0  # toto je ta globalna premenna, na to aby sme ju videli v lokalnom scope, musime napisat 'global a'


def sum2Nat():
    """
    sucet dvoch prirodzenych cisel s jednou globalnou premennou
    """
    global a
    a = int(input('zadaj prve cislo:'))
    print ('ich sucet je: ', str(a))

sum2Nat()
#sum2Int()
#sum3Int()
#max2Nat()
    
        
        


