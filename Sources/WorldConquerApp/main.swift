import Foundation
import WorldConquer

guard CommandLine.argc > 1 else {
    print("invalid parameters")
    exit(1)
}

let jsonFile = CommandLine.arguments[1]
let worldProvider = JsonWorldProvider(path: jsonFile)
let closenessCalculator = RandomCloseness()
let winningTerritoryCalculator = RandomWinningTerritoryCalculator()
let views: [View] = [ConsoleView()]

let game = Game(worldProvider: worldProvider,
                closenessCalculator: closenessCalculator,
                winningTerritoryCalculator: winningTerritoryCalculator,
                views: views)
game.start()
