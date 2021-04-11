import Foundation

struct StepExporter {
    private let path: String
    init(filePathManager: FilePathManager = FilePathManager()) {
        self.path = "\(filePathManager.getOrCreateFolderFor("step_exporter"))/steps.csv"
    }

    func export(stepState: StepState) {
        var data = (try? String(contentsOfFile: path)) ?? "Year,Creme,Territories"
        let topCountries: String = stepState
            .world
            .countries
            .sorted { $0.territories.count > $1.territories.count }
            .filter { $0.territories.count > 1 }
            .prefix(10)
            .map {
                "\(stepState.world.age.withPadding)-01-01,\($0.name),\($0.territories.count)"
            }
            .joined(separator: "\n")
        data = "\(data)\n\(topCountries)"
        logInfo(data)
        _ = try! data.write(toFile: path, atomically: true, encoding: .utf8)
    }
}
