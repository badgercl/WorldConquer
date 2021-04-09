import Foundation

public protocol WorldPersistency {
    func load(from worldFilePath: String?) -> World?
    func save(world: World)
}

public struct SingleFileWorldPersistency: WorldPersistency {
    private let savePath: String
    private let saveFile: String
    private let jsonWorldProvider: JsonWorldProvider

    public init(
        jsonWorldProvider: JsonWorldProvider,
        label: String = "intermediateSaves",
        filePathManager: FilePathManager = FilePathManager()
    ) {
        self.jsonWorldProvider = jsonWorldProvider
        savePath = filePathManager.getOrCreateFolderFor(label)
        saveFile = "\(savePath)/savedStep.json"
    }
    
    public func load(from worldFilePath: String?) -> World? {
        if let worldFilePath = worldFilePath {
            logInfo("worldFilePath dir: \(FileManager.default.currentDirectoryPath)/\(worldFilePath)")
            return jsonWorldProvider.generate(from: "\(FileManager.default.currentDirectoryPath)/\(worldFilePath)")
        } else {
            guard FileManager.default.fileExists(atPath: saveFile) else {
                return nil
            }
            return jsonWorldProvider.generate(from: saveFile)
        }
    }

    public func save(world: World) {
        if !FileManager.default.fileExists(atPath: savePath) {
            try! FileManager.default.createDirectory(atPath: savePath, withIntermediateDirectories: false, attributes: nil)
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
        let datePathFile = "\(savePath)/\(Date().formatedDateForFile).json"

        try! save(path: datePathFile, data: data) // history
        try! save(path: saveFile, data: data) // current step save
    }

    private func save(path: String, data: Data) throws {
        logInfo("Saving world to \(path)")
        let url = URL(fileURLWithPath: path, isDirectory: false)
        try data.write(to: url)
    }
}
