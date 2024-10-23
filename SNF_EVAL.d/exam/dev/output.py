import csv

header = ['name','ro2','rsd']


with open('results.csv','w',encoding='UTF8',newline='') as f:
    writer = csv.writer(f)
    writer.writerow(header)
