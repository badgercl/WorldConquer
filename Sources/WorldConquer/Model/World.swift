import Foundation

public final class World {
    var age: Age
    let continents: [Continent]
    let countries: [Country]

    var winner: Country? {
        let totalTerritories = countries.map(\.territories.count).reduce(0, { $0 + $1 })
        guard let winner = countries.first(where: { $0.territories.count == totalTerritories }) else {
            return nil
        }
        return winner
    }

    init(age: Age, continents: [Continent]) {
        self.age = age
        self.continents = continents
        self.countries = continents.map(\.countries).reduce([]) { $0 + $1 }
    }

    func nextIteration(winningCountry: Country, conqueredTerritory: Territory) {
        age = age.nextAge()
        winningCountry.conquer(territory: conqueredTerritory)
    }

    var description: String {
        let countriesStrings = continents.map(\.description).joined(separator: "\n")
        return "Age: \(age.description), countries: \(countriesStrings)"
    }
}
