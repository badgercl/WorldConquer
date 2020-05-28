import ArgumentParser
import Foundation
import WorldConquer

struct WorldConquerApp: ParsableCommand {
    @Option(name:   [.short, .customLong("json")], help: "A JSON file describing the games' world")
    var jsonPath: String

    @Option(name: .shortAndLong, default: 1, help: "Seconds between every step")
    var stepTime: Int

    @Flag(name: [.long], help: "Show console logs")
    var verbose: Bool

    func validate() throws {
        guard stepTime >= 0 else {
            throw ValidationError("StepTime must be a positive number")
        }
    }

    func run() throws {
        let worldProvider = JsonWorldProvider(path: jsonPath)
        let closenessCalculator = ContinentBoundedClosenessCalculator()
        let winningTerritoryCalculator = RandomWinningTerritoryCalculator()
        var views: [View] = []

        if verbose {
            views.append(ConsoleView())
        }

        let game = Game(worldProvider: worldProvider,
                        closenessCalculator: closenessCalculator,
                        winningTerritoryCalculator: winningTerritoryCalculator,
                        views: views,
                        stepTime: stepTime)
        game.start()
    }
}

WorldConquerApp.main()
