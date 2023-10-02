# Necessary imports
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from matplotlib import rc
from datetime import datetime


# Open log file to parse the information
f = open("log.txt", 'r')

# Create a dict to keep track of the counts and 
# the different lists needed for the plot.
counts = {}
oks = []
temps = []
perms = []

# Loop through the log file, parse the time and count the stats. 
for line in f.readlines():
	# Strip the seconds from the time so we could count reqs/minute
	time = datetime.strftime(datetime.strptime(line.split("|")[1], "%H:%M:%S"), "%H:%M")
	
	# Initialise counters for a specific minute if necessary
	if time not in counts:
		counts[time] = [0, 0, 0]
	
	# Caputre the status
	status = line.split("|")[3]
	
	# Increment appropriate counter according to status
	if status == 'OK':
		counts[time][0] += 1
	elif status == 'TEMP':
		counts[time][1] += 1
	else:
		counts[time][2] += 1

# Move counts to seprate lits for the plot
for c in counts: 
	oks = oks + [counts[c][0]]
	temps = temps + [counts[c][1]]
	perms = perms + [counts[c][2]]

# Create e new list that is a sum of perms and temps counters 
# Needed to properly plot the top bar for oks.
bars = np.add(perms, temps).tolist()

# Plot bars
# Create red perms bars oks, 
plt.bar(range(len(counts)), perms, color='#FF0000', label='perms') 
# Create yellow temps bars (middle), on top of the first ones
plt.bar(range(len(counts)), temps, bottom=perms, color='#FFFE00', label='temps')
# Create green oks bars (top)
plt.bar(range(len(counts)), oks, bottom=bars, color='#00FF15', label='oks')

# Show legend
plt.legend(loc="upper left")

# y-axis in bold
rc('font', weight='bold')

# Custom X ticks
plt.xticks(range(len(counts)), counts.keys(), fontweight='bold')

# Setup labels
plt.xlabel("Minute")
plt.ylabel("Number of requests")

# Save the plot to a file
plt.savefig('plot.jpg')

# Show graphic
plt.show()

# Import the counts dict to a Pandas DF 
df = pd.DataFrame(data=counts)

# Use the DF to export to CSV
df.to_csv('plot.csv', index=True)

