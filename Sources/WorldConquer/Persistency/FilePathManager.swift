import Foundation

public struct FilePathManager {
    private let baseFolder: String

    public init(baseFolder: String = FileManager.default.currentDirectoryPath) {
        self.baseFolder = baseFolder
    }

    func getFolder(for label: String) -> String? {
        let folder = "\(baseFolder)/\(label)"
        guard FileManager.default.fileExists(atPath: folder) else {
            return nil
        }
        return folder
    }

    func getOrCreateFolderFor(_ label: String) -> String {
        let folder = "\(baseFolder)/\(label)"
        if !FileManager.default.fileExists(atPath: folder) {
            logInfo("Creating \(folder)")
            try! FileManager.default.createDirectory(
                atPath: folder,
                withIntermediateDirectories: false,
                attributes: nil)
        }
        return folder
    }
}
