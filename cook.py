import sqlite3
import http.cookiejar
import os
 
 
 
#Capture only these domains in the cookie file
#Or change to URL_Filter = [''] to capture all cookies
#URL_Filter = ['maco.siteground.com']
URL_Filter = ['']
#Desired output filename
file_name = ('cookies.txt')
 
#Change USER and PROFILE to correct names
cookie_sql = ("/Users/petar.artinov/Library/Application Support/Google/Chrome/Profile 1/Cookies")
 
  # cur.execute("SELECT host, path, isSecure, expiry, name, value FROM moz_cookies")
  #   for item in cur.fetchall():
  #       c = http.cookiejar.Cookie(0, item[4]//name, item[5]//value,
  #           None, False,
  #           item[0] //host, item[0].startswith('.')//host, item[0].startswith('.')//host,
  #           item[1]//path, False,
  #           item[2]//isSecure,
  #           item[3]//expiry, item[3]==""//expiry,
  #           None, None, {})
  #       cj.set_cookie(c)
  # /Users/petar.artinov/Library/Application\ Support/Google/Chrome/Profile 1/Local\ Storage
 
def get_cookies(cj, ff_cookies):
    con = sqlite3.connect(ff_cookies)
    cur = con.cursor()
    cur.execute("SELECT host_key, path, is_secure, expires_utc, name, value, encrypted_value  FROM cookies") #host, path, isSecure, expiry,
    for item in cur.fetchall():
        print(item[6])
        c = http.cookiejar.Cookie(0, item[4], item[5],
            None, False,
            item[0], item[0].startswith('.'), item[0].startswith('.'),
            item[1], False,
            item[2],
            item[3], item[3]=="",
            None, None, {})
        cj.set_cookie(c)
 
def save_cookies():
    f_direc = (os.path.dirname(os.path.abspath(__file__))+os.path.sep)
    cj = http.cookiejar.CookieJar()
    get_cookies(cj, cookie_sql)
    with open(f_direc+file_name, "w") as new: new.write('')
    for x in cj:
        with open(f_direc+file_name, "a") as f:
            if any(domain.lower() in x.domain.lower() for domain in URL_Filter):
 
                #Edit( '{n}, {v}, {d}\n' )to change format of cookie output in the .txt file
                f.write('{n}, {v}, {d}\n'.format(n=x.name,v=x.value,d=x.domain))
 
save_cookies()