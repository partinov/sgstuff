import sys

f = open('sitelist.txt', 'r')
line = 1
sizes = {}

for l in f.readlines():
	if line == 1:
		name = l.split('\t')[1]
		sizes[name] = ''
	elif line == 2:
		sizes[name] = l.split(' ')[1] + 'MB'
	elif line == 4:
		line = 0
	line += 1
	

for w in sorted(sizes, key=sizes.get, reverse=True):
    print w + ': ' + sizes[w]