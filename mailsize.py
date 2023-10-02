import sys

f = open('maillist.txt', 'r')
line = 1
sizes = {}
total = 0
count = 0
for l in f.readlines():
	if line == 3:
		name = l.split('MB')[0]
		total += int(name)
	elif line == 4:
		line = 0
		count += 1
	line += 1
	
print (total)
print ()
#for w in sorted(sizes, key=sizes.get, reverse=True):
#    print w + ': ' + sizes[w]