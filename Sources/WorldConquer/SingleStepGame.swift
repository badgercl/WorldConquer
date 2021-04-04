import Foundation
import Logging

public final class SingleStepGame: Game {
    private let engine: Engine
    private let viewsManager: ViewsManager
    private let persistency: WorldPersistency
    private let isInitialStep: Bool
    private let isTest: Bool

    public init(worldFilePath: String?,
                closenessCalculator: ClosenessCalculator,
                winningTerritoryCalculator: WinningTerritoryCalculator,
                views: [View],
                logger: Logger,
                isTest: Bool,
                persistency: WorldPersistency = SingleFileWorldPersistency(jsonWorldProvider: JsonWorldProvider())) throws {
        self.persistency = persistency
        self.isTest = isTest
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
        do {
            if engine.winner != nil {
                logInfo("Game already ended, nothing to do")
                exit(0)
            }

            if isInitialStep {
                logInfo("First step, creating the world")
                viewsManager.render(.start(engine.currentWorld))
            } else {
                logInfo("Intermediate step year \(engine.currentWorld.age.description)")
                let stepState = try engine.step()
                viewsManager.render(.step(stepState))

                if let winner = engine.winner {
                    viewsManager.render(.winner(winner))
                }
            }

            if !isTest {
                persistency.save(world: engine.currentWorld)
            }

            GraphvizExporter().export(world: engine.currentWorld, name: "current")

            logInfo("Game step successfully ended")
        } catch {
            logError("Game ended with error: \(error)")
            viewsManager.render(.error)
            exit(2)
        }
    }
}
