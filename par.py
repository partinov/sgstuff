import sys, json, re, subprocess

for i in json.loads(open('out.txt', 'r').readline())['data']:
     if re.search('://(www.)?'+ sys.argv[1] +'/$', i['app_url']) is not None :
          print i['id']
          f = open('app_id.txt', 'w')
          f.write(str(i['id']))
