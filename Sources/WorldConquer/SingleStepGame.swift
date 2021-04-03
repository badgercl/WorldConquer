import Foundation

public final class SingleStepGame: Game {
    private let engine: Engine
    private let viewsManager: ViewsManager
    private let persistency: WorldPersistency
    private let isInitialStep: Bool

    public init(worldFilePath: String?,
                closenessCalculator: ClosenessCalculator,
                winningTerritoryCalculator: WinningTerritoryCalculator,
                views: [View],
                persistency: WorldPersistency = SingleFileWorldPersistency(jsonWorldProvider: JsonWorldProvider())) throws {
        self.persistency = persistency
        isInitialStep = worldFilePath != nil
        viewsManager = ViewsManager(views: views)
        guard let world = persistency.load(from: worldFilePath) else {
            throw GameError.invalidFile
        }
        engine = Engine(world: world,
                        closenessCalculator: closenessCalculator,
                        winningTerritoryCalculator: winningTerritoryCalculator)
    }


    public func start() {
        if isInitialStep {
            viewsManager.render(.start(engine.currentWorld))
        }
        do {
            if engine.winner != nil {
                print("game already ended")
                exit(0)
            }

            let stepState = try engine.step()
            viewsManager.render(.step(stepState))

            if let winner = engine.winner {
                viewsManager.render(.winner(winner))
            }
            persistency.save(world: engine.currentWorld)
        } catch {
            viewsManager.render(.error)
            exit(2)
        }
    }
}
