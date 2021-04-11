import Foundation
import Logging

public final class MultiStepGame: Game {
    private let engine: Engine
    private let viewsManager: ViewsManager
    private let gameViewStateMapper: GameViewStateMapper
    private let stepTime: UInt32
    
    public init(worldFilePath: String?,
                closenessCalculator: ClosenessCalculator,
                winningTerritoryCalculator: WinningTerritoryCalculator,
                views: [View],
                logger: Logger?,
                stepTime: Int,
                gameViewStateMapper: GameViewStateMapper,
                persistency: WorldPersistency = SingleFileWorldPersistency(jsonWorldProvider: JsonWorldProvider())) throws {
        self.gameViewStateMapper = gameViewStateMapper
        guard let world = persistency.load(from: worldFilePath) else {
            throw GameError.invalidFile
        }
        engine = Engine(world: world,
                        closenessCalculator: closenessCalculator,
                        winningTerritoryCalculator: winningTerritoryCalculator)
        viewsManager = ViewsManager(views: views)
        self.stepTime = UInt32(stepTime)
        if let logger = logger {
            appLogger = logger
        }
    }
    
    public func start() {
        viewsManager.render(gameViewStateMapper.toStartState(world: engine.currentWorld))
        while true {
            do {
                let stepState = try engine.step()
                viewsManager.render(gameViewStateMapper.toStepState(from: stepState))

                if let winner = engine.winner {
                    viewsManager.render(gameViewStateMapper.toWinnerState(winner))
                    sleep(2)
                    exit(0)
                }
            } catch {
                viewsManager.render(gameViewStateMapper.toErrorState())
                exit(2)
            }
            sleep(stepTime)
        }
    }
}
