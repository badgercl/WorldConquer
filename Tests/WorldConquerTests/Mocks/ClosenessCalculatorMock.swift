import Foundation
@testable import WorldConquer

final class ClosenessCalculatorMock: ClosenessCalculator {
    var getCloseTerritoryCallsCount = 0
    var getCloseTerritoryReturnValue: Territory?
    var getCloseTerritoryParams: [(territory: Territory, world: World)] = []
    func getCloseTerritory(for territory: Territory, in world: World) -> Territory? {
        getCloseTerritoryCallsCount += 1
        getCloseTerritoryParams.append((territory: territory, world: world))
        return getCloseTerritoryReturnValue
    }
}
