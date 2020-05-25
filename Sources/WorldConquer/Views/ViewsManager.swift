import Foundation

public protocol View {
    func render(_ viewState: ViewState)
}

public enum ViewState {
    case step(StepViewState)
    case winner(Country)
    case error
}

public struct StepViewState {
    let world: World
    let winner: Territory
    let loosingCountry: Country
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
