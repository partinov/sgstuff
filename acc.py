import xml.etree.ElementTree as ET
import sys

id_no = 'BG115634506'

tree = ET.parse('pokupki.xml')
root = tree.getroot()

# current_no = 1

for child in root[3]:
	f = open("f-ra_"+ child[0].attrib.get('Number') + ".txt", mode='w', encoding='cp1251')
	#print(child.attrib)
	# print('----------------------------')
	# period = date.split('/')[2] + date.split('/')[1]
	date = child[0].attrib.get('Date').split('-')[2] + '.' + child[0].attrib.get('Date').split('-')[1] + "." + child[0].attrib.get('Date').split('-')[0]
	comment = child.attrib.get('Term')
	number = child[0].attrib.get('Number')
	accountNumber1 = child[2][0].attrib.get('AccountNumber')
	total_price1 = float(child[2][0].attrib.get('Amount'))
	accountNumber2 = child[2][1].attrib.get('AccountNumber')
	total_price2 = float(child[2][1].attrib.get('Amount'))
	contragent = child[1].attrib.get('Name')
	contrNo = 813
	vat_no = child[1].attrib.get('VatNumber')
	crlf = "\r\n"

	# output = id_no + ' '*4 + period + (str(current_no) + '01' + number).rjust(31) + ' '*10 + (date + vat_no).ljust(25) + contragent.ljust(50) + service_desc.ljust(30) + str(do).rjust(15) + '{:.2f}'.format(vat_amount).rjust(15) + ('0.00').rjust(15)*15 + '  ' + chr(13) + chr(10)

	line1 = "104, " + number + ", " + date + ", " + comment + crlf

	line2 = "\"" + accountNumber1 + "\", \"" + accountNumber2 + "\", " + str(total_price1) + crlf
	line3 = str(contrNo) + ", \"" + contragent + "\", \"" + vat_no + "\"" + crlf
	line4 = number + crlf
	line5 = date + crlf

	line10 = ";"

	print (line1)
	f.write(line1)

	print (line2)
	f.write(line2)

	print (line3)
	f.write(line3)

	print (line4)
	f.write(line4)

	print (line5)
	f.write(line5)



	print (line10)
	f.write(line10)
	f.close()

	#current_no += 1

