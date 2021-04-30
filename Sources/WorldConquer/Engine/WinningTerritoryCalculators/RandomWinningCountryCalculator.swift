import Foundation

public struct RandomWinningTerritoryCalculator: WinningTerritoryCalculator {
    public init() { }
    public func winningTerritory(in world: World) -> Territory? {
        guard let territory = world.continents.map(\.territories).reduce([], +).randomElement() else {
            return nil
        }
        return territory
    }
}
