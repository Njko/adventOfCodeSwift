//
//  Created by Nicolas Linard on 10/12/2020.
//

import XCTest
@testable import Advent2020Challenge1

class MyClass202010 {
    
    func getJoltDifferenceMultiplied(_ data: Array<Int>) -> Int {
        
        let orderedData = getOrderedListOfJolts(data)
        let differences = getNumberOfDifferences(orderedData)
        
        return differences.0 * differences.1
    }
    
    func getNumberOfDifferences(_ data: Array<Int>) -> (Int,Int) {
        let result = data.reduce((number1JoltDifference: 0,
                                  number3JoltDifference: 0,
                                  lastJolt: data.max() ?? 0), { counts, jolt in
                                    let difference = counts.lastJolt - jolt
                                    if difference  == 3 {
                                        return (counts.number1JoltDifference, counts.number3JoltDifference + 1,jolt)
                                    }
                                    if difference == 1 {
                                        return (counts.number1JoltDifference + 1,  counts.number3JoltDifference ,jolt)
                                    }
                                    
                                    return (counts.number1JoltDifference, counts.number3JoltDifference, jolt)
                                  })
        return (result.number1JoltDifference, result.number3JoltDifference)
    }
    
    func getOrderedListOfJolts(_ data: Array<Int>) -> Array<Int> {
        var orderedData = data
        orderedData.sort(by: >)
        orderedData.insert((orderedData.max() ?? 0) + 3, at: 0)
        orderedData.append(0)
        return orderedData
    }
    
    //Translated from Kotlin
    //https://www.reddit.com/r/adventofcode/comments/ka8z8x/2020_day_10_solutions/gf9qe1g/?utm_source=reddit&utm_medium=web2x&context=3
    func getNumberOfPossibleReductions(_ data: Array<Int>) -> Int {
        let cleanedData = getOrderedListOfJolts(data)
        
        var options = [Int](repeating: 0,count: cleanedData.count-1)
        options[options.count - 1] = 1
        
        let newCleanedData = cleanedData.sorted(by: <)
        
        for indexOfLastValue in (0...(newCleanedData.count - 3)).reversed() {
            var currentOptions = 0
            for index in (indexOfLastValue ..< min(indexOfLastValue+4, newCleanedData.count)){
                let highestValue = newCleanedData[index]
                let lowestValue = newCleanedData[indexOfLastValue]
                if highestValue - lowestValue <= 3 {
                    currentOptions += 1
                    currentOptions += options[index] - 1
                }
            }
            options[indexOfLastValue] = currentOptions
        }
        
        return options[0]
    }
    
    //Not used, but was created to check a list of items that could be removed
    func getRemovableValues(_ cleanedData : Array<Int>) -> Array<Int> {
        var safeValuesWithDifferenceOf1WithNeighbor: Array<Int> = []
        var index = 1
        
        while index + 1 < cleanedData.count {
            let previousValue = cleanedData[index - 1]
            let value = cleanedData[index]
            let nextValue = cleanedData[index + 1]
            
            if (previousValue - nextValue > 3) {
                safeValuesWithDifferenceOf1WithNeighbor.append(value)
            } else {
                let subset = Set(cleanedData[index+1 ..< cleanedData.count])
                if subset.contains(value - 3) {
                    safeValuesWithDifferenceOf1WithNeighbor.append(value)
                }
            }
            index += 1
        }
        
        safeValuesWithDifferenceOf1WithNeighbor.sort(by: >)
        safeValuesWithDifferenceOf1WithNeighbor.append(0)
        safeValuesWithDifferenceOf1WithNeighbor.insert(cleanedData.max() ?? 0, at: 0)
        
        let result = Set(cleanedData).subtracting(Set(safeValuesWithDifferenceOf1WithNeighbor))
        return result.sorted(by: <)
    }
}

class Advent2020Challenge10Tests: XCTestCase {
    
    var myClass: MyClass202010!
    
    override func setUpWithError() throws {
        myClass = MyClass202010()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        let result = myClass.getJoltDifferenceMultiplied([16,10,15,5,1,11,7,19,6,12,4])
        XCTAssertEqual(result, 35)
    }
    
    func testExample2() throws {
        let result = myClass.getJoltDifferenceMultiplied([28,33,18,42,31,14,46,20,48,47,24,23,49,45,19,38,39,11,1,32,25,35,8,17,7,9,4,2,34,10,3])
        XCTAssertEqual(result, 220)
    }
    
    func testGetOrderedListAndMaxJolt() throws {
        let result = myClass.getOrderedListOfJolts([16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4])
        XCTAssertEqual(result, [22, 19, 16, 15, 12, 11, 10, 7, 6, 5, 4, 1, 0])
    }
    
    func testGetJoltDifference() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_10", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let splittedArray = stringData.split(separator: "\n").map({Int($0) ?? 0})
            XCTAssertNotNil(splittedArray)
            
            let result = myClass.getJoltDifferenceMultiplied(splittedArray)
            XCTAssertEqual(result, 2232)
        } else {
            XCTAssertNotNil(data)
        }
    }
    
    func testExample3() throws {
        let result = myClass.getNumberOfPossibleReductions([16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4])
        XCTAssertEqual(result, 8)
    }
    
    func testExample4() throws {
        let result = myClass.getNumberOfPossibleReductions([28,33,18,42,31,14,46,20,48,47,24,23,49,45,19,38,39,11,1,32,25,35,8,17,7,9,4,2,34,10,3])
        XCTAssertEqual(result, 19208)
    }
    
    func testGetNumberOfPossibleReductions() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_10", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let splittedArray = stringData.split(separator: "\n").map({Int($0) ?? 0})
            XCTAssertNotNil(splittedArray)
            
            let result = myClass.getNumberOfPossibleReductions(splittedArray)
            XCTAssertEqual(result, 173625106649344)
        } else {
            XCTAssertNotNil(data)
        }
    }
}
