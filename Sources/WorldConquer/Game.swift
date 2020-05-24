import Foundation

public final class Game {
    private let engine: Engine
    private let viewsManager: ViewsManager

    public init(worldProvider: WorldProvider,
                closenessCalculator: ClosenessCalculator,
                winningTerritoryCalculator: WinningTerritoryCalculator,
                views: [View]) {
        engine = Engine(world: worldProvider.generate(),
                             closenessCalculator: closenessCalculator,
                             winningTerritoryCalculator: winningTerritoryCalculator)
        viewsManager = ViewsManager(views: views)
    }

    public func start() {
        while true {
            do {
                try engine.step()
                if let winner = engine.winner {
                    viewsManager.render(.winner(winner))
                    exit(0)
                } else {
                    viewsManager.render(.step(engine.currentWorld))
                }
            } catch {
                viewsManager.render(.error)
                exit(2)
            }
        }
    }
}
