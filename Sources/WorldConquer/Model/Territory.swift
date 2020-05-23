import Foundation

final class Territory: Hashable, Equatable {
    let name: String
    let population: Int
    var belongsTo: Country

    init(name: String, population: Int, belongsTo: Country) {
        self.name = name
        self.population = population
        self.belongsTo = belongsTo
        belongsTo.add(territory: self)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(population)
    }

    static func == (lhs: Territory, rhs: Territory) -> Bool {
        return lhs.name == rhs.name && lhs.population == rhs.population
    }
}
