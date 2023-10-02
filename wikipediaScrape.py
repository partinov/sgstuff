# Necessary imports
import random, wikipedia, re, datetime

# Open output file
f = open('log.txt', 'w')

# List of all possible statuses
statuses = ['OK', 'TEMP', 'PERM']

# Specify the title of the Wikipedia page
wiki = wikipedia.page('Amazon S3')
# Extract the plain text content of the page
text = wiki.content

# Clean text by removing Wikipedia headings
text = re.sub(r'==.*?==+', '', text)

# Remove empty lines and split text into a list of sentences
text = text.replace('\n', '').split('.')

# Setup initial time
time = datetime.datetime(2022, 11, 1, 9, 0, 0)

# Update user showing that the program is working
print ("Generating logs...")

# Repeat 10000 times
for i in range(10000):

	# Create log entry time by adding a random number of seconds between 0 and 2
	time = time + datetime.timedelta(seconds=random.randint(0, 2))

	# Safety check so we do not go above the time limit
	if time.time() > datetime.datetime(2022, 11, 1, 11, 59, 59).time():
		time = datetime.datetime(2022, 11, 1, 11, 59, 59)

	# Choose a random number between 3000 and 5000	
	pid = random.randint(3000,5000)

	# Choose a random list from the list of statuses
	status = random.choice(statuses)

	# Select a random sentence from the Wikipedia text
	data = random.choice(text).strip()

	# Construct the line by adding all elements together
	line = "20130101|" + str(time.time()) + "|" + str(pid) + "|" + status + "|" + data + "|"

	# Generate the X fodder up to the 500 character spec.
	comment = "X"*(499 - len(line))

	# Save to line along with godder to log file
	#print (line + comment)
	f.write(line + comment + '\n')

# Close the file
f.close()

# Notify that process is complete and file is closed
print("Log has been generated to log.txt and file has been closed!")