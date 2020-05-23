import Foundation
@testable import WorldConquer

final class ClosenessCalculatorMock: ClosenessCalculator {
    var getRandomCloseTerritoryCallsCount = 0
    var getRandomCloseTerritoryReturnValue: Territory?
    var getRandomCloseTerritoryParams: [(territory: Territory, world: World)] = []
    func getRandomCloseTerritory(for territory: Territory, in world: World) -> Territory? {
        getRandomCloseTerritoryCallsCount += 1
        getRandomCloseTerritoryParams.append((territory: territory, world: world))
        return getRandomCloseTerritoryReturnValue
    }
}
