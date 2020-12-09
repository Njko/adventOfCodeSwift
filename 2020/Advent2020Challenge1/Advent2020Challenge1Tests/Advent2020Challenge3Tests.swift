//
//  Created by Nicolas Linard on 03/12/2020.
//

import XCTest
@testable import Advent2020Challenge1

class MyClass202003 {
    
    func getNumberOfTreesHit(_ slope: Array<String>, withAngleRight right: Int, andAngleDown down: Int) -> Int {
        var numberOfTreesIntercepted = 0
        var indexStep = down
        var lastPosition = 0
        
        while indexStep < slope.count {
            let step = slope[indexStep]
            
            if doesSkierInterceptTree(step: step, startPosition: lastPosition, moveRight: right) {
                numberOfTreesIntercepted += 1
            }
            
            lastPosition = (lastPosition + right) % step.count
            indexStep += down
        }
        
        return numberOfTreesIntercepted
    }
    
    private func doesSkierInterceptTree(step: String, startPosition: Int, moveRight: Int) -> Bool {
        return step[(startPosition + moveRight) % step.count] == "#"
    }

}

class Advent2020Challenge3Tests: XCTestCase {
    
    var myClass: MyClass202003!

    override func setUpWithError() throws {
        myClass = MyClass202003()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_3_example", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let splittedArray = stringData.split(separator: "\n").map({String($0)})
            XCTAssertNotNil(splittedArray)
            let result = myClass.getNumberOfTreesHit(splittedArray, withAngleRight:3, andAngleDown:1)
            XCTAssertEqual(result, 7)
        } else {
            XCTAssertNotNil(data)
        }
    }
    
    func testGetNumberOfTreesHit() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_3", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let splittedArray = stringData.split(separator: "\n").map({String($0)})
            XCTAssertNotNil(splittedArray)
            let result = myClass.getNumberOfTreesHit(splittedArray, withAngleRight:3, andAngleDown:1)
            XCTAssertEqual(result, 153)
        } else {
            XCTAssertNotNil(data)
        }
    }
    
    func testExamplePart2() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_3_example", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let splittedArray = stringData.split(separator: "\n").map({String($0)})
            XCTAssertNotNil(splittedArray)
            let result11 = myClass.getNumberOfTreesHit(splittedArray, withAngleRight:1, andAngleDown:1)
            XCTAssertEqual(result11, 2)
            let result31 = myClass.getNumberOfTreesHit(splittedArray, withAngleRight:3, andAngleDown:1)
            XCTAssertEqual(result31, 7)
            let result51 = myClass.getNumberOfTreesHit(splittedArray, withAngleRight:5, andAngleDown:1)
            XCTAssertEqual(result51, 3)
            let result71 = myClass.getNumberOfTreesHit(splittedArray, withAngleRight:7, andAngleDown:1)
            XCTAssertEqual(result71, 4)
            let result12 = myClass.getNumberOfTreesHit(splittedArray, withAngleRight:1, andAngleDown:2)
            XCTAssertEqual(result12, 2)
            let finalResult = result11 * result31 * result51 * result71 * result12
            XCTAssertEqual(finalResult, 336)
        } else {
            XCTAssertNotNil(data)
        }
    }
    
    func testGetNumberOfTreesHitPart2() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_3", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let splittedArray = stringData.split(separator: "\n").map({String($0)})
            XCTAssertNotNil(splittedArray)
            let result11 = myClass.getNumberOfTreesHit(splittedArray, withAngleRight:1, andAngleDown:1)
            XCTAssertEqual(result11, 66)
            let result31 = myClass.getNumberOfTreesHit(splittedArray, withAngleRight:3, andAngleDown:1)
            XCTAssertEqual(result31, 153)
            let result51 = myClass.getNumberOfTreesHit(splittedArray, withAngleRight:5, andAngleDown:1)
            XCTAssertEqual(result51, 79)
            let result71 = myClass.getNumberOfTreesHit(splittedArray, withAngleRight:7, andAngleDown:1)
            XCTAssertEqual(result71, 92)
            let result12 = myClass.getNumberOfTreesHit(splittedArray, withAngleRight:1, andAngleDown:2)
            XCTAssertEqual(result12, 33)
            let finalResult = result11 * result31 * result51 * result71 * result12
            XCTAssertEqual(finalResult, 2421944712)
        } else {
            XCTAssertNotNil(data)
        }
    }
}
