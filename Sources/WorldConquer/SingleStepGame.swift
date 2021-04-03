import Foundation
import Logging

public final class SingleStepGame: Game {
    private let engine: Engine
    private let viewsManager: ViewsManager
    private let persistency: WorldPersistency
    private let isInitialStep: Bool

    public init(worldFilePath: String?,
                closenessCalculator: ClosenessCalculator,
                winningTerritoryCalculator: WinningTerritoryCalculator,
                views: [View],
                logger: Logger,
                persistency: WorldPersistency = SingleFileWorldPersistency(jsonWorldProvider: JsonWorldProvider())) throws {
        self.persistency = persistency
        appLogger = logger
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
                logInfo("Game already ended, nothing to do")
                exit(0)
            }

            let stepState = try engine.step()
            viewsManager.render(.step(stepState))

            if let winner = engine.winner {
                viewsManager.render(.winner(winner))
            }
            persistency.save(world: engine.currentWorld)
            logInfo("Game step successfully ended")
        } catch {
            logError("Game ended with error: \(error)")
            viewsManager.render(.error)
            exit(2)
        }
    }
}
