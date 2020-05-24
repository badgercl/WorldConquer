import Foundation
import Logging

public struct ConsoleView: View {
    private let logger: Logger

    public init() {
        logger = Logger(label: "WorldConquer")
    }

    public func render(_ viewState: ViewState) {
        switch viewState {
        case .step(let world):
            showWorldState(world)
        case .winner(let winner):
            showWinner(winner)
        case .error:
            showError()
        }
    }

    private func showWorldState(_ world: World) {
        logger.info("\(world.description)")
    }

    private func showWinner(_ winner: Country) {
        logger.info("Game ended with winning country: \(winner.description)")
    }

    private func showError() {
        logger.error("We've found an unexpected error and the game has been cancelled")
    }
}
