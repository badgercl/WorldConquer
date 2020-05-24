import Foundation

public protocol View {
    func render(_ viewState: ViewState)
}

public enum ViewState {
    case step(World)
    case winner(Country)
    case error
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
