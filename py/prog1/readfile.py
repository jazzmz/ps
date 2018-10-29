filepath = "C:/test/py/prog1/"
file = open(filepath + '/test.txt')
outfile = open(filepath + '/out.txt', 'w')
i=0
for line in file:
    i=i+5
    print(int(line.strip()) + i)
    outfile.write (str(int(line.strip())+i) + '\n')
file.close()
outfile.close()

