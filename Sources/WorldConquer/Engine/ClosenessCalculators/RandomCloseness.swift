import Foundation

public struct RandomCloseness: ClosenessCalculator {
    public init() { }
    
    public func getCloseTerritory(for territory: Territory, in world: World) -> Territory? {
        guard world.continents.map(\.territories.count).reduce(0, { $0 + $1 }) > 1 else {
            return territory
        }
        guard let candidate = getRandomTerritory(world: world), candidate != territory else {
            return getCloseTerritory(for: territory, in: world)
        }
        return candidate
    }

    private func getRandomTerritory(world: World) -> Territory? {
        guard let continent = world.continents.randomElement(),
            let territory = continent.territories.randomElement() else {
                return nil
        }
        return territory
    }
}
