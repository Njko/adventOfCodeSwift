//
//  Created by Nicolas Linard on 02/12/2020.
//

import XCTest
@testable import Advent2020Challenge1

class MyClass202002 {
    func getNumberOfValidPasswords(_ input: Array<String>) -> Int {
        
        var numberOfValidPasswords = 0
        
        for item in input {
            let data = extractData(item)
            let occurences = countOccurencesInPassword(data.letter, data.password)
            if (data.first...data.second).contains(occurences) {
                numberOfValidPasswords += 1
            }
        }
        
        return numberOfValidPasswords
    }
    
    func getNumberOfValidPasswordsWithNewPolicy(_ input: Array<String>) -> Int {
        var numberOfValidPasswords = 0
        
        for item in input {
            let data = extractData(item)
            let password: String = data.password
            let letter: Character = data.letter
            let positionFirstLetter: Int = data.first-1
            let positionSecondLetter: Int = data.second-1
            
            let firstMatch: Bool = password[password.index(password.startIndex, offsetBy: positionFirstLetter)] == letter
            let secondMatch: Bool = password[password.index(password.startIndex, offsetBy: positionSecondLetter)] == letter
            

            if firstMatch ^| secondMatch {
                numberOfValidPasswords += 1
            }
        }
        
        return numberOfValidPasswords
    }
    
    private func extractData(_ data: String) -> (first: Int, second:Int, letter:Character, password:String) {
        
        let extractedData = data.matches(regex: #"(\d*)-(\d*) ([a-z]): ([a-z]*)"#)
        
        return (Int(extractedData[0]) ?? 0,
                Int(extractedData[1]) ?? 0,
                Character(extractedData[2]),
                extractedData[3])
    }
    
    private func countOccurencesInPassword(_ letter: Character, _ password: String) -> Int{
        return password.filter({ $0 == letter }).count
    }
}

class Advent2020Challenge2Tests: XCTestCase {
    
    var myClass: MyClass202002!

    override func setUpWithError() throws {
        myClass = MyClass202002()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        //Arrange
        let input = ["1-3 a: abcde","1-3 b: cdefg","2-9 c: ccccccccc"]
        
        //Act
        let result = myClass.getNumberOfValidPasswords(input)
        
        //Assert
        XCTAssertEqual(result, 2)
    }
    
    func testGetNumberOfValidPasswords() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_2", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let splittedArray = stringData.split(separator: "\n").map({String($0)})
            XCTAssertNotNil(splittedArray)
            let result = myClass.getNumberOfValidPasswords(splittedArray)
            XCTAssertNotEqual(result, 0)
        } else {
            XCTAssertNotNil(data)
        }
    }
    
    func testSecondExample() throws {
        //Arrange
        let input = ["1-3 a: abcde","1-3 b: cdefg","2-9 c: ccccccccc"]
        
        //Act
        let result = myClass.getNumberOfValidPasswordsWithNewPolicy(input)
        
        //Assert
        XCTAssertEqual(result, 1)
    }
    
    func testGetNumberOfValidPasswordsWithNewPolicy() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_2", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let splittedArray = stringData.split(separator: "\n").map({String($0)})
            XCTAssertNotNil(splittedArray)
            let result = myClass.getNumberOfValidPasswordsWithNewPolicy(splittedArray)
            XCTAssertNotEqual(result, 0)
        } else {
            XCTAssertNotNil(data)
        }
    }
}
