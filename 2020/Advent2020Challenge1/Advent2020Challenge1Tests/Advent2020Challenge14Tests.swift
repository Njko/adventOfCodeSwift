//
//  Created by Nicolas Linard on 10/12/2020.
//

import XCTest
@testable import Advent2020Challenge1

class MyClass202014 {
    func applyMask(_ maskAsString: String, toInt value: Int) -> Int {
        
        var valueAsString = String(value, radix: 2)
        valueAsString.pad(toSize: maskAsString.count)
        var valueAsArrayOfCharacters = Array(valueAsString)
        let maskAsArrayOfCharacters = Array(maskAsString)
        
        for index in (0..<valueAsArrayOfCharacters.count).reversed() {
            if maskAsArrayOfCharacters[index] == "0" {
                valueAsArrayOfCharacters[index] = "0"
            }
            
            if maskAsArrayOfCharacters[index] == "1" {
                valueAsArrayOfCharacters[index] = "1"
            }
        }
        
        return Int(String(valueAsArrayOfCharacters), radix: 2) ?? 0
    }
    
    func getMemorySpaces(withMask mask: String, andMemoryTarget target: Int) -> Array<Int> {
        
        var targetAsString = String(target, radix: 2)
        targetAsString.pad(toSize: mask.count)
        var targetAsArray = Array(targetAsString)
        let maskAsArrayOfCharacters = Array(mask)
        
        for index in (0..<targetAsArray.count).reversed() {
            if maskAsArrayOfCharacters[index] == "X" {
                targetAsArray[index] = "X"
            }
            
            if maskAsArrayOfCharacters[index] == "1" {
                targetAsArray[index] = "1"
            }
        }
        
        let size = targetAsArray.filter({ $0 == "X"}).count
        let numberOfPossibilities = Int(truncating: NSDecimalNumber(decimal:pow(2, size)))
        
        var possibleMemorySpaces :Array<Int> = []
        
        for possibility in 0..<numberOfPossibilities {
            
            var possibilityAsArray = String(possibility, radix: 2)
            possibilityAsArray.pad(toSize: size)
            var currentPossibility :Array<Character> = []
            var indexOccurence = 0
            
            for char in targetAsArray {
                if char == "X" {
                    currentPossibility.append(possibilityAsArray[indexOccurence])
                    indexOccurence += 1
                } else {
                    currentPossibility.append(char)
                }
            }
            
            possibleMemorySpaces.append(Int(String(currentPossibility), radix: 2) ?? 0)
            
        }
        return possibleMemorySpaces
    }
    
    func executInstructions(_ data: Array<String>, withMemoryMask: Bool = false) -> Int {
        
        var currentMask = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
        
        var memory : Dictionary<Int,Int> = [:]
        
        for instruction in data {
            let maskMatch = instruction.matches(regex: "mask = (.*)")
            let memMatch = instruction.matches(regex: #"^mem\[(.*)\] = (.*)$"#)
            
            if maskMatch.count > 0 {
                currentMask = maskMatch[0]
            }
            
            if memMatch.count > 0 {
                let memorySpace = Int(memMatch[0]) ?? 0
                let value = Int(memMatch[1]) ?? 0
                
                if !withMemoryMask {
                    memory[memorySpace] = applyMask(currentMask, toInt: value)
                } else {
                    let possibleMemorySpaces = getMemorySpaces(withMask: currentMask, andMemoryTarget: memorySpace)
                    for possibleSpace in possibleMemorySpaces {
                        memory[possibleSpace] = value
                    }
                }
            }
        }
        
        return memory.values.reduce(0, +)
    }
    
    
}

class Advent2020Challenge14Tests: XCTestCase {
    
    var myClass: MyClass202014!
    
    override func setUpWithError() throws {
        myClass = MyClass202014()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: PART 1
    func testApplyMask() throws {
        XCTAssertEqual(myClass.applyMask("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X", toInt: 11), 73)
        XCTAssertEqual(myClass.applyMask("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X", toInt: 101), 101)
        XCTAssertEqual(myClass.applyMask("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X", toInt: 0), 64)
    }
    
    func testExecuteExampleInstructions () throws {
        let data = """
        mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
        mem[8] = 11
        mem[7] = 101
        mem[8] = 0
        """
        
        let splittedArray = data.split(separator: "\n").map({ String($0) })
        let result = myClass.executInstructions(splittedArray)
        XCTAssertEqual(result, 165)
    }
    
    func testExecuteInstructions() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_14", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let splittedArray = stringData.split(separator: "\n").map({ String($0) })
            
            let result = myClass.executInstructions(splittedArray)
            XCTAssertEqual(result, 9296748256641)
        } else {
            XCTAssertNotNil(data)
        }
    }
    

    // MARK: PART 2
    
    func testGetPossibleMemorySpace() throws {
        let mask = "000000000000000000000000000000X1001X"
        let target = 42
        let expected = [26,27,58,59]
        let result = myClass.getMemorySpaces(withMask: mask, andMemoryTarget: target)
        XCTAssertEqual(expected, result)
    }
    
    func testGetPossibleMemorySpace2() throws {
        let mask = "00000000000000000000000000000000X0XX"
        let target = 26
        let expected = [16,17,18,19,24,25,26,27]
        let result = myClass.getMemorySpaces(withMask: mask, andMemoryTarget: target)
        XCTAssertEqual(expected, result)
    }
    
    
    func testExecuteInstructionsWithMemoryMask() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_14", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let splittedArray = stringData.split(separator: "\n").map({ String($0) })
            
            let result = myClass.executInstructions(splittedArray, withMemoryMask: true)
            XCTAssertEqual(result, 4877695371685)
        } else {
            XCTAssertNotNil(data)
        }
    }
    
}
