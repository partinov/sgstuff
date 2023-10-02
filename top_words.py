# Necessary imports
import operator
import itertools
from collections import OrderedDict

# Open log file to parse the information
f = open("log.txt", 'r')
counts = {}

# Go through all data fields in each row and 
# include words in the dictionary + thier counts
for line in f.readlines():
	words = line.split('|')[4].split(' ')
	for word in words:
		if word not in counts:
			counts[word] = 0
		counts[word] += 1

print("Top 10 most common words in the data column: ")

# Sort the dictionary by counts and reverse the dict in order to have highest counts first
sorted_counts = OrderedDict(reversed(sorted(counts.items(), key=lambda item: item[1])))

# Slice the dictionary to only the fist 10 elements
reversed_counts = dict(itertools.islice(sorted_counts.items(), 10)) 

# Print the top 10 words
for i in reversed_counts:
	print(i + ": " + str(sorted_counts[i]))