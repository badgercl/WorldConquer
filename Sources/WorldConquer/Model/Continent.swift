import Foundation

struct Continent {
    let name: String
    let territories: Set<Territory>

    var countries: [Country] {
        territories.map { $0.belongsTo }
    }
}
