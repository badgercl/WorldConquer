import Foundation

public protocol WorldPersistency {
    func load(from worldFilePath: String?) -> World?
    func save(world: World)
}

public struct SingleFileWorldPersistency: WorldPersistency {
    private static let savePath = "intermediateSaves"
    private static let saveFile = "\(Self.savePath)/savedStep.json"
    private let jsonWorldProvider: JsonWorldProvider
    public init(jsonWorldProvider: JsonWorldProvider) {
        self.jsonWorldProvider = jsonWorldProvider
    }
    
    public func load(from worldFilePath: String?) -> World? {
        print("Current dir: \(FileManager.default.currentDirectoryPath)")
        if let worldFilePath = worldFilePath {
            return load(path: worldFilePath)
        } else {
            guard FileManager.default.fileExists(atPath: Self.saveFile) else {
                return nil
            }
            return jsonWorldProvider.generate(from: Self.saveFile)
        }
    }

    private func load(path: String) -> World? {
        nil
    }

    public func save(world: World) {
        if !FileManager.default.fileExists(atPath: Self.savePath) {
            try! FileManager.default.createDirectory(atPath: Self.savePath, withIntermediateDirectories: false, attributes: nil)
        }

        let jsonContinents = world.continents.map { continent in
            JsonContinent(
                name: continent.name,
                territories: continent.territories.map { territory in
                    JsonTerritory(
                        name: territory.name,
                        population: territory.population,
                        belongsTo: JsonCountry(name: territory.belongsTo.name))
                })
        }
        let jsonWorld = JsonWorld(age: world.age.description, continents: jsonContinents)
        let data = try! JSONEncoder().encode(jsonWorld)
        try! data.write(to: URL(string: Self.savePath)!)
    }
}
