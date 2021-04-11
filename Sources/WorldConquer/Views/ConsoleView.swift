import Foundation
import Logging

public struct ConsoleView: View {
    private let logger: Logger

    public init() {
        logger = Logger(label: "WorldConquerConsoleView")
    }

    public func render(_ viewState: ViewState) {
        switch viewState {
        case .start(let world):
            showStartGame(world)
        case .step(let stepViewState):
            showWorldState(stepViewState)
        case .winner(let winner):
            showWinner(winner)
        case .error(let error):
            showError(error)
        }
    }

    private func showStartGame(_ viewState: StartViewState) {
        display("\(viewState.header) \(viewState.body)\n\n\(viewState.worldDescription)")
    }

    private func showWorldState(_ viewState: StepViewState) {
        var text = viewState.conquer

        if let defeated = viewState.defeated {
            text += " \(defeated)"
        }
        display(text)
    }

    private func showWinner(_ viewState: WinnerViewState) {
        display(viewState.gameEndMessage)
    }

    private func showError(_ viewState: ErrorViewState) {
        logger.error(Logger.Message(stringLiteral: viewState.message))
    }

    private func display(_ text: String) {
        logger.info(Logger.Message(stringLiteral: text))
    }
}
