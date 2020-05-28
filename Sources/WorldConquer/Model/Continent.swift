import Foundation

struct Continent {
    let name: String
    let territories: Set<Territory>

    var countries: [Country] {
        territories.map { $0.belongsTo }
    }

    func isConqueredAlready(by country: Country) -> Bool {
        territories.filter { $0.belongsTo.name != country.name }.count == 0
    }

    func belongsToContinent(territory: Territory) -> Bool {
        return territories
            .map { $0.name == territory.name }
            .reduce(false) { $0 || $1 }

    }

    var description: String {
        let territoresStr = territories.map(\.name).joined(separator: "; ")
        return "\(name)> \(territoresStr)"
    }
} 
