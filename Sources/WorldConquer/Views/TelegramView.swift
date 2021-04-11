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

    private func showStartGame(_ viewState: StartViewState) {
        let text =  """
        \(viewState.header) \(viewState.body)

        \(viewState.worldDescription)
        """
        sendMessage(text: text)
    }

    private func showStepState(_ viewState: StepViewState) {
        var text = viewState.conquer
        if let defeated = viewState.defeated {
            text += " \(defeated)"
        }

        text += "\n\n\(viewState.topEmpires)"

        if let moreInfo = viewState.moreInfo {
            text += "\n\n\(moreInfo)"
        }
        sendMessage(text: text)
    }

    private func showWinner(_ viewState: WinnerViewState) {
        sendMessage(text: viewState.gameEndMessage)
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

