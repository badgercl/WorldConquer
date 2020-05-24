import Foundation

public struct RandomWinningTerritoryCalculator: WinningTerritoryCalculator {
    public init() { }
    public func winningTerritory(in world: World) -> Territory? {
        guard let continent = world.continents.randomElement(),
            let territory = continent.territories.randomElement() else {
                return nil
        }
        return territory
    }
}
