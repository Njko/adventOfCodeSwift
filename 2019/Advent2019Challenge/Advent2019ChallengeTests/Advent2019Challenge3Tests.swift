//
//  Advent2020Challenge1Tests.swift
//  Advent2020Challenge1Tests
//
//  Created by Nicolas Linard on 01/12/2020.
//

import XCTest
@testable import Advent2019Challenge

class InvalidInstruction : Error {
    var message: String
    init(_ message:String) {
        self.message = message
    }
}

enum Direction {
    case horizontal
    case vertical
}
struct Segment {
    var x0: Int
    var y0: Int
    var x1: Int
    var y1: Int
    var distanceInPath: Int
    var direction: Direction
}

struct Intersection {
    var x: Int
    var y: Int
    var distanceInPath: Int
    var manhattanDistance: Int {
        return abs(x)+abs(y)
    }
}

class MyClass201903 {
    
    let gridSize: Int = 100000
    let midSize: Int = 50000
    
    func enrichPath(_ path: Array<String>) throws -> Array<Segment>{
        var richPath : Array<Segment> = []
        var lastSegment = Segment(x0: 0, y0: 0, x1: 0, y1: 0, distanceInPath: 0, direction: .horizontal)
        
        for instruction in path {
            
            let matchedExtenion = instruction.matches(regex:#"([A-Z])(\d*)"#)
            let direction = matchedExtenion[0]
            let distance = Int(matchedExtenion[1]) ?? 0
            
            var currentSegment: Segment
            
            switch direction {
            case "U":
                currentSegment = Segment(
                    x0: lastSegment.x1,
                    y0: lastSegment.y1,
                    x1: lastSegment.x1,
                    y1: lastSegment.y1 + distance,
                    distanceInPath: lastSegment.distanceInPath + distance,
                    direction: .vertical)
            case "D":
                currentSegment = Segment(
                    x0: lastSegment.x1,
                    y0: lastSegment.y1,
                    x1: lastSegment.x1,
                    y1: lastSegment.y1 - distance,
                    distanceInPath: lastSegment.distanceInPath + distance,
                    direction: .vertical)
            case "L":
                currentSegment = Segment(
                    x0: lastSegment.x1,
                    y0: lastSegment.y1,
                    x1: lastSegment.x1 - distance,
                    y1: lastSegment.y1,
                    distanceInPath: lastSegment.distanceInPath + distance,
                    direction: .horizontal)
            case "R":
                currentSegment = Segment(
                    x0: lastSegment.x1,
                    y0: lastSegment.y1,
                    x1: lastSegment.x1 + distance,
                    y1: lastSegment.y1,
                    distanceInPath: lastSegment.distanceInPath + distance,
                    direction: .horizontal)
            default:
                throw InvalidInstruction("invalid instruction")
            }
            
            richPath.append(currentSegment)
            lastSegment = currentSegment
        }
        return richPath
    }
    
    func findIntersectionBetween(path1: Array<Segment>, andPath2 path2: Array<Segment>) -> Array<Intersection> {
        print("made paths")
        var intersections : Array<Intersection> = []
        
        for segmentPath1 in path1 {
            for segmentPath2 in path2 {
                if segmentPath1.direction != segmentPath2.direction {
                    if segmentPath1.direction == .horizontal {
                        let boundMinY :Int = min(segmentPath2.y0, segmentPath2.y1)
                        let boundMaxY :Int = max(segmentPath2.y0, segmentPath2.y1)
                        let boundMinX :Int = min(segmentPath1.x0, segmentPath1.x1)
                        let boundMaxX :Int = max(segmentPath1.x0, segmentPath1.x1)
                        
                        if boundMinY...boundMaxY ~= segmentPath1.y0 &&
                            boundMinX...boundMaxX ~= segmentPath2.x0 {
                            intersections.append(Intersection(x: segmentPath2.x0, y: segmentPath1.y0, distanceInPath: 0))
                        }
                    } else {
                        let boundMinY :Int = min(segmentPath1.y0, segmentPath1.y1)
                        let boundMaxY :Int = max(segmentPath1.y0, segmentPath1.y1)
                        let boundMinX :Int = min(segmentPath2.x0, segmentPath2.x1)
                        let boundMaxX :Int = max(segmentPath2.x0, segmentPath2.x1)
                        if boundMinY...boundMaxY ~= segmentPath2.y0 &&
                            boundMinX...boundMaxX ~= segmentPath1.x0 {
                            intersections.append(Intersection(x: segmentPath1.x0, y: segmentPath2.y0, distanceInPath: 0))
                        }
                    }
                }
            }
        }
        
        return intersections.filter({ $0.manhattanDistance != 0})
    }
    
    func minDistanceFromIntersect(_ path1 : Array<String>, _ path2 : Array<String>) throws -> Int{
        
        let richPath1 = try enrichPath(path1)
        let richPath2 = try enrichPath(path2)
        
        let intersectionDistances : Array<Intersection> = findIntersectionBetween(path1: richPath1, andPath2: richPath2)
        
        return intersectionDistances.min{ $0.manhattanDistance < $1.manhattanDistance }?.manhattanDistance ?? 10000
    }
}

class Advent2019Challenge3Tests: XCTestCase {
    
    var myClass: MyClass201903!

    override func setUpWithError() throws {
        myClass = MyClass201903()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample1() throws {
        //Arrange
        do {
            let result = try myClass.minDistanceFromIntersect(["R8","U5","L5","D3"], ["U7","R6","D4","L4"])
            
            XCTAssertEqual(result, 6)
        }
        catch is InvalidInstruction {
            //error
        }
    }
    
    func testExample2() throws {
        //Arrange
        do {
            let result = try myClass.minDistanceFromIntersect(["R75","D30","R83","U83","L12","D49","R71","U7","L72"],
                                                              ["U62","R66","U55","R34","D71","R55","D58","R83"])
            
            XCTAssertEqual(result, 159)
        }
        catch is InvalidInstruction {
            //error
        }
    }
    
    func testExample3() throws {
        //Arrange
        do {
            let result = try myClass.minDistanceFromIntersect(["R98","U47","R26","D63","R33","U87","L62","D20","R33","U53","R51"],
                                                              ["U98","R91","D20","R16","D67","R40","U7","R15","U6","R7"])
            
            XCTAssertEqual(result, 135)
        }
        catch is InvalidInstruction {
            //error
        }
    }
    
    func testInput() throws {
        
        let path:String = Bundle.main.path(forResource: "Input2019_3", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let splittedArray = stringData.split(separator: "\n")
            XCTAssertNotNil(splittedArray)
            let path1 = splittedArray[0]
            let path2 = splittedArray[1]
            
            let cleanPath1 = path1.replacingOccurrences(of: "\n", with: "", options: NSString.CompareOptions.literal, range: nil)
            let cleanPath2 = path2.replacingOccurrences(of: "\n", with: "", options: NSString.CompareOptions.literal, range: nil)
            
            let splittedPath1 = cleanPath1.split(separator: ",").map{ String($0)}
            let splittedPath2 = cleanPath2.split(separator: ",").map{ String($0)}
            
            XCTAssertNotNil(splittedPath1)
            XCTAssertNotNil(splittedPath2)
            
            let result = try myClass.minDistanceFromIntersect(splittedPath1, splittedPath2)
            
            XCTAssertEqual(result, 273)
            
        } else {
            XCTAssertNotNil(data)
        }
    }
}
