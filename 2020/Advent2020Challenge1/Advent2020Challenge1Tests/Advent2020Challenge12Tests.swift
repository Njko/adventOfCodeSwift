//
//  Created by Nicolas Linard on 10/12/2020.
//

import XCTest
@testable import Advent2020Challenge1

//Use this enum as reference
//Refactor to use it if I have time to do so
enum FerryDirection: Int{
    case north = 0
    case east = 90
    case south = 180
    case west = 270
}
class WayPoint {
    private(set) var coordinates: Vector2 = .zero
    
    var x: Int {
        Int(self.coordinates.x.rounded())
    }
    var y: Int {
        Int(self.coordinates.y.rounded())
    }
    
    init() {
        self.coordinates.x = 10
        self.coordinates.y = 1
    }
    
    func move(heading: String, distance:Int) {
        switch heading {
        case "N":
            self.coordinates.y += Float(distance)
        case "E":
            self.coordinates.x += Float(distance)
        case "S":
            self.coordinates.y -= Float(distance)
        case "W":
            self.coordinates.x -= Float(distance)
        default: break
        }
    }
    
    func rotate(angle: Int, clockwise: Bool = false) {
        var newCoordinates:Vector2 = self.coordinates
        
        switch angle {
        case 90:
            newCoordinates = self.coordinates.rotated(by: (clockwise ? -1: 1) * 1.5708)
        case 180:
            newCoordinates = self.coordinates.rotated(by: (clockwise ? -1: 1) * 3.14159)
        case 270:
            newCoordinates = self.coordinates.rotated(by: (clockwise ? -1: 1) * 4.71239)
        default: break
        }
        
        //This is to prevent too much errors in coordinates after X rotations
        self.coordinates.x = newCoordinates.x.rounded()
        self.coordinates.y = newCoordinates.y.rounded()
    }
}
class Ferry {
    private(set) var x: Int = 0
    private(set) var y: Int = 0
    private(set) var direction: Int = 90
    
    var manhattanDistance : Int {
        abs(self.x) + abs(self.y)
    }
    
    func goForward(distance: Int) {
        switch direction {
        case 0:
            self.y += distance
        case 90:
            self.x += distance
        case 180:
            self.y -= distance
        case 270:
            self.x -= distance
        default: break
        }
    }
    
    func goForward(with wayPoint:WayPoint, frequency: Int) {
        self.y += wayPoint.y*frequency
        self.x += wayPoint.x*frequency
    }
    
    func turnLeft(angle: Int) {
        //Like Dereck Zoolander, I can't turn left
        self.direction = (self.direction + (360 - angle)) % 360
    }
    
    func turnRight(angle: Int) {
        self.direction = (self.direction + angle) % 360
    }
    
    func strafe(heading: String, distance:Int) {
        switch heading {
        case "N":
            self.y += distance
        case "E":
            self.x += distance
        case "S":
            self.y -= distance
        case "W":
            self.x -= distance
        default: break
        }
    }
}

class MyClass202012 {
    
    func moveFerryGivenInput(_ data: Array<String>, usingWayPoint : Bool = false) -> Int {
        let myFerry = Ferry()
        let myWaypoint = WayPoint()
        for instruction in data {
            let extractedData = instruction.matches(regex: #"(N|S|E|W|L|R|F)(\d*)"#)
            if extractedData.count < 2 {
                continue
            }
            let action = extractedData[0]
            let value = Int(extractedData[1]) ?? 0
            switch (action, usingWayPoint) {
            case ("N",false), ("S", false), ("E", false), ("W", false):
                myFerry.strafe(heading: action, distance: value)
            case ("L", false):
                myFerry.turnLeft(angle: value)
            case ("R", false):
                myFerry.turnRight(angle: value)
            case ("F", false):
                myFerry.goForward(distance: value)
            case ("N",true), ("S", true), ("E", true), ("W", true):
                myWaypoint.move(heading: action, distance: value)
            case ("L", true):
                myWaypoint.rotate(angle:value)
            case ("R", true):
                myWaypoint.rotate(angle:value, clockwise: true)
            case ("F", true):
                myFerry.goForward(with: myWaypoint, frequency: value)
            default: break
            }
        }
        return myFerry.manhattanDistance
    }
}

class Advent2020Challenge12Tests: XCTestCase {
    
    var myClass: MyClass202012!
    
    override func setUpWithError() throws {
        myClass = MyClass202012()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: PART 1
    func testFerryDirection() throws {
        let myFerry = Ferry()
        myFerry.turnRight(angle: 90)
        XCTAssertEqual(myFerry.direction, 180)
        myFerry.turnRight(angle: 270)
        XCTAssertEqual(myFerry.direction, 90)
        myFerry.turnRight(angle: 90)
        XCTAssertEqual(myFerry.direction, 180)
        myFerry.turnRight(angle: 180)
        XCTAssertEqual(myFerry.direction, 0)
        myFerry.turnRight(angle: 90)
        XCTAssertEqual(myFerry.direction, 90)
        myFerry.turnLeft(angle: 90)
        XCTAssertEqual(myFerry.direction, 0)
        myFerry.turnLeft(angle: 270)
        XCTAssertEqual(myFerry.direction, 90)
        myFerry.turnLeft(angle: 90)
        XCTAssertEqual(myFerry.direction, 0)
        myFerry.turnLeft(angle: 180)
        XCTAssertEqual(myFerry.direction, 180)
        myFerry.turnLeft(angle: 90)
        XCTAssertEqual(myFerry.direction, 90)
    }
    
    func testFerryInstructions1() throws {
        let myFerry = Ferry()
        myFerry.goForward(distance: 10)
        myFerry.strafe(heading: "N", distance: 3)
        myFerry.goForward(distance: 7)
        myFerry.turnRight(angle: 90)
        myFerry.goForward(distance: 11)
        XCTAssertEqual(myFerry.manhattanDistance, 25)
    }
    
    func testFerryInstructions2() throws {
        let data = """
        F10
        N3
        F7
        R90
        F11
        """
        let splittedArray = data.split(separator: "\n").map({ String($0) })
        let result = myClass.moveFerryGivenInput(splittedArray)
        XCTAssertEqual(result, 25)
    }
    
    func testGetNumberOfSeatsTakenWithStabilizedFerry() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_12", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let splittedArray = stringData.split(separator: "\n").map({ String($0) })
            XCTAssertNotNil(splittedArray)
            
            let result = myClass.moveFerryGivenInput(splittedArray)
            XCTAssertEqual(result, 1148)
        } else {
            XCTAssertNotNil(data)
        }
    }
    

    // MARK: PART 2
    func testWaypoint() throws {
        let waypoint = WayPoint()
        waypoint.move(heading: "N", distance: 3)
        waypoint.rotate(angle: 90, clockwise: true)
        XCTAssertEqual(waypoint.x,4)
        XCTAssertEqual(waypoint.y,-10)
        waypoint.rotate(angle: 90, clockwise: false)
        XCTAssertEqual(waypoint.x,10)
        XCTAssertEqual(waypoint.y,4)
    }
    
    func testFerryWithWaypoint() throws {
        let ferry = Ferry()
        let waypoint = WayPoint()
        ferry.goForward(with: waypoint, frequency: 10)
        XCTAssertEqual(waypoint.x,10)
        XCTAssertEqual(waypoint.y,1)
        XCTAssertEqual(ferry.x,100)
        XCTAssertEqual(ferry.y,10)
        waypoint.move(heading: "N", distance: 3)
        XCTAssertEqual(waypoint.x,10)
        XCTAssertEqual(waypoint.y,4)
        XCTAssertEqual(ferry.x,100)
        XCTAssertEqual(ferry.y,10)
        ferry.goForward(with: waypoint, frequency: 7)
        XCTAssertEqual(waypoint.x,10)
        XCTAssertEqual(waypoint.y,4)
        XCTAssertEqual(ferry.x,170)
        XCTAssertEqual(ferry.y,38)
        waypoint.rotate(angle: 90, clockwise: true)
        XCTAssertEqual(waypoint.x,4)
        XCTAssertEqual(waypoint.y,-10)
        XCTAssertEqual(ferry.x,170)
        XCTAssertEqual(ferry.y,38)
        ferry.goForward(with: waypoint, frequency: 11)
        XCTAssertEqual(waypoint.x,4)
        XCTAssertEqual(waypoint.y,-10)
        XCTAssertEqual(ferry.x,214)
        XCTAssertEqual(ferry.y,-72)
        XCTAssertEqual(ferry.manhattanDistance, 286)
    }
    
    func testFerryWithWaypoint2() throws {
        let data = """
        F10
        N3
        F7
        R90
        F11
        """
        let splittedArray = data.split(separator: "\n").map({ String($0) })
        let result = myClass.moveFerryGivenInput(splittedArray, usingWayPoint: true)
        XCTAssertEqual(result, 286)
    }
    
    func testGetNumberOfSeatsTakenWithStabilizedFerryWithWaypoint() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_12", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let splittedArray = stringData.split(separator: "\n").map({ String($0) })
            XCTAssertNotNil(splittedArray)
            
            let result = myClass.moveFerryGivenInput(splittedArray, usingWayPoint: true)
            XCTAssertEqual(result, 52203)
        } else {
            XCTAssertNotNil(data)
        }
    }
    
}
