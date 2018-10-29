flag = 'false'
while flag == 'false': 
    vari = int(input())
    if vari != 10:
        print ('not ten')
    if vari == 10:
        print ('ten!')
        flag = 'true'
    elif vari == 12:
        print ('twelve!')
        flag = 'true'
    else:
        print ('Error!')
        
