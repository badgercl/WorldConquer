import Foundation
@testable import WorldConquer

extension World {
    static func stub(age: Age = LinearAge(), continents: [Continent]) -> World {
        return World(age: age, continents: continents)
    }
}
