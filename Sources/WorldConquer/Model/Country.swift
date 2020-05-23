import Foundation

final class Country: Equatable {
    let name: String
    var territories: Set<Territory>

    init(name: String) {
        self.name = name
        self.territories = []
    }

    func add(territory: Territory) {
        territories.insert(territory)
    }

    func remove(territory: Territory) {
        territories.remove(territory)
    }

    func conquer(territory: Territory) {
        let loosingCountry = territory.belongsTo
        loosingCountry.remove(territory: territory)
        add(territory: territory)
        territory.belongsTo = self
    }

    static func == (lhs: Country, rhs: Country) -> Bool {
        return lhs.name == rhs.name && lhs.territories == rhs.territories
    }

    var description: String {
        let territoriesNames = territories.map(\.name).joined(separator: ", ")
        return "\(name): [\(territoriesNames)]"
    }
}
