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
            let config = ConfigurationProvider.loadConfiguration()
            let localizer: Localizer = try configureLocalizer(
                localizationConfig: config?.localization,
                logger: logger)

            if let telegramView = configureTelegram(
                telegramConfig: config?.telegram) {
                views.append(telegramView)
                logger.info("Telegram enabled")
            }

            if console {
                views.append(ConsoleView())
            }

            let gameSettings = GameSettings(moreInfoURL: config?.general?.moreInfoURL)
            let gameViewStateMapper = GameViewStateMapperImpl(config: gameSettings, localizer: localizer)

            let game = try SingleStepGame(
                worldFilePath: jsonPath,
                closenessCalculator: closenessCalculator,
                winningTerritoryCalculator: winningTerritoryCalculator,
                views: views,
                logger: logger,
                isTest: test,
                gameViewStateMapper: gameViewStateMapper)
//            let game = try MultiStepGame(
//                worldFilePath: jsonPath,
//                closenessCalculator: closenessCalculator,
//                winningTerritoryCalculator: winningTerritoryCalculator,
//                views: views,
//                logger: logger,
//                stepTime: 0,
//                gameViewStateMapper: gameViewStateMapper)

            game.start()

        } catch {
            logger.critical("Error initialising game: \(error)")
        }
    }

    private func configureLocalizer(localizationConfig: LocalizationConfig?, logger: Logger) throws -> Localizer {
        var locale: String = "en"
        var path: String = "Resources/translations"
        if let localizationConfig = localizationConfig {
            locale = localizationConfig.locale
            path = localizationConfig.path
        }

        logger.info("Initialising localizer with locale: \(locale) from \(path)")
        return try LocalizerImpl(
            locale: locale,
            path: path)
    }

    private func configureTelegram(telegramConfig: TelegramConfig?) -> TelegramView? {
        guard let telegramConfig = telegramConfig else {
            return nil
        }
        return TelegramView(
            token: telegramConfig.token,
            chatId: telegramConfig.chat_id)
    }
}

WorldConquerApp.main()
