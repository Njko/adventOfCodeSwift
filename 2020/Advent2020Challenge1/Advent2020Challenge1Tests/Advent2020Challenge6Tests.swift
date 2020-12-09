//
//  Created by Nicolas Linard on 06/12/2020.
//

import XCTest
@testable import Advent2020Challenge1

class MyClass202006 {
    
    func getNumberOfPositiveAnswers(_ data : Array<Array<String>>) -> Int{
        var totalPositiveAnswers = 0
        for group in data {
            var positiveAnswersInGroup :Set<Character> = Set([])
            for answer in group {
                let answerSet : Set<Character> = Set(Array(answer))
                positiveAnswersInGroup = positiveAnswersInGroup.union(answerSet)
            }
            totalPositiveAnswers += positiveAnswersInGroup.count
        }
        return totalPositiveAnswers
    }
    
    func getNumberOfCollectivePositiveAnswers(_ data : Array<Array<String>>) -> Int{
        var totalPositiveAnswers = 0
        for group in data {
            var positiveAnswersInGroup :Set<Character> = Set(Array(group[0]))
            if group.count > 1 {
                for index in 1..<group.count {
                    let answerSet : Set<Character> = Set(Array(group[index]))
                    positiveAnswersInGroup = positiveAnswersInGroup.intersection(answerSet)
                }
            }
            totalPositiveAnswers += positiveAnswersInGroup.count
        }
        return totalPositiveAnswers
    }
}

class Advent2020Challenge6Tests: XCTestCase {
    
    var myClass: MyClass202006!

    override func setUpWithError() throws {
        myClass = MyClass202006()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let answers = [["abcx","abcy","abcz"]]
        let result = myClass.getNumberOfPositiveAnswers(answers)
        XCTAssertEqual(result, 6)
    }
    
    func testExample2() throws {
        let answers = [["abc"],["a","b","c"],["ab","ac"],["a","a","a","a"],["b"]]
        let result = myClass.getNumberOfPositiveAnswers(answers)
        XCTAssertEqual(result, 11)
    }
    
    func testGetNumberOfPositiveAnswers() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_6", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let cleanedStringData = stringData.replacingOccurrences(of: "\n\n", with: ";")
            let splittedArray = cleanedStringData
                .split(separator: ";")
                .map({String($0).split(separator: "\n").map({String($0)})})
            XCTAssertNotNil(splittedArray)
            
            let result = myClass.getNumberOfPositiveAnswers(splittedArray)
            XCTAssertEqual(result, 6335)
        } else {
            XCTAssertNotNil(data)
        }
    }
    
    func testExamplePart2() throws {
        let answers = [["abc"],["a","b","c"],["ab","ac"],["a","a","a","a"],["b"]]
        let result = myClass.getNumberOfCollectivePositiveAnswers(answers)
        XCTAssertEqual(result, 6)
    }
    
    func testExample2Part2() throws {
        let answers = [["abcx","abcy","abcz"]]
        let result = myClass.getNumberOfCollectivePositiveAnswers(answers)
        XCTAssertEqual(result, 3)
    }
    
    func testGetNumberOfCollectivePositiveAnswers() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_6", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let cleanedStringData = stringData.replacingOccurrences(of: "\n\n", with: ";")
            let splittedArray = cleanedStringData
                .split(separator: ";")
                .map({String($0).split(separator: "\n").map({String($0)})})
            XCTAssertNotNil(splittedArray)
            
            let result = myClass.getNumberOfCollectivePositiveAnswers(splittedArray)
            XCTAssertEqual(result, 3392)
        } else {
            XCTAssertNotNil(data)
        }
    }
}
