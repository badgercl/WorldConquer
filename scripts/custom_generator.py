import csv
import sys
import json

continents = {}
with open(sys.argv[1], newline='') as csvfile:
    reader = csv.reader(csvfile, delimiter=',', quotechar='"')
    for row in reader:
        if not row[1] in continents:
            continents[row[1]] = {'name': row[1], 'territories': []}
        continents[row[1]]['territories'].append({
            "name": row[0],
            "population": int(row[2]),
            "belongsTo": {"name": row[0]}})


array_continents = []
for item in continents.values():
    array_continents.append(item)

output = {}
output['age'] = "0"
output['continents'] = array_continents
print(json.dumps(output))
