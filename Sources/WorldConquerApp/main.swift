import ArgumentParser
import Foundation
import WorldConquer

struct WorldConquerApp: ParsableCommand {
    @Option(name: [.short, .customLong("json")], help: "A JSON file describing the games' world")
    var jsonPath: String?

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
        //let worldProvider = JsonWorldProvider(path: jsonPath)
        let closenessCalculator = ContinentBoundedClosenessCalculator()
        let winningTerritoryCalculator = RandomWinningTerritoryCalculator()
        var views: [View] = []

        views.append(TelegramView(token: "690106940:AAH4kLH6o8OsDS1gKRkEkjzIGehLBgtyBzU", chatId: "7372677"))

        if verbose {
            views.append(ConsoleView())
        }

//        let game = MultiStepGame(worldProvider: worldProvider,
//                                 closenessCalculator: closenessCalculator,
//                                 winningTerritoryCalculator: winningTerritoryCalculator,
//                                 views: views,
//                                 stepTime: stepTime)
        do {
            let game = try SingleStepGame(worldFilePath: jsonPath,
                                      closenessCalculator: closenessCalculator,
                                      winningTerritoryCalculator: winningTerritoryCalculator,
                                      views: views)
            game.start()
        } catch {
            print("Error initialising game")
        }
    }
}

WorldConquerApp.main()
