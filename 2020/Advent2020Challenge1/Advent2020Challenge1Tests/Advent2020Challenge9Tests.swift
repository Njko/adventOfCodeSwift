//
//  Created by Nicolas Linard on 09/12/2020.
//

import XCTest
@testable import Advent2020Challenge1

class MyClass202009 {
    
    func getSumsOfPreamble(_ data: ArraySlice<UInt>) -> Set<UInt> {
        let combinedData = data
        var possibleResults: Set<UInt> = Set([])
        
        for value in data {
            for combinedValue in combinedData {
                if value != combinedValue {
                    possibleResults.insert(value + combinedValue)
                }
            }
        }
        
        return possibleResults
    }
    
    func isValidInput(_ input:UInt,_ sumOfPreamble: Set<UInt>) -> Bool{
        return sumOfPreamble.contains(input)
    }
    
    func getFirstInvalidNumber(_ data: Array<UInt>, preambleSize: Int) -> UInt {
        
        var index : Int = Int(preambleSize)
        repeat {
            let preamble = data[index - preambleSize ..< index]
            let sum = getSumsOfPreamble(preamble)
            if !isValidInput(data[index], sum) {
                return data[index]
            }
            index += 1
        } while index < data.count
        return 0
    }
    
    func getEncryptionWeakness(_ data: Array<UInt>, preambleSize: Int) -> Int {
        
        if data.count < 2 {
            return -99
        }
        
        var startIndex = 0
        var endIndex = 1
        let firstInvalidNumber = getFirstInvalidNumber(data, preambleSize: preambleSize)
        var sumOfSubset = data[startIndex...endIndex].reduce(0,+)
        var loops = 1
        
        while endIndex < data.count {
            if sumOfSubset == firstInvalidNumber {
                break
            }
            
            if sumOfSubset < firstInvalidNumber {
                endIndex += 1
                sumOfSubset += data[endIndex]
            } else {
                sumOfSubset -= data[startIndex]
                startIndex += 1
            }
            loops += 1
        }
        
        print("done \(loops) loops")
        return Int((data[startIndex...endIndex].min() ?? 0) + (data[startIndex...endIndex].max() ?? 0))
    }
    
    func addAllValues(_ slice :ArraySlice<UInt> ) -> UInt {
        var sum:UInt = 0
        for value in slice {
            sum += value
        }
        return sum
    }
}

class Advent2020Challenge9Tests: XCTestCase {
    
    var myClass: MyClass202009!
    
    override func setUpWithError() throws {
        myClass = MyClass202009()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testListOfPossibleResultsOfSum() throws {
        
        let stringData = "1\n2\n3\n4\n5\n6"
        
        let possibleResults = "3\n4\n5\n6\n7\n8\n9\n10\n11"
        let splittedArray = stringData.split(separator: "\n").map({UInt($0) ?? 0})
        let result : Set<UInt> = myClass.getSumsOfPreamble(splittedArray[0..<splittedArray.count])
        let splittedResults : Set<UInt> = Set(possibleResults.split(separator: "\n").map({UInt($0) ?? 0}))
        XCTAssertEqual(result, splittedResults)
    }
    
    func testExample() throws {
        let stringData = "1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11\n12\n13\n14\n15\n16\n17\n18\n19\n20\n21\n22\n23\n24\n25"
        
        let splittedArray = stringData.split(separator: "\n").map({UInt($0) ?? 0})
        let result : Set<UInt> = myClass.getSumsOfPreamble(splittedArray[0..<splittedArray.count])
        
        XCTAssertTrue(myClass.isValidInput(26, result))
        XCTAssertTrue(myClass.isValidInput(49, result))
        XCTAssertFalse(myClass.isValidInput(100, result))
        XCTAssertFalse(myClass.isValidInput(50, result))
    }
    
    func testExample2() throws {
        let stringData = "1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11\n12\n13\n14\n15\n16\n17\n18\n19\n21\n22\n23\n24\n25\n45"
        
        let splittedArray = stringData.split(separator: "\n").map({UInt($0) ?? 0})
        let result : Set<UInt> = myClass.getSumsOfPreamble(splittedArray[0..<splittedArray.count])
        
        XCTAssertTrue(myClass.isValidInput(26, result))
        XCTAssertFalse(myClass.isValidInput(65, result))
        XCTAssertTrue(myClass.isValidInput(64, result))
        XCTAssertTrue(myClass.isValidInput(66, result))
    }
    
    func testExample3() throws {
        let stringData = "35\n20\n15\n25\n47\n40\n62\n55\n65\n95\n102\n117\n150\n182\n127\n219\n299\n277\n309\n576"
        
        let splittedArray = stringData.split(separator: "\n").map({UInt($0) ?? 0})
        let result = myClass.getFirstInvalidNumber(splittedArray,preambleSize: 5)
        XCTAssertEqual(result, 127)
    }
    
    func testGetFirstInvalidNumber() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_9", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let splittedArray = stringData.split(separator: "\n").map({UInt($0) ?? 0})
            XCTAssertNotNil(splittedArray)
            
            let result = myClass.getFirstInvalidNumber(splittedArray,preambleSize: 25)
            XCTAssertEqual(result, 57195069)
        } else {
            XCTAssertNotNil(data)
        }
    }
    
    func testExample4() throws {
        let stringData = "35\n20\n15\n25\n47\n40\n62\n55\n65\n95\n102\n117\n150\n182\n127\n219\n299\n277\n309\n576"
        
        let splittedArray = stringData.split(separator: "\n").map({UInt($0) ?? 0})
        let result = myClass.getEncryptionWeakness(splittedArray,preambleSize: 5)
        XCTAssertEqual(result, 62)
    }
    
    func testGetEncryptionWeakness() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_9", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let splittedArray = stringData.split(separator: "\n").map({UInt($0) ?? 0})
            XCTAssertNotNil(splittedArray)
            
            let result = myClass.getEncryptionWeakness(splittedArray,preambleSize: 25)
            XCTAssertEqual(result, 7409241)
        } else {
            XCTAssertNotNil(data)
        }
    }
}
