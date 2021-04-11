import Foundation

public protocol Localizer {
    func localize(keyPath: KeyPath<LocalizationData, String>) -> String
    func localize(keyPath: KeyPath<LocalizationData, String>, withReplacements: [String: String]) -> String
}

public extension Localizer {
    func localize(keyPath: KeyPath<LocalizationData, String>) -> String {
        localize(keyPath: keyPath, withReplacements: [:])
    }
}

public enum LocalizerError: Error {
    case invalidPath
    case localisationNotFound
    case invalidFileFormat
}

public struct LocalizerImpl: Localizer {
    private let localizationData: LocalizationData

    public init(locale: String, path: String, filePathManager: FilePathManager = FilePathManager()) throws {
        guard let path = filePathManager.getFolder(for: path) else {
            throw LocalizerError.invalidPath
        }

        let localizationFile = "\(path)/\(locale).json"
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: localizationFile)) else {
            throw LocalizerError.localisationNotFound
        }

        guard let localizationData = try? JSONDecoder().decode(LocalizationData.self, from: data) else {
            throw LocalizerError.invalidFileFormat
        }

        self.localizationData = localizationData
    }

    public func localize(keyPath: KeyPath<LocalizationData, String>, withReplacements replacements: [String: String] = [:]) -> String {
        var text = localizationData[keyPath: keyPath]
        replacements.forEach { key, value in
            text = text.replacingOccurrences(of: "%{\(key)}", with: value)
        }
        
        return text
    }
}

public struct LocalizationData: Decodable {
    let gameStartedHeader: String
    let gameStartedBody: String
    let gameStepConquer: String
    let gameStepTop: String
    let gameStepDefeated: String
    let gameStepMoreInfo: String
    let gameEndedWinner: String
    let gameError: String

    enum CodingKeys: String, CodingKey {
        case gameStartedHeader = "game_started_header"
        case gameStartedBody = "game_started_body"
        case gameStepConquer = "game_step_conquer"
        case gameStepTop = "game_step_top"
        case gameStepDefeated = "game_step_defeated"
        case gameStepMoreInfo = "game_step_more_info"
        case gameEndedWinner = "game_ended_winner"
        case gameError = "game_error"
    }
}
