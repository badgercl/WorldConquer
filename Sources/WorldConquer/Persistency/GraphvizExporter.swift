import Foundation

struct GraphvizExporter {
    private let styleGenerator: StyleGenerator
    private let path: String

    init(
        filePathManager: FilePathManager = FilePathManager(),
        styleGenerator: StyleGenerator = StyleGenerator()
    ) {
        self.styleGenerator = styleGenerator
        self.path = "\(filePathManager.folderFor("grapviz"))"
    }

    func export(world: World, name: String) {
        let continents = world.continents
            .map { continent -> String in
                let territories = continent.territories
                    .map(\.name)
                    .map { $0.replacingOccurrences(of: "\"", with: "") }
                    .reduce("", { previous, territoryName in
                        "\(previous)\"\(territoryName)\"\n"
                    })
                return """
                subgraph \"cluster_\(continent.name)\" {
                label = "\(continent.name)\";
                \(territories)
                }
                """
            }.joined(separator: "\n")

        let countries = world.countries
            .filter{ $0.territories.count > 0 }
            .sorted(by: { $0.territories.count > $1.territories.count })
            .map(\.name)
            .map { $0.replacingOccurrences(of: "\"", with: "") }
            .reduce("", { "\($0)\"\($1)\" \(self.styleGenerator.style())\n" })

        let graph = world.countries
            .filter {
                $0.territories.count > 1
                || ($0.territories.count == 1 && $0.territories.first?.name != $0.name) }
            .map { country in
                country.territories
                    .map(\.name)
                    .map { $0.replacingOccurrences(of: "\"", with: "") }
                    .reduce("") { previous, territoryName in
                        "\(previous)\"\(country.name)\"->\"\(territoryName)\" [fillcolor=\"#a6cee3\" color=\"#1f78b4\"];\n"
                    }
            }
        .joined()

        let dot = """
        strict digraph {
        \(continents)
        \(countries)
        \(graph)
        }
        """

        _ = try! dot.write(toFile: "\(path)/\(name).gv", atomically: true, encoding: .utf8)
    }
}

final class StyleGenerator {
    func style() -> String {
        "[shape=\"ellipse\" style=\"filled\" fillcolor=\"#47a2c6\"]"
    }
}
