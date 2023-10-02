This README is for 3 files:
generate_script.py, plot_log.py and top_words.py

generate_script.py:

Can be ran with the following command:
python3 generate_script.py 

Will save the output to a log.txt file containing 10,000 lines which are 500 bytes each.
Log data is delimited with "|"(pipe) and each line uses the following format with random data:


      date|time|pid|status|data|comment



      range of each column:
      date    : 20130101
      time    : 09:00:00-11:59:59
      pid     : 3000-5000
      status  : OK || TEMP || PERM
      data    : refer words/sentences used in whichever of the following
                pages and set them randomly.
                https://en.wikipedia.org/wiki/Amazon_S3
      comment : fill in with "X" to fit one line as 500 bytes.



plot_log.py:

Can be ran with the following command:
python3 plot_log.py

Will read the log.txt file and generate a bar chart of the diffrent types of requests per minute.
The result will alos be save to an out.csv file and to and output.jpg file.



top_words.py:

Can be ran with the following command:
python3 top_words.py

Will read the log.txt file and generate a dictionary of words and
how many times they occur in the logs' "data" column then print 
the top 10 most frequent words.


_sipfederationtls