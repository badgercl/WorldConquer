import Foundation

public protocol WinningTerritoryCalculator {
    func winningTerritory(in world: World) -> Territory?
}
