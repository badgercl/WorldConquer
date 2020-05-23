import Foundation
@testable import WorldConquer

extension World {
    static func stub(age: Int = 0,
                     continents: [Continent]) -> World {
        return World(age: age, continents: continents)
    }
}
