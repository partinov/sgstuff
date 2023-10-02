import sys

# Capture only the characters from the strings for easier iteration.
stringA = sys.argv[2].split(',')
stringB = sys.argv[3].split(',')

# Check if Second and Third arguments have the same number of elements.
if (len(stringA) != len(stringB)):
	print ("Second and third argument should have the same length!")
	exit()


# See which mode we are in according to first arg and print in correct format.
if (sys.argv[1] == '0'):
	for i in range(len(stringA)):
		print (str(stringA[i]) + " " + str(stringB[i]) + " " + str(stringA[-i-1]) + " " + str(stringB[-i-1]))
elif (sys.argv[1] == '1'):
	for i in range(len(stringA)):
		print (stringA[-i-1] + " " + stringB[-i-1] + " " + stringA[i] + " " + stringB[i])
else:
	print("Please specify either 0 or 1 for first argument!")