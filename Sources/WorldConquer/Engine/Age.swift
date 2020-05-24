//
//  File.swift
//  
//
//  Created by Alfredo Cadiz on 24.05.20.
//

import Foundation

public protocol Age {
    func nextAge() -> Age
    var description: String { get }
}

struct LinearAge: Age {
    let age: Int

    public init(age: Int = 0) {
        self.age = age
    }

    public func nextAge() -> Age {
        return LinearAge(age: age + 1)
    }

    var description: String {
        "\(age)"
    }
}
