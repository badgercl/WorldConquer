import Foundation

public protocol WorldProvider {
    func generate() -> World
}

protocol WorldLoader {
    func load() -> World
}

struct JsonWorld: Codable {
    let age: Int
    let continents: [JsonContinent]
}

struct JsonCountry: Codable {
    let name: String
}

struct JsonTerritory: Codable {
    let name: String
    let population: Int
    let belongsTo: JsonCountry
}

struct JsonContinent: Codable {
    let name: String
    let territories: [JsonTerritory]
}
