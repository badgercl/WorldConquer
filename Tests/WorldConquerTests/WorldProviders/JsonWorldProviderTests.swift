import XCTest
import Foundation
@testable import WorldConquer

final class JsonWorldProviderTests: XCTestCase {
    var sut: JsonWorldProvider!

    override func setUp() {
        super.setUp()
        sut = JsonWorldProvider(path: "earth.json")
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    static var allTests = [
        ("testLoadingSucceeds", testLoadingSucceeds)
    ]

    func testLoadingSucceeds() {
        let result = sut.generate()
        XCTAssertNotNil(result)
    }
}
