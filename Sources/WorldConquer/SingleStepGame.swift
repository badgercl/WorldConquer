import Foundation

public final class SingleStepGame: Game {
    private let engine: Engine
    private let viewsManager: ViewsManager
    private let persistency: WorldPersistency

    public init(worldFilePath: String?,
                closenessCalculator: ClosenessCalculator,
                winningTerritoryCalculator: WinningTerritoryCalculator,
                views: [View],
                persistency: WorldPersistency = SingleFileWorldPersistency(jsonWorldProvider: JsonWorldProvider())) throws {
        self.persistency = persistency
        viewsManager = ViewsManager(views: views)
        guard let world = persistency.load(from: worldFilePath) else {
            throw GameError.invalidFile
        }
        engine = Engine(world: world,
                        closenessCalculator: closenessCalculator,
                        winningTerritoryCalculator: winningTerritoryCalculator)
    }


    public func start() {
        viewsManager.render(.start(engine.currentWorld))
        do {
            let stepState = try engine.step()
            viewsManager.render(.step(stepState))

            if let winner = engine.winner {
                viewsManager.render(.winner(winner))
                exit(0)
            } else {
                persistency.save(world: engine.currentWorld)
            }
        } catch {
            viewsManager.render(.error)
            exit(2)
        }
    }
}
