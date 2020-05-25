import Foundation

public final class Game {
    private let engine: Engine
    private let viewsManager: ViewsManager
    private let stepTime: UInt32

    public init(worldProvider: WorldProvider,
                closenessCalculator: ClosenessCalculator,
                winningTerritoryCalculator: WinningTerritoryCalculator,
                views: [View],
                stepTime: Int) {
        engine = Engine(world: worldProvider.generate(),
                             closenessCalculator: closenessCalculator,
                             winningTerritoryCalculator: winningTerritoryCalculator)
        viewsManager = ViewsManager(views: views)
        self.stepTime = UInt32(stepTime)
    }

    public func start() {
        while true {
            do {
                let (winnerTerritory, loosingCountry) = try engine.step()
                if let winner = engine.winner {
                    viewsManager.render(.winner(winner))
                    exit(0)
                } else {

                    viewsManager.render(.step(.init(world: engine.currentWorld, winner: winnerTerritory, loosingCountry: loosingCountry)))
                }
            } catch {
                viewsManager.render(.error)
                exit(2)
            }
            sleep(stepTime)
        }
    }
}
