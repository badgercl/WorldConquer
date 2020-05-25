import Foundation

public struct TelegramView: View {
    private let path: String
    private let chatId: String

    public init(token: String, chatId: String) {
        path = "https://api.telegram.org/bot\(token)/sendMessage"
        self.chatId = chatId
    }

    public func render(_ viewState: ViewState) {
        switch viewState {
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

    private func showStepState(_ stepState: StepState) {
        let worldStatus: String = stepState
            .world
            .countries
            .sorted { $0.territories.count > $1.territories.count }
            .filter { $0.territories.count > 1 }
            .prefix(10)
            .map {
                let territories = $0.territories.map(\.name).joined(separator: ", ")
                return " - *\($0.name)* (\($0.territories.count): [\(territories)]"
            }
            .joined(separator: "\n")
        let text = "In year: \(stepState.world.age.description), *\(stepState.winner.name)* conquered *\(stepState.winner.name)* which was previously occupied by \(stepState.looser.name)\nWorld Status (countries) with more than 1 territory):\n\(worldStatus)"
        sendMessage(text: text)
    }

    private func showWinner(_ winner: Country) {
        let text = "Ganador: \(winner.name)"
        sendMessage(text: text)
    }

    private func sendMessage(text: String) {
        var urlRequest = URLRequest(url: URL(string: path)!)
        let json: [String: Any] = [
            "chat_id": chatId,
            "text": text
        ]
        let data = try! JSONSerialization.data(withJSONObject: json)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = data
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            let dataString: String
            if let data = data {
                dataString = String(data: data, encoding: .utf8)!
            } else {
                dataString = "no data"
            }

            print("data: \(dataString)")
            print("response: \(String(describing: response))")
            print("error: \(String(describing: error))")
        }
        session.resume()
    }
}
