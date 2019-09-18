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

def sum2Nat_():
    """
    sucet dvoch prirodzenych cisel s jednou globalnou premennou
    pomocna fcia
    """
    global a 
    if a > 0:
        a -= 1
        sum2Nat_()
        a += 1
    else:
        a = int(input('zadaj druhe cislo:'))

def sum2Nat():
    """
    sucet dvoch prirodzenych cisel s jednou globalnou premennou
    """
    global a
    a = int(input('zadaj prve cislo:'))
    sum2Nat_()
    print ('ich sucet je: ', str(a))


def sum2Int_():
    """
    sucet dvoch celych cisel s jednou globalnou premennou
    pomocna fcia
    """
    global a 
    if a > 0:
        a -= 1
        sum2Int_()
        a += 1
    elif a < 0:
        a += 1
        sum2Int_()        
        a -= 1
    else:
        a = int(input('zadaj druhe cele cislo:'))

def sum2Int():
    """
    sucet dvoch prirodzenych cisel s jednou globalnou premennou
    """
    global a
    a = int(input('zadaj prve cele cislo:'))
    sum2Int_()
    print ('ich sucet je: ' + str(a))


def sum3Int_2():
    """
    sucet troch celych cisel s jednou globalnou premennou
    pomocna fcia
    """
    global a 
    if a > 0:
        a -= 1
        sum3Int_2()
        a += 1
    elif a < 0:
        a += 1
        sum3Int_2()        
        a -= 1
    else:
        a = int(input('zadaj tretie cele cislo:'))

def sum3Int_1():
    """
    sucet troch celych cisel s jednou globalnou premennou
    pomocna fcia
    """
    global a 
    if a > 0:
        a -= 1
        sum3Int_1()
        a += 1
    elif a < 0:
        a += 1
        sum3Int_1()        
        a -= 1
    else:
        a = int(input('zadaj druhe cele cislo:'))
        sum3Int_2()

def sum3Int():
    """
    sucet troch celych cisel s jednou globalnou premennou
    """
    global a
    a = int(input('zadaj prve cele cislo:'))
    sum3Int_1()
    print ('ich sucet je: ' + str(a))



def max2Nat_2():
    """
    maximum dvoch prirodzenych cisel s jednou globalnou premennou
    pomocna fcia
    """
    global a 
    if a > 0:
        a -= 1
        max2Nat_2()
        a *=3
    else:
        a = 1
    

def max2Nat_1():
    """
    maximum dvoch prirodzenych cisel s jednou globalnou premennou
    pomocna fcia
    """
    global a 
    if a > 0:
        a -= 1
        max2Nat_1()
        a *=2
    else:
        a = int(input('zadaj druhe cele cislo:'))
        max2Nat_2()

def log2():
    """
    maximum dvoch prirodzenych cisel s jednou globalnou premennou
    pomocna fcia
    """
    global a 
    if a > 1:
        a /= 2
        log2()
        a += 1
    else:
        a = 0

def log3():
    """
    maximum dvoch prirodzenych cisel s jednou globalnou premennou
    pomocna fcia
    """
    global a 
    if a > 1:
        a /= 3
        log3()
        a += 1
    else:
        a = 0
        
def log6():
    """
    maximum dvoch prirodzenych cisel s jednou globalnou premennou
    pomocna fcia
    """
    global a 
    if a % 6 == 0:
        a /= 6
        log6()
        a += 1
    elif a % 2 == 0:
        log2()
    elif a % 3 == 0:
        log3()
    
def max2Nat():
    """
    maximum dvoch prirodzenych cisel s jednou globalnou premennou
    """
    global a
    a = int(input('zadaj prve cele cislo:'))
    max2Nat_1()
    # v premennej a je 2^prve*3^druhe
    # ... ideme logaritmovat
    # print (a)
    log6()
    print ('ich maximum je: ' + str(a))

    
print (fact1(4))
print (fact2(4))
print (fact3(4))
print (fact4(4))
sum2Nat()
sum2Int()
sum3Int()
max2Nat()
    
        
        


