import Foundation

public enum ViewState {
    case start(StartViewState)
    case step(StepViewState)
    case winner(WinnerViewState)
    case error(ErrorViewState)
}

public struct StartViewState {
    let header: String
    let body: String
    let worldDescription: String
}

public struct StepViewState {
    let conquer: String
    let defeated: String?
    let topEmpires: String
    let moreInfo: String?
}

public struct WinnerViewState {
    let gameEndMessage: String
}

public struct ErrorViewState {
    let message: String
}

public protocol GameViewStateMapper {
    func toStartState(world: World) -> ViewState
    func toStepState(from stepState: StepState) -> ViewState
    func toWinnerState(_ winner: Country) -> ViewState
    func toErrorState() -> ViewState
}

public struct GameViewStateMapperImpl: GameViewStateMapper {
    private let config: GameSettings
    private let localizer: Localizer

    public init(config: GameSettings, localizer: Localizer) {
        self.config = config
        self.localizer = localizer
    }

    public func toStartState(world: World) -> ViewState {
        let header = localizer.localize(keyPath: \.gameStartedHeader)
        let body = localizer.localize(keyPath: \.gameStartedBody)
        let worldDescription: String = world.continents.map { "- *\($0.name) (#\($0.countries.count))*: [\($0.countries.map(\.name).joined(separator: ", "))]" }.joined(separator: "\n")

        return .start(StartViewState(
                        header: header,
                        body: body,
                        worldDescription: worldDescription))
    }

    public func toStepState(from stepState: StepState) -> ViewState {
        let topNumber = 10
        let worldStatus: String = stepState
            .world
            .countries
            .sorted { $0.territories.count > $1.territories.count }
            .filter { $0.territories.count > 1 }
            .prefix(topNumber)
            .map {
                let territories = $0.territories.map(\.name).joined(separator: ", ")
                return " - *\($0.name)* (\($0.territories.count)): [\(territories)]"
            }
            .joined(separator: "\n")
        let stepConquer = localizer.localize(
            keyPath: \.gameStepConquer,
            withReplacements: [
                "world-age": stepState.world.age.description,
                "winner-country": stepState.winner.name,
                "taken-territory": stepState.territory.name,
                "loser-country": stepState.looser.name
            ])

        var defeated: String? = nil
        if stepState.looser.isDefeated {
            defeated = localizer.localize(
                keyPath: \.gameStepDefeated,
                withReplacements: ["loser-country": stepState.looser.name])
        }

        var moreInfo: String? = nil
        if let moreInfoURL = config.moreInfoURL {
            moreInfo = localizer.localize(
                keyPath: \.gameStepMoreInfo,
                withReplacements: ["more-info-url": moreInfoURL.absoluteString])
        }

        let topEmpires = localizer.localize(
            keyPath: \.gameStepTop ,
            withReplacements: [
                "top-number": String(topNumber),
                "top-countries": worldStatus
            ])
        return .step(StepViewState(
                        conquer: stepConquer,
                        defeated: defeated,
                        topEmpires: topEmpires,
                        moreInfo: moreInfo))
    }

    public func toWinnerState(_ winner: Country) -> ViewState {
        let text = localizer.localize(keyPath: \.gameEndedWinner, withReplacements: ["winner-country": winner.name])
        return .winner(WinnerViewState(gameEndMessage: text))
    }

    public func toErrorState() -> ViewState {
        .error(ErrorViewState(message: localizer.localize(keyPath: \.gameError)))
    }
}
