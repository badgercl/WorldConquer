import Foundation
import Logging

public struct ConsoleView: View {
    private let logger: Logger
    private let localizer: Localizer

    public init(localizer: Localizer) {
        self.localizer = localizer
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
        case .error:
            showError()
        }
    }

    private func showStartGame(_ world: World) {
        display(localizer.localize(keyPath: \.gameStarted, withReplacements: ["initial-world": world.description]))
    }

    private func showWorldState(_ stepState: StepState) {
        var text = localizer.localize(
            keyPath: \.gameStepConquer,
            withReplacements: [
                "world-age": stepState.world.age.description,
                "winner-country": stepState.winner.name,
                "taken-territory": stepState.territory.name,
                "loser-country": stepState.looser.name
            ])

        if stepState.looser.isDefeated {
            text += " \(localizer.localize(keyPath: \.gameStepDefeated, withReplacements: ["loser-country": stepState.looser.name]))"
        }
        display(text)
    }

    private func showWinner(_ winner: Country) {
        display(localizer.localize(keyPath: \.gameEndedWinner, withReplacements: ["winner-country": winner.name]))
    }

    private func showError() {
        let text = localizer.localize(keyPath: \.gameError)
        logger.error(Logger.Message(stringLiteral: text))
    }
    

    private func display(_ text: String) {
        logger.info(Logger.Message(stringLiteral: text))
    }
}
