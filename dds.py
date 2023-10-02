import sys

id_no = 'BG115634506'

Lines = open(file=sys.argv[1], mode='r', encoding = 'cp1251').readlines()
f = open("prodagbi.txt", mode='w', encoding='cp1251')

current_no = 1
for line in Lines:
    cats = line.split("|")
    date = cats[1].replace('.', '/')
    period = cats[1].split(".")[2] + cats[1].split(".")[1]
    number = cats[2][:10]
    total_price = float(cats[4])
    contragent = cats[6][:50]
    vat_no = cats[10]
    service_desc = cats[14][:30]
    vat_amount = float(cats[15])
    do = round(total_price - vat_amount, 2)

    #if service_desc.__len__() < 25:
    output = id_no + ' '*4 + period + (str(current_no) + '01' + number).rjust(31) + ' '*10 + (date + vat_no).ljust(25) + contragent.ljust(50) + service_desc.ljust(30) + str(do).rjust(15) + '{:.2f}'.format(vat_amount).rjust(15) + ('0.00').rjust(15)*15 + '  ' + chr(13) + chr(10)
    #else:
     #   output = id_no + ' '*4 + period + (str(current_no) + '01' + number).rjust(31) + ' '*10 + (date + vat_no).ljust(25) + contragent.ljust(50) + service_desc.ljust(25) + str(do).rjust(20) + '{:.2f}'.format(vat_amount).rjust(15) + ('0.00').rjust(15)*15 + '  ' + chr(13) + chr(10)

    print(output)
    f.write(output)

    current_no += 1



