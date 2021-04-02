import Foundation

public struct JsonWorldProvider: WorldProvider {
    private let path: String

    public init(path: String) {
        self.path = path
    }
    
    public func generate() -> World {
        let data = try! String(contentsOfFile: path).data(using: .utf8)
        let jsonDecoder = JSONDecoder()
        let jsonWorld = try! jsonDecoder.decode(JsonWorld.self, from: data!)
        var countries: Set<Country> = []

        let continents: [Continent] = jsonWorld.continents
            .map {
                let (continent, updatedCountries) = self.toContinent(continent: $0, countries: countries)
                countries = updatedCountries
                return continent
            }
        return World(age: LinearAge(age: jsonWorld.age), continents: continents, countries: Array(countries))
    }

    private func toContinent(continent: JsonContinent, countries: Set<Country>) -> (Continent, Set<Country>) {
        var updatedCountries: Set<Country> = countries
        let territories: [Territory] = continent.territories
            .map { territory in
                let countryName = territory.belongsTo.name
                let country: Country
                if let foundCountry = updatedCountries.first(where: { $0.name == countryName}) {
                    country = foundCountry
                } else {
                    let newCountry = Country(name: territory.belongsTo.name)
                    updatedCountries = updatedCountries.union([newCountry])
                    country = newCountry
                }

                return Territory(name: territory.name,
                                          population: territory.population,
                                          belongsTo: country)
            }
        return (Continent(name: continent.name, territories: Set(territories)), updatedCountries)
    }
}
