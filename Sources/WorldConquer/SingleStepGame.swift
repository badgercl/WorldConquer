import Foundation

public final class SingleStepGame: Game {
    //private let engine: Engine
    private let viewsManager: ViewsManager

    public init(worldProvider: WorldProvider,
                closenessCalculator: ClosenessCalculator,
                winningTerritoryCalculator: WinningTerritoryCalculator,
                views: [View],
                persistency: WorldPersistency = SingleFileWorldPersistency()) {
        viewsManager = ViewsManager(views: views)
        persistency.load()
//        engine = Engine(world: Self.loadWorld(persistency: persistency),
//                        closenessCalculator: closenessCalculator,
//                        winningTerritoryCalculator: winningTerritoryCalculator)
    }

//    private static func loadWorld(persistency: WorldPersistency) -> World {
//    }

    public func start() {

    }
}
