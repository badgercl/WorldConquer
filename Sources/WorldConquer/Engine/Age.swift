import Foundation

public protocol Age: Codable {
    func nextAge() -> Age
    var withPadding: String { get }
    var description: String { get }
}

struct LinearAge: Age {
    let age: Int

    public init(age: Int = 0) {
        self.age = age
    }

    public init(age: String) {
        if let intAge = Int(age) {
            self.age = intAge
        } else {
            self.age = 0
        }
    }

    public func nextAge() -> Age {
        LinearAge(age: age + 1)
    }

    var withPadding: String {
        String(format: "%04d", age)
    }

    var description: String {
        "\(age)"
    }
}
