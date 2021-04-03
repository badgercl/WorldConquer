import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public struct TelegramView: View {
    private static let maxTelegramCharCount = 4000
    private let path: String
    private let chatId: String

    public init(token: String, chatId: String) {
        path = "https://api.telegram.org/bot\(token)/sendMessage"
        self.chatId = chatId
    }

    public func render(_ viewState: ViewState) {
        logInfo("Telegram render: \(viewState)")
        switch viewState {
        case .start(let world):
            showStartGame(world)
        case .error:
            break
        case .step(let stepViewState):
            showStepState(stepViewState)
        case .winner(let winner):
            showWinner(winner)
        }
    }

    private func showError() {
        sendMessage(text: "An error occured, the games is over")
    }

    private func showStartGame(_ world: World) {
        let worldStatus: String = world.continents.map { "- *\($0.name) \($0.countries.count)*: [\($0.countries.map(\.name).joined(separator: ", "))]" }.joined(separator: "\n")
        let text = "Game started. Initial World:\n\n\(worldStatus)"
        sendMessage(text: text)
    }

    private func showStepState(_ stepState: StepState) {
        let worldStatus: String = stepState
            .world
            .countries
            .sorted { $0.territories.count > $1.territories.count }
            .filter { $0.territories.count > 1 }
            .prefix(10)
            .map {
                let territories = $0.territories.map(\.name).joined(separator: ", ")
                return " - *\($0.name)* (\($0.territories.count)): [\(territories)]"
            }
            .joined(separator: "\n")
        let text = "In year \(stepState.world.age.description), *\(stepState.winner.name)* conquered *\(stepState.territory.name)* which was previously occupied by *\(stepState.looser.name)*\nWorld Status for countries with more than 1 territory:\n\(worldStatus)"
        sendMessage(text: text)
    }

    private func showWinner(_ winner: Country) {
        let text = "\(winner.name) has conquered the world!"
        sendMessage(text: text)
    }

    private func sendMessage(text: String) {
        guard text.count > Self.maxTelegramCharCount else {
            sendChunkMessage(text: text)
            return
        }
        var chunk: String = ""
        text
            .split(separator: "\n")
            .forEach {
                if chunk.count > Self.maxTelegramCharCount {
                    sendChunkMessage(text: chunk)
                    chunk = ""
                }
                chunk += "\($0)\n"
        }
    }

    private func sendChunkMessage(text: String) {
        var urlRequest = URLRequest(url: URL(string: path)!)
        let json: [String: Any] = [
            "chat_id": chatId,
            "text": text,
            "parse_mode": "markdown"
        ]
        let data = try! JSONSerialization.data(withJSONObject: json)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = data
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let semaphore = DispatchSemaphore(value: 0)
        let session = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                logError("error: \(error)")
                return
            }
            guard let data = data else {
                return logError("Telegram: No error and no data received")
            }

            let decoder = JSONDecoder()
            guard let tgResponse = try? decoder.decode(TelegramResponse.self, from: data) else {
                return logError("Telegram: impossible to decode response")
            }

            if tgResponse.ok {
                logInfo("Telegram: message successfully sent")
            } else if let tgError = try? decoder.decode(TelegramErrorResponse.self, from: data) {
                logError("Telegram error: \(tgError)")
            } else {
                logError("Telegram error not available")
            }
            semaphore.signal()
        }
        session.resume()
        semaphore.wait()
    }
}

private struct TelegramResponse: Decodable {
    let ok: Bool
}

private struct TelegramErrorResponse: Decodable {
    let ok: Bool
    let error_code: Int
    let description: String
}

