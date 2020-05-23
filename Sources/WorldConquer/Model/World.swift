import Foundation

final class World {
    var age: Int
    let continents: [Continent]
    let countries: [Country]

    var winner: Country? {
        let totalTerritories = countries.map(\.territories.count).reduce(0, { $0 + $1 })
        guard let winner = countries.first(where: { $0.territories.count == totalTerritories }) else {
            return nil
        }
        return winner
    }

    init(age: Int, continents: [Continent]) {
        self.age = age
        self.continents = continents
        self.countries = continents.map(\.countries).reduce([]) { $0 + $1 }
    }

    func nextIteration(winningCountry: Country, conqueredTerritory: Territory) {
        age += 1
        winningCountry.conquer(territory: conqueredTerritory)
    }

    var description: String {
        let countriesStrings = countries.filter{ $0.territories.count > 0}.map(\.description).joined(separator: "; ")
        return "Age: \(age), countries: \(countriesStrings)"
    }
}
