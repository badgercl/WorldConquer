import Foundation

public final class Country: Hashable {
    let name: String
    var territories: Set<Territory>

    init(name: String) {
        self.name = name
        self.territories = []
    }

    var isDefeated: Bool {
        territories.count == 0
    }

    func add(territory: Territory) {
        territories.insert(territory)
    }

    func conquer(territory: Territory) {
        let loosingCountry = territory.belongsTo
        loosingCountry.remove(territory: territory)
        add(territory: territory)
        territory.belongsTo = self
    }

    private func remove(territory: Territory) {
        territories.remove(territory)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    public static func == (lhs: Country, rhs: Country) -> Bool {
        lhs.name == rhs.name && lhs.territories == rhs.territories
    }

    var description: String {
        let territoriesNames = territories.map(\.name).joined(separator: ", ")
        return "\(name): [\(territoriesNames)]"
    }
}
