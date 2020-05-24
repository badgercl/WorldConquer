import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(JsonWorldProviderTests.allTests),
        testCase(RandomClosenessTests.allTests),
        testCase(RandomWinningTerritoryCalculatorTests.allTests),
        testCase(EngineTests.allTests),
        testCase(ContinentTests.allTests),
        testCase(CountryTests.allTests),
        testCase(TerritoryTests.allTests),
        testCase(JsonWorldProviderTests.allTests)
    ]
}
#endif
