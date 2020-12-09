//
//  Created by Nicolas Linard on 01/12/2020.
//

import XCTest
@testable import Advent2020Challenge1

class MyClass202001 {
    
    func calculateTwo(_ input:Array<Int> = []) -> (Int, Int){
        
        guard !input.isEmpty else {
            return (0,0)
        }
        
        for indexLeft in 0 ..< input.count {
            let valueLeft = input[indexLeft]
            for indexRight in indexLeft+1 ..< input.count {
                let valueRight = input[indexRight]
                if (valueLeft + valueRight) == 2020 {
                    return (valueLeft, valueRight)
                }
            }
        }
        
        return (0,0)
    }
    
    func calculateThree(_ input:Array<Int> = []) -> (Int, Int, Int){
        
        guard !input.isEmpty else {
            return (0,0,0)
        }
        
        for indexLeft in 0 ..< input.count {
            let valueLeft = input[indexLeft]
            for indexCenter in indexLeft+1 ..< input.count {
                let valueCenter = input[indexCenter]
                for indexRight in indexCenter+1 ..< input.count {
                    let valueRight = input[indexRight]
                    if (valueLeft + valueCenter + valueRight) == 2020 {
                        return (valueLeft, valueCenter, valueRight)
                    }
                }
            }
        }
        
        return (0,0,0)
    }
}

class Advent2020Challenge1Tests: XCTestCase {
    
    var myClass: MyClass202001!

    override func setUpWithError() throws {
        myClass = MyClass202001()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        //Arrange
        let input = [1721,979,366,299,675,1456]
        
        //Act
        let result = myClass.calculateTwo(input)
        
        //Assert
        XCTAssertEqual(result.0,1721)
        XCTAssertEqual(result.1,299)
        
    }
    
    func testCalculateTwo() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_1", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let splittedArray = stringData.split(separator: "\n")
            XCTAssertNotNil(splittedArray)
            let intArray = splittedArray.map { Int($0)!}
            XCTAssertFalse(intArray.isEmpty)
            let result = myClass.calculateTwo(intArray)
            let product = result.0 * result.1
            XCTAssertNotEqual(product, 0)
        } else {
            XCTAssertNotNil(data)
        }
    }
    
    func testCalculateThree() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_1", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let splittedArray = stringData.split(separator: "\n")
            XCTAssertNotNil(splittedArray)
            let intArray = splittedArray.map { Int($0)!}
            XCTAssertFalse(intArray.isEmpty)
            let result = myClass.calculateThree(intArray)
            let product = (result.0 * result.1) * result.2
            XCTAssertNotEqual(product, 0)
        } else {
            XCTAssertNotNil(data)
        }
    }
}
