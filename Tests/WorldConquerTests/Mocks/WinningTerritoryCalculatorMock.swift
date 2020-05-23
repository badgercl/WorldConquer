import Foundation
@testable import WorldConquer

final class WinningTerritoryCalculatorMock: WinningTerritoryCalculator {
    var winningTerritoryCallsCount = 0
    var winningTerritoryReturnValue: Territory?
    var winningTerritoryParams: [World] = []
    func winningTerritory(in world: World) -> Territory? {
        winningTerritoryCallsCount += 1
        winningTerritoryParams.append(world)
        return winningTerritoryReturnValue
    }
}
