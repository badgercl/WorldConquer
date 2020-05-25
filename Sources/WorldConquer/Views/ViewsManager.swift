import Foundation

public protocol View {
    func render(_ viewState: ViewState)
}

public enum ViewState {
    case start(World)
    case step(StepState)
    case winner(Country)
    case error
}

public struct StepState {
    let world: World
    let winner: Country
    let looser: Country
    let territory: Territory
}

struct ViewsManager {
    private let views: [View]

    init(views: [View]) {
        self.views = views
    }

    func render(_ viewState: ViewState) {
        views.forEach { $0.render(viewState) }
    }
}
