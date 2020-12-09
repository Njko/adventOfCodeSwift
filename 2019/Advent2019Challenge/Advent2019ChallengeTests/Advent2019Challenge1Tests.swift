//
//  Advent2020Challenge1Tests.swift
//  Advent2020Challenge1Tests
//
//  Created by Nicolas Linard on 01/12/2020.
//

import XCTest
@testable import Advent2019Challenge

class MyClass201901 {
    
    private func calculateMass(_ mass:Int) -> Int{
        return Int(floor(Double(mass)/3)) - 2
    }
    
    func calculateMassOfShip(_ input: Array<Int>, withFuel: Bool = false) -> Int{
        
        var sum = 0
        
        guard !input.isEmpty else {
            return 0
        }
        
        for value in input {
            let massOfFuel = calculateMass(value)
            sum += withFuel ? massOfFuel + calculateMassOfFuel(massOfFuel): massOfFuel
        }
        
        return sum
    }
    
    private func calculateMassOfFuel(_ fuel:Int) -> Int {
        let massOfFuel = calculateMass(fuel)
        
        if massOfFuel <= 0 {
            return 0
        }
        
        return massOfFuel + calculateMassOfFuel(massOfFuel)
    }
}

class Advent2019Challenge1Tests: XCTestCase {
    
    var myClass: MyClass201901!

    override func setUpWithError() throws {
        myClass = MyClass201901()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample1() throws {
        //Arrange
       
        XCTAssertEqual(myClass.calculateMassOfShip([12]),2)
    }
    
    func testExample2() throws {
        //Arrange
       
        XCTAssertEqual(myClass.calculateMassOfShip([14]),2)
    }
    
    func testExample3() throws {
        //Arrange
       
        XCTAssertEqual(myClass.calculateMassOfShip([1969]),654)
    }
    
    func testExample4() throws {
        //Arrange
       
        XCTAssertEqual(myClass.calculateMassOfShip([100756]),33583)
    }
    
    func testInput() throws {
        let path:String = Bundle.main.path(forResource: "Input2019_1", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let splittedArray = stringData.split(separator: "\n")
            XCTAssertNotNil(splittedArray)
            let intArray = splittedArray.map { Int($0)!}
            XCTAssertFalse(intArray.isEmpty)
            let result = myClass.calculateMassOfShip(intArray)
            XCTAssertNotEqual(result, 0)
            
        } else {
            XCTAssertNotNil(data)
        }
    }
    
    func testExample5() throws {
        XCTAssertEqual(myClass.calculateMassOfShip([14], withFuel: true),2)
    }
    
    func testExample6() throws {
        XCTAssertEqual(myClass.calculateMassOfShip([1969], withFuel: true),966)
    }
    
    func testExample7() throws {
        XCTAssertEqual(myClass.calculateMassOfShip([100756], withFuel: true),50346)
    }
    
    func testInputPart2() throws {
        let path:String = Bundle.main.path(forResource: "Input2019_1", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let splittedArray = stringData.split(separator: "\n")
            XCTAssertNotNil(splittedArray)
            let intArray = splittedArray.map { Int($0)!}
            XCTAssertFalse(intArray.isEmpty)
            let result = myClass.calculateMassOfShip(intArray, withFuel: true)
            XCTAssertNotEqual(result, 0)
            
        } else {
            XCTAssertNotNil(data)
        }
    }
}
