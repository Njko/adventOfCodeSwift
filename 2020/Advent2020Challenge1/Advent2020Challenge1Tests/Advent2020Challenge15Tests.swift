//
//  Created by Nicolas Linard on 10/12/2020.
//

import XCTest
@testable import Advent2020Challenge1

class MyClass202015 {
    func find2020thNumber(_ data : Array<Int>) -> Int {
        
        var turns = data
        turns.append(0) // turn after init is always 0
        for _ in data.count + 2 ...  2020 {
            
            let lastSpokenNumber = turns[turns.count - 1]
            if turns.filter({ $0 == lastSpokenNumber}).count > 1 {
                turns.append(findDifferenceOfIndex(turns, forNumber: lastSpokenNumber))
            } else {
                turns.append(0)
            }
        }
        return turns[2019]
    }
    
    func findDifferenceOfIndex(_ data : Array<Int>, forNumber: Int) -> Int {
        
        var firstFoundMatch = -1
        
        for index in (0 ..< data.count).reversed() {
            if data[index] == forNumber {
                if firstFoundMatch < 0 {
                    firstFoundMatch = index
                } else {
                    return firstFoundMatch - index
                }
            }
        }
        
        return -1 // could find any lastspoken numbers
    }
    
    func findNthNumber(_ data : Array<Int>, numberOfTurns: Int) -> Int {
        
        var spokenNumber: Dictionary<Int, (Int, Int)> = [:]
        var isNewInsert = false
        
        for index in 0 ..< data.count {
            spokenNumber[data[index]] = (-1 , index)
        }
        
        //Try to initiate the turn after init
        if spokenNumber.keys.contains(0) {
            spokenNumber[0] = (spokenNumber[0]?.1 ?? 0, data.count)
            isNewInsert = false
        } else {
            spokenNumber[0] = (-1, data.count)
            isNewInsert = true
        }
        var lastSpokenNumber = 0
        
        //For the other turns
        for turn in data.count + 2 ... numberOfTurns {
            let infos = spokenNumber[lastSpokenNumber] ?? (0,0) // will always return a pair
            if isNewInsert {
                spokenNumber[0] = (spokenNumber[0]?.1 ?? 0, turn - 1)
                lastSpokenNumber = 0
                isNewInsert = false
                
            } else {
                lastSpokenNumber = infos.1 - infos.0
                if spokenNumber.keys.contains(lastSpokenNumber) {
                    spokenNumber[lastSpokenNumber] = (spokenNumber[lastSpokenNumber]?.1 ?? 0, turn - 1)
                    isNewInsert = false
                } else {
                    spokenNumber[lastSpokenNumber] = (-1, turn - 1)
                    isNewInsert = true
                }
            }
        }
        
        return lastSpokenNumber
    }
}

class Advent2020Challenge15Tests: XCTestCase {
    
    var myClass: MyClass202015!
    
    override func setUpWithError() throws {
        myClass = MyClass202015()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: PART 1
    
    func testExamples() {
        XCTAssertEqual(myClass.find2020thNumber([0,3,6]), 436)
        XCTAssertEqual(myClass.find2020thNumber([1,3,2]), 1)
        XCTAssertEqual(myClass.find2020thNumber([2,1,3]), 10)
        XCTAssertEqual(myClass.find2020thNumber([1,2,3]), 27)
        XCTAssertEqual(myClass.find2020thNumber([2,3,1]), 78)
        XCTAssertEqual(myClass.find2020thNumber([3,2,1]), 438)
        XCTAssertEqual(myClass.find2020thNumber([3,1,2]), 1836)
    }
        
    func testFind2020thNumber() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_15", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let splittedArray = stringData.split(separator: "\n").map({ String($0)})
            let splittedData = splittedArray[0].split(separator: ",").map({ Int($0) ?? 0})
            
            let result = myClass.find2020thNumber(splittedData)
            XCTAssertEqual(result, 203)
        } else {
            XCTAssertNotNil(data)
        }
    }
    

    // MARK: PART 2
    
    func testExamplesPart2() {
        XCTAssertEqual(myClass.findNthNumber([0,3,6], numberOfTurns: 2020), 436)
        XCTAssertEqual(myClass.findNthNumber([0,3,6], numberOfTurns: 30000000), 175594)
        XCTAssertEqual(myClass.findNthNumber([1,3,2], numberOfTurns: 30000000), 2578)
        XCTAssertEqual(myClass.findNthNumber([2,1,3], numberOfTurns: 30000000), 3544142)
        XCTAssertEqual(myClass.findNthNumber([1,2,3], numberOfTurns: 30000000), 261214)
        XCTAssertEqual(myClass.findNthNumber([2,3,1], numberOfTurns: 30000000), 6895259)
        XCTAssertEqual(myClass.findNthNumber([3,2,1], numberOfTurns: 30000000), 18)
        XCTAssertEqual(myClass.findNthNumber([3,1,2], numberOfTurns: 30000000), 362)
    }
    
    
    func testFindNthNumber() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_15", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let splittedArray = stringData.split(separator: "\n").map({ String($0)})
            let splittedData = splittedArray[0].split(separator: ",").map({ Int($0) ?? 0})
            
            let result = myClass.findNthNumber(splittedData, numberOfTurns: 30000000)
            XCTAssertEqual(result, 9007186)
        } else {
            XCTAssertNotNil(data)
        }
    }
    
}
