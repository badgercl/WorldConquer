import ArgumentParser
import Foundation
import WorldConquer
import Logging

struct WorldConquerApp: ParsableCommand {
    @Option(name: [.short, .customLong("json")], help: "A JSON file describing the games' world")
    var jsonPath: String?

    @Option(name: .shortAndLong, default: 1, help: "Seconds between every step")
    var stepTime: Int

    @Flag(name: [.long], help: "Show console game")
    var console: Bool

    @Flag(name: [.long], help: "Step won't be saved")
    var test: Bool

    func validate() throws {
        guard stepTime >= 0 else {
            throw ValidationError("StepTime must be a positive number")
        }
    }

    func run() throws {
        let logger = Logger(label: "GameLogs")
        logger.info("Waking up on \(Date())")
        let closenessCalculator = ContinentBoundedClosenessCalculator()
        let winningTerritoryCalculator = RandomWinningTerritoryCalculator()
        var views: [View] = []

        do {
            let localizer: Localizer = try LocalizerImpl(locale: "en", path: "Resources/translations")
            let telegramConfigPath = "\(FileManager.default.currentDirectoryPath)/.telegram"
            if
                let telegramConfigData = try? Data(contentsOf: URL(fileURLWithPath: telegramConfigPath)),
                let telegramConfig = try? JSONDecoder().decode(TelegramConfig.self, from: telegramConfigData) {
                views.append(TelegramView(
                                token: telegramConfig.token,
                                chatId: telegramConfig.chat_id,
                                localizer: localizer))
                logger.info("Telegram enabled")
            }

            if console {
                views.append(ConsoleView(localizer: localizer))
            }

            let game = try SingleStepGame(
                worldFilePath: jsonPath,
                closenessCalculator: closenessCalculator,
                winningTerritoryCalculator: winningTerritoryCalculator,
                views: views,
                logger: logger,
                isTest: test)
            game.start()
        } catch {
            logger.critical("Error initialising game: \(error)")
        }
    }
}

WorldConquerApp.main()
