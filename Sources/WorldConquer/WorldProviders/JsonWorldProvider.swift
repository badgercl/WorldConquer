import Foundation

public struct JsonWorldProvider: WorldProvider {
    private let path: String

    public init(path: String) {
        self.path = path
    }
    
    public func generate() -> World {
        let data = try! String(contentsOfFile: path).data(using: .utf8)
        let jsonDecoder = JSONDecoder()
        let jsonContinents = try! jsonDecoder.decode([JsonContinent].self, from: data!)
        let continents: [Continent] = jsonContinents.map(transformContinent)
        return World(age: LinearAge(), continents: continents)
    }

    private func transformContinent(continent: JsonContinent) -> Continent {
        let territories: [Territory] = continent.territories.map { territory in
                let country = Country(name: territory.belongsTo.name)
                return Territory(name: territory.name,
                                 population: territory.population,
                                 belongsTo: country)
        }
        return Continent(name: continent.name, territories: Set(territories))
    }
}
