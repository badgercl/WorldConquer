import Foundation

public final class Game {
    private let engine: Engine

    public init(worldProvider: WorldProvider,
                closenessCalculator: ClosenessCalculator,
                winningTerritoryCalculator: WinningTerritoryCalculator) {
        self.engine = Engine(world: worldProvider.generate(),
                             closenessCalculator: closenessCalculator,
                             winningTerritoryCalculator: winningTerritoryCalculator)
    }

    public func start() {
        while true {
            try! engine.step()
            if let winner = engine.winner {
                print("winner>>>>>")
                print(winner.description)
                break
            } else {
                print("\(engine.currentWorld.description)\n")
            }
        }
    }
}
