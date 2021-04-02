import Foundation

public final class Territory: Hashable {
    let name: String
    let population: Int
    var belongsTo: Country

    init(name: String, population: Int, belongsTo: Country) {
        self.name = name
        self.population = population
        self.belongsTo = belongsTo
        belongsTo.add(territory: self)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(population)
    }

    public static func == (lhs: Territory, rhs: Territory) -> Bool {
        return lhs.name == rhs.name && lhs.population == rhs.population
    }
}
