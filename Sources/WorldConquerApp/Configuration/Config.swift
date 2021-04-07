import Foundation

struct ConfigurationProvider {
    private static let configFilePath = "\(FileManager.default.currentDirectoryPath)/.worldconquer.json"

    static func loadConfiguration() -> Configuration? {
        guard
            let configData = try? Data(contentsOf: URL(fileURLWithPath: configFilePath)),
            let config = try? JSONDecoder().decode(Configuration.self, from: configData) else {
            return nil
        }
        return config
    }
}

struct Configuration: Decodable {
    let telegram: TelegramConfig?
    let localization: LocalizationConfig?
}

struct TelegramConfig: Decodable {
    let token: String
    let chat_id: String
}

struct LocalizationConfig: Decodable {
    let locale: String
    let path: String
}
