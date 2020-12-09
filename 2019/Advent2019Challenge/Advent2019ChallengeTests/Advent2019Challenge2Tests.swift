//
//  Advent2020Challenge1Tests.swift
//  Advent2020Challenge1Tests
//
//  Created by Nicolas Linard on 01/12/2020.
//

import XCTest
@testable import Advent2019Challenge

class MyClass201902 {
    
    func executeProgram(_ program: Array<Int>, withNoun noun:Int? = nil, andVerb verb: Int? = nil) -> Array<Int> {
        
        var index = 0
        
        var programToExecute = program
        if let noun = noun, let verb = verb {
            programToExecute[1] = noun
            programToExecute[2] = verb
        }
        
        var finished = false
        while !finished && index < program.count {
            let instruction = programToExecute[index]
            switch instruction {
            case 1:
                let indexLeft = programToExecute[index+1]
                let indexRight = programToExecute[index+2]
                let indexResult = programToExecute[index+3]
                programToExecute[indexResult] = programToExecute[indexLeft] + programToExecute[indexRight]
                index += 4
            case 2:
                let indexLeft = programToExecute[index+1]
                let indexRight = programToExecute[index+2]
                let indexResult = programToExecute[index+3]
                programToExecute[indexResult] = programToExecute[indexLeft] * programToExecute[indexRight]
                index += 4
            case 99:
                finished = true
            default:
                finished = true
            }
        }
        
        return programToExecute
    }
    
    func findValueWithProgram(_ program:Array<Int>) -> (Int, Int){
        for noun in 0 ... 99 {
            for verb in 0 ... 99 {
                let result = executeProgram(program, withNoun:noun, andVerb:verb)
                if result[0] == 19690720 {
                    return (noun, verb)
                }
            }
        }
        
        return (-1, -1)
        
    }
}

class Advent2019Challenge2Tests: XCTestCase {
    
    var myClass: MyClass201902!

    override func setUpWithError() throws {
        myClass = MyClass201902()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample1() throws {
        //Arrange
        XCTAssertEqual(myClass.executeProgram([1,0,0,0,99]), [2,0,0,0,99])
    }
    
    func testExample2() throws {
        //Arrange
        XCTAssertEqual(myClass.executeProgram([2,3,0,3,99]), [2,3,0,6,99])
    }
    
    func testExample3() throws {
        //Arrange
        XCTAssertEqual(myClass.executeProgram([2,4,4,5,99,0]), [2,4,4,5,99,9801])
    }
    
    func testExample4() throws {
        //Arrange
        XCTAssertEqual(myClass.executeProgram([1,1,1,4,99,5,6,0,99]), [30,1,1,4,2,5,6,0,99])
    }
    
    func testInput() throws {
        let path:String = Bundle.main.path(forResource: "Input2019_2", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            
            let cleanString = stringData.replacingOccurrences(of: "\n", with: "", options: NSString.CompareOptions.literal, range: nil)
            let splittedArray = cleanString.split(separator: ",")
            XCTAssertNotNil(splittedArray)
            
            let intArray = splittedArray.map { Int($0)!}
            XCTAssertFalse(intArray.isEmpty)
            let result = myClass.executeProgram(intArray, withNoun:12, andVerb:2)
            XCTAssertNotEqual(result[0], 0)
            
        } else {
            XCTAssertNotNil(data)
        }
    }
    
    func testExercice2() throws {
        let path:String = Bundle.main.path(forResource: "Input2019_2", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            
            let cleanString = stringData.replacingOccurrences(of: "\n", with: "", options: NSString.CompareOptions.literal, range: nil)
            let splittedArray = cleanString.split(separator: ",")
            XCTAssertNotNil(splittedArray)
            
            let intArray = splittedArray.map { Int($0)!}
            XCTAssertFalse(intArray.isEmpty)
            let result = myClass.findValueWithProgram(intArray)
            let calc = 100 * result.0 + result.1
            XCTAssertTrue(calc > 0)
            
        } else {
            XCTAssertNotNil(data)
        }
    }
}
