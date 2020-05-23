import Foundation

guard CommandLine.argc > 1 else {
    print("invalid parameters")
    exit(1)
}

let jsonFile = CommandLine.arguments[1]
let worldProvider = JsonWorldProvider(path: jsonFile)
let closenessCalculator = RandomCloseness()
let winningTerritoryCalculator = RandomWinningTerritoryCalculator()

let game = Game(worldProvider: worldProvider,
                closenessCalculator: closenessCalculator,
                winningTerritoryCalculator: winningTerritoryCalculator)
game.start()
