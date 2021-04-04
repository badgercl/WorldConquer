import requests
import json

continents_source = requests.get("https://raw.githubusercontent.com/samayo/country-json/master/src/country-by-continent.json")
population_source = requests.get("https://raw.githubusercontent.com/samayo/country-json/master/src/country-by-population.json")

continents = {}
population = {}

for entry in population_source.json():
    population[entry['country']] = entry['population']

for entry in continents_source.json():
    if not entry['continent'] in continents:
        continents[entry['continent']] = {'name': entry['continent'], 'territories': []}
    continents[entry['continent']]['territories'].append({
        "name": entry['country'],
        "population": population[entry['country']],
        "belongsTo": {"name": entry['country']}})

output = []
for item in continents.values():
    output.append(item)

print(json.dumps(output))
