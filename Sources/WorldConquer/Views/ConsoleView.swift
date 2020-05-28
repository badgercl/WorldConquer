import Foundation
import Logging

public struct ConsoleView: View {
    private let logger: Logger

    public init() {
        logger = Logger(label: "WorldConquer")
    }

    public func render(_ viewState: ViewState) {
        switch viewState {
        case .start(let world):
            showStartGame(world)
        case .step(let stepViewState):
            showWorldState(stepViewState)
        case .winner(let winner):
            showWinner(winner)
        case .error:
            showError()
        }
    }

    private func showStartGame(_ world: World) {
        logger.info("Game started with World:\n\(world.description)")
    }

    private func showWorldState(_ stepState: StepState) {
        logger.info("[Year \(stepState.world.age.description)] \(stepState.winner.name) conquered \(stepState.territory.name) previosly occupied by \(stepState.looser.name)")
    }

    private func showWinner(_ winner: Country) {
        logger.info("Game ended with winning country: \(winner.name)")
    }

    private func showError() {
        logger.error("We've found an unexpected error and the game has been cancelled")
    }
}
