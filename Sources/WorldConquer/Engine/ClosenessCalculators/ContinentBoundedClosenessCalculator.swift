import Foundation

public struct ContinentBoundedClosenessCalculator: ClosenessCalculator {
    private let correctionFactor: Double
    private let randomizer: Randomizer

    public init(
        randomizer: Randomizer = RandomizerImpl(),
        correctionFactor: Double = 0.5
                ) {
        self.randomizer = randomizer
        self.correctionFactor = correctionFactor
    }

    public func getCloseTerritory(for territory: Territory, in world: World) -> Territory? {
        guard let continent = world
            .continents
            .filter({ $0.belongsToContinent(territory: territory) }).first else {
            return territory
        }
        let otherTerritories = continent.territories.filter { $0.belongsTo != territory.belongsTo }
        let totalUnconquered = otherTerritories.count
        let totalConquered = continent.territories.count - totalUnconquered
        logInfo("""
        otherTerritories: \(otherTerritories)
        totalUnconquered: \(totalUnconquered)
        totalConquered: \(totalConquered)
        """)
        if shouldConquerOtherContinent(totalUnconquered: totalUnconquered, totalConquered: totalConquered) {
            logInfo("shouldConquerOtherContinent")
            return pickTerritoryFromOtherContinent(otherThan: continent, winner: territory, in: world)
        } else {
            logInfo("pickLoosingTerritoryFrom")
            return pickLoosingTerritoryFrom(continent: continent, winnerTerritory: territory)
        }
    }

    private func shouldConquerOtherContinent(totalUnconquered: Int, totalConquered: Int) -> Bool {
        guard totalUnconquered > 0 else {
            return true
        }
        let chanceToConquerOtherContinent = (Double(totalConquered) / Double(totalUnconquered + totalConquered)) * correctionFactor
        let willConquerOtherContinent = chanceToConquerOtherContinent > randomizer.double(in: 0...1)
        return willConquerOtherContinent
    }

    private func pickTerritoryFromOtherContinent(otherThan currentContinent: Continent, winner: Territory, in world: World) -> Territory {
        let nonConqueredTerritories: [Territory] = world
            .continents
            .filter { $0.name != currentContinent.name && !$0.isConqueredAlready(by: winner.belongsTo) }
            .map(\.territories)
            .reduce([], +)
            .filter { $0.belongsTo.name != winner.belongsTo.name }
        guard let conqueredTerritory = randomizer.pickRandom(from: nonConqueredTerritories) else {
            return pickLoosingTerritoryFrom(continent: currentContinent, winnerTerritory: winner)
        }
        return conqueredTerritory
    }

    private func pickLoosingTerritoryFrom(continent: Continent, winnerTerritory: Territory) -> Territory {
        let otherTerritories = continent
            .territories
            .filter { $0.belongsTo != winnerTerritory.belongsTo }
        guard let territory = randomizer.pickRandom(from: otherTerritories) else {
            return winnerTerritory
        }
        return territory
    }
}
