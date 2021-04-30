import Foundation

public protocol Randomizer {
    func double(in range: ClosedRange<Double>) -> Double
    func pickRandom<T: Collection>(from collection: T) -> T.Element?
}

public struct RandomizerImpl: Randomizer {
    public init() { }

    public func double(in range: ClosedRange<Double>) -> Double {
        Double.random(in: range)
    }

    public func pickRandom<T: Collection>(from collection: T) -> T.Element? {
        collection.randomElement()
    }
}
