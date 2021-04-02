import Foundation

enum GameError: Error {
    case invalidFile
}

public protocol Game {
    func start()
}
