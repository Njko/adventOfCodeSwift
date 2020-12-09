//
//  Created by Nicolas Linard on 08/12/2020.
//

import XCTest
@testable import Advent2020Challenge1

enum Operator: String {
    case positive
    case negative
}

enum Instruction {
    case jump(Operator, Int)
    case accumulate(Operator, Int)
    case noOperation(Operator, Int)
    
    func process(_ data: (index: Int, accumulator: Int)) -> (index: Int, accumulator: Int){
        
        var result = data
        
        switch self {
        case let .jump(op, value):
            switch op {
            case .positive:
                result.index += value
            case .negative:
                result.index -= value
            }
        case let .accumulate(op, value):
            switch op {
            case .positive:
                result.accumulator += value
            case .negative:
                result.accumulator -= value
            }
            fallthrough
        case .noOperation:
            result.index += 1
        }
        
        return result
    }
}

class MyClass202008 {
    func getValueOfAccumulatorAfterProgramWithInfiniteLoop(_ data: Array<String>) -> Int {
        let instructions: Array<(Instruction, executed: Bool)> = getInstructionsFrom(data:data)
        
        if instructions.count == 0 {
            return 0
        }
    
        return runProgram(instructions).accumulator
    }
    
    func getValueOfAccumulatorAfterFixingProgram(_ data: Array<String>) -> Int {
        let originalInstructions: Array<(Instruction, executed: Bool)> = getInstructionsFrom(data:data)
        
        if originalInstructions.count == 0 {
            return 0
        }
        
        var indexInstructionToSwitch = -1
        var instructions: Array<(Instruction, executed: Bool)> = []
        var resultOfExecution = (accumulator: 0, infiniteLoop: true)
        repeat {
            indexInstructionToSwitch += 1
            instructions = switchNopAndJumpInstructionFrom(originalInstructions, startingFrom: indexInstructionToSwitch)
            resultOfExecution = runProgram(instructions)
        } while resultOfExecution.infiniteLoop == true
        
        return resultOfExecution.accumulator
    }
    
    private func runProgram(_ data:Array<(instruction: Instruction, executed: Bool)>) -> (accumulator: Int, infiniteLoop: Bool) {
        var instructions = data
        var programData = (index: 0, accumulator: 0)
        while programData.index < instructions.count {
            
            if instructions[programData.index].executed == true {
                return (accumulator: programData.accumulator, infiniteLoop: true)
            }
            
            instructions[programData.index].executed = true
            programData = instructions[programData.index].instruction.process(programData)
        }
        
        return (accumulator: programData.accumulator, infiniteLoop: false)
    }
    
    private func getInstructionsFrom(data: Array<String>) -> Array<(Instruction, executed: Bool)> {
        
        var instructions: Array<(Instruction, executed: Bool)> = []
        
        for item in data {
            let matches = item.matches(regex: #"(acc|jmp|nop) (\+|\-)(\d*)"#)
            if matches.count > 0 {
                let selectedOperator: Operator = matches[1] == "+" ? .positive: .negative
                
                switch matches[0] {
                case "acc":
                    instructions.append((Instruction.accumulate(selectedOperator, Int(matches[2]) ?? 0), executed: false))
                case "jmp":
                    instructions.append((Instruction.jump(selectedOperator, Int(matches[2]) ?? 0), executed: false))
                case "nop":
                    instructions.append((Instruction.noOperation(selectedOperator, Int(matches[2]) ?? 0), executed: false))
                default: break
                }
            }
        }
        
        return instructions
    }
    
    private func switchNopAndJumpInstructionFrom(_ data: Array<(Instruction, executed: Bool)>,
                                         startingFrom index: Int) -> Array<(Instruction, executed: Bool)>{
        var instructions = data
        var switched = false
        var indexToCheck = index
        while !switched {
            let instructionToSwitch = instructions[indexToCheck]
            
            switch instructionToSwitch.0 {
            case let .jump(op, value):
                instructions[indexToCheck] = (Instruction.noOperation(op, value), false)
                switched = true
            case let .noOperation(op, value):
                instructions[indexToCheck] = (Instruction.jump(op, value), false)
                switched = true
            default:
                indexToCheck += 1
            }
        }
        
        return instructions
    }
}

class Advent2020Challenge8Tests: XCTestCase {
    
    var myClass: MyClass202008!

    override func setUpWithError() throws {
        myClass = MyClass202008()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testProcessAccumulatePositive1() {
        let instruction = Instruction.accumulate(.positive, 1)
        let intialData = (index: 0, accumulator: 0)
        let expected = (index: 1, accumulator: 1)
        let processedInstruction = instruction.process(intialData)
        XCTAssertEqual(expected.index, processedInstruction.index)
        XCTAssertEqual(expected.accumulator, processedInstruction.accumulator)
    }
    
    func testProcessAccumulateNegative1() {
        let instruction = Instruction.accumulate(.negative, 1)
        let intialData = (index: 0, accumulator: 1)
        let expected = (index: 1, accumulator: 0)
        let processedInstruction = instruction.process(intialData)
        XCTAssertEqual(expected.index, processedInstruction.index)
        XCTAssertEqual(expected.accumulator, processedInstruction.accumulator)
    }
    
    func testProcessAccumulatePositiveN() {
        let instruction = Instruction.accumulate(.positive, 100)
        let intialData = (index: 0, accumulator: 0)
        let expected = (index: 1, accumulator: 100)
        let processedInstruction = instruction.process(intialData)
        XCTAssertEqual(expected.index, processedInstruction.index)
        XCTAssertEqual(expected.accumulator, processedInstruction.accumulator)
    }
    
    func testProcessAccumulateNegativeN() {
        let instruction = Instruction.accumulate(.negative, 100)
        let intialData = (index: 0, accumulator: 0)
        let expected = (index: 1, accumulator: -100)
        let processedInstruction = instruction.process(intialData)
        XCTAssertEqual(expected.index, processedInstruction.index)
        XCTAssertEqual(expected.accumulator, processedInstruction.accumulator)
    }
    
    func testProcessJumpPositive5() {
        let instruction = Instruction.jump(.positive, 5)
        let intialData = (index: 0, accumulator: 0)
        let expected = (index: 5, accumulator: 0)
        let processedInstruction = instruction.process(intialData)
        XCTAssertEqual(expected.index, processedInstruction.index)
        XCTAssertEqual(expected.accumulator, processedInstruction.accumulator)
    }
    
    func testProcessJumpNegative5IndexUnder0() {
        let instruction = Instruction.jump(.negative, 5)
        let intialData = (index: 5, accumulator: 0)
        let expected = (index: 0, accumulator: 0)
        let processedInstruction = instruction.process(intialData)
        XCTAssertEqual(expected.index, processedInstruction.index)
        XCTAssertEqual(expected.accumulator, processedInstruction.accumulator)
    }
    
    func testNoOperation() {
        let instruction = Instruction.noOperation(.negative, 5)
        let intialData = (index: 0, accumulator: 0)
        let expected = (index: 1, accumulator: 0)
        let processedInstruction = instruction.process(intialData)
        XCTAssertEqual(expected.index, processedInstruction.index)
        XCTAssertEqual(expected.accumulator, processedInstruction.accumulator)
    }

    func testExample() throws {
        let stringData = """
                nop +0
                acc +1
                jmp +4
                acc +3
                jmp -3
                acc -99
                acc +1
                jmp -4
                acc +6
        """
        let splittedArray = stringData.split(separator: "\n").map({String($0)})
        let result = myClass.getValueOfAccumulatorAfterProgramWithInfiniteLoop(splittedArray)
        XCTAssertEqual(result, 5)
    }
    
    func testGetValueOfAccumulatorAfterProgramWithInfiniteLoop() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_8", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let splittedArray = stringData.split(separator: "\n").map({String($0)})
            XCTAssertNotNil(splittedArray)
            
            let result = myClass.getValueOfAccumulatorAfterProgramWithInfiniteLoop(splittedArray)
            XCTAssertEqual(result, 1528)
        } else {
            XCTAssertNotNil(data)
        }
    }
    
    func testExample2 () throws{
        let stringData = """
                nop +0
                acc +1
                jmp +4
                acc +3
                jmp -3
                acc -99
                acc +1
                jmp -4
                acc +6
        """
        let splittedArray = stringData.split(separator: "\n").map({String($0)})
        let result = myClass.getValueOfAccumulatorAfterFixingProgram(splittedArray)
        XCTAssertEqual(result, 8)
    }
    
    func testgetValueOfAccumulatorAfterFixingProgram() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_8", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let splittedArray = stringData.split(separator: "\n").map({String($0)})
            XCTAssertNotNil(splittedArray)
            
            let result = myClass.getValueOfAccumulatorAfterFixingProgram(splittedArray)
            XCTAssertEqual(result, 640)
        } else {
            XCTAssertNotNil(data)
        }
    }
}
