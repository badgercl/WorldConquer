import Foundation

public protocol ClosenessCalculator {
    func getCloseTerritory(for territory: Territory, in world: World) -> Territory?
}
