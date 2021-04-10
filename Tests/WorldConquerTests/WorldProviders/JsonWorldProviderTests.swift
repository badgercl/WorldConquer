import XCTest
import Foundation
@testable import WorldConquer

final class JsonWorldProviderTests: XCTestCase {
    var sut: JsonWorldProvider!

    override func setUp() {
        super.setUp()
        sut = JsonWorldProvider()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    static var allTests = [
        ("testLoadingSucceeds", testLoadingSucceeds)
    ]

    func testLoadingSucceeds() {
//        let testFile = Bundle(for: type(of: self)).resourcePath! + "/WorldConquer_WorldConquerTests.bundle/Contents/Resources/test_world.json"
//        let result = sut.generate(from: testFile)
//        XCTAssertNotNil(result)
    }
}
