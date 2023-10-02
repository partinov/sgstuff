import sys

def printDict(dic):
	c = 1
	for w in sorted(dic, key=dic.get, reverse=True):
	    print (str(c) + ": " + w + " - " + str(dic[w]))
	    c += 1
	    if c == 11:
	    	break

def insertEntry(dic, entry):
	if entry in dic:
		dic[entry] += 1
	else:
		dic[entry] = 1

ips = {}
respCodes = {}
reqs = {}
ua = {}

for fi in sys.argv[1:]:

	f = open(fi, 'r')

	t = 0
	for line in f.readlines():
		insertEntry(ips, line.split(' ')[0])
		insertEntry(respCodes, line.split(' ')[8])
		insertEntry(reqs, line.split(' ')[6].split('?')[0])
		insertEntry(ua, line.split(' ')[11])

		# for i, e in enumerate(line.split(' ')):
		# 	print str(i) + ": " + e

		# print ('')
		# t += 1
		# if t == 21:
		# 	break
	f.close()

print("\n-TOP 10 IPs-")
print("------------")
printDict(ips)


print("\n-TOP 10 Response codes-")
print("-----------------------")
printDict(respCodes)


print("\n-TOP 10 Requests codes-")
print("-----------------------")
printDict(reqs)

print("\n-TOP 10 User agents-")
print("-----------------------")
printDict(ua)

