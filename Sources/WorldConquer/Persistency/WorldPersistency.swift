import Foundation

public protocol WorldPersistency {
    func load() -> World?
    func save(world: World)
}

public struct SingleFileWorldPersistency: WorldPersistency {
    private static let savePath = "intermediateSaves"
    private static let saveFile = "\(Self.savePath)/savedStep.json"
    public init() {}
    
    public func load() -> World? {
        print("Current dir: \(FileManager.default.currentDirectoryPath)")
        guard FileManager.default.fileExists(atPath: Self.saveFile) else {
            return nil
        }
        let data = try! String(contentsOfFile:  Self.saveFile).data(using: .utf8)
        let jsonDecoder = JSONDecoder()
        let jsonContinents = try! jsonDecoder.decode([JsonContinent].self, from: data!)

        return nil
    }

    public func save(world: World) {
        if !FileManager.default.fileExists(atPath: Self.savePath) {
            try! FileManager.default.createDirectory(atPath: Self.savePath, withIntermediateDirectories: false, attributes: nil)
        }
    }
}
