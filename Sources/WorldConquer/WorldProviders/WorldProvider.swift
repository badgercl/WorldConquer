import Foundation

public protocol WorldProvider {
    func generate() -> World
}

protocol WorldLoader {
    func load() -> World
}

struct JsonCountry: Decodable {
    let name: String
}

struct JsonTerritory: Decodable {
    let name: String
    let population: Int
    let belongsTo: JsonCountry
}

struct JsonContinent: Decodable {
    let name: String
    let territories: [JsonTerritory]
}
