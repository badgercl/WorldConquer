import Foundation

enum EngineError: Error {
    case invalidState
}

final class Engine {
    private var world: World
    private let closenessCalculator: ClosenessCalculator
    private let winningTerritoryCalculator: WinningTerritoryCalculator

    var currentWorld: World { world }
    var winner: Country? { world.winner }

    init(world: World,
         closenessCalculator: ClosenessCalculator,
         winningTerritoryCalculator: WinningTerritoryCalculator) {
        self.closenessCalculator = closenessCalculator
        self.winningTerritoryCalculator = winningTerritoryCalculator
        self.world = world
    }

    func step() throws -> StepState {
        guard let winningTerritory = winningTerritoryCalculator.winningTerritory(in: world),
            let conqueredTerritory = closenessCalculator.getRandomCloseTerritory(for: winningTerritory, in: world) else {
                throw EngineError.invalidState
        }
        let winningCountry = winningTerritory.belongsTo
        let loosingCountry = conqueredTerritory.belongsTo
        world.nextIteration(winningCountry: winningCountry, conqueredTerritory: conqueredTerritory)
        return .init(world: world, winner: winningCountry, looser: loosingCountry, territory: conqueredTerritory)
    }
}
