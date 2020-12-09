//
//  Created by Nicolas Linard on 05/12/2020.
//

import XCTest
@testable import Advent2020Challenge1

struct Seat : Equatable {
    var row:Int
    var column:Int
}

class MyClass202005 {
    
    func getHighestSeatId(_ scannedPasses : Array<String>) -> Int {
        return scannedPasses.map({ computeSeatID(decodeSeat($0)) }).max() ?? 0
    }
    
    func getMissingSeatId(_ scannedPasses : Array<String>) -> Int {
        return computeSeatID(scanPlaneForMissingSeat(setSeatsInPlane(scannedPasses)))
    }
    
    func setSeatsInPlane(_ scannedPasses : Array<String>) -> Array<Array<String>>{
        let rowLength = 127
        let columnLength = 8
        let seats = scannedPasses.map({decodeSeat($0)})
        
        var plane = [[String]](repeating: [String](repeating: ".", count: columnLength), count:rowLength)
        for seat in seats {
            plane[seat.row][seat.column] = "#"
        }
        //print(plane)
        return plane
    }
    
    func scanPlaneForMissingSeat(_ plane: Array<Array<String>>) -> Seat {
        
        for row in 3...125 {
            for column in 1...6 {
                if plane[row][column] == "." {
                    return Seat(row: row, column: column)
                }
            }
        }
        
        return Seat(row: 0, column: 0)
    }
    
    func decodeSeat(_ seat:String) -> Seat {
        
        var rowRange = 0...127
        var columnRange = 0...7
        
        for instruction in seat {
            switch instruction {
            case "F":
                rowRange = computeLowerHalf(rowRange)
            case "B":
                rowRange = computeUpperHalf(rowRange)
            case "R":
                columnRange = computeUpperHalf(columnRange)
            case "L":
                columnRange = computeLowerHalf(columnRange)
            default:
                break
            
            }
        }
        
        return Seat(row:rowRange.lowerBound, column:columnRange.lowerBound)
    }
    
    func computeLowerHalf(_ range: ClosedRange<Int>) -> ClosedRange<Int> {
        let distance : Int = range.distance(from: range.startIndex, to: range.endIndex)
        return range.lowerBound...(range.upperBound-(distance/2))
    }
    
    func computeUpperHalf(_ range: ClosedRange<Int>) -> ClosedRange<Int> {
        let distance : Int = range.distance(from: range.startIndex, to: range.endIndex)
        return (range.lowerBound+(distance/2))...range.upperBound
    }
    
    func computeSeatID(_ seat: Seat) -> Int{
        return seat.row * 8 + seat.column
    }
}

class Advent2020Challenge5Tests: XCTestCase {
    
    var myClass: MyClass202005!

    override func setUpWithError() throws {
        myClass = MyClass202005()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let boardingPasses = ["FBFBBFFRLR", "BFFFBBFRRR", "FFFBBBFRRR", "BBFFBBFRLL"]
        let result = myClass.getHighestSeatId(boardingPasses)
        XCTAssertEqual(result, 820)
    }
    
    func testGetHighestSeatId() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_5", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let splittedArray = stringData.split(separator: "\n").map({String($0)})
            XCTAssertNotNil(splittedArray)
            let result = myClass.getHighestSeatId(splittedArray)
            XCTAssertEqual(result, 947)
        } else {
            XCTAssertNotNil(data)
        }
    }
    
    func testFindMissingSeat() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_5", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let splittedArray = stringData.split(separator: "\n").map({String($0)})
            XCTAssertNotNil(splittedArray)
            let result = myClass.getMissingSeatId(splittedArray)
            XCTAssertEqual(result, 636)
        } else {
            XCTAssertNotNil(data)
        }
    }
    
    func testComputeLowerHalf() {
        XCTAssertEqual(myClass.computeLowerHalf(0...127), 0...63)
        XCTAssertEqual(myClass.computeLowerHalf(32...63), 32...47)
        XCTAssertEqual(myClass.computeLowerHalf(44...47), 44...45)
        XCTAssertEqual(myClass.computeLowerHalf(44...45), 44...44)
        XCTAssertEqual(myClass.computeLowerHalf(4...7), 4...5)
    }
    
    func testComputeUpperHalf() {
        XCTAssertEqual(myClass.computeUpperHalf(0...63), 32...63)
        XCTAssertEqual(myClass.computeUpperHalf(32...47), 40...47)
        XCTAssertEqual(myClass.computeUpperHalf(40...47), 44...47)
        XCTAssertEqual(myClass.computeUpperHalf(0...7), 4...7)
        XCTAssertEqual(myClass.computeUpperHalf(0...7), 4...7)
        XCTAssertEqual(myClass.computeUpperHalf(4...5), 5...5)
    }
    
    func testDecodeSeatExample1() {
        let result = myClass.decodeSeat("FBFBBFFRLR")
        
        XCTAssertEqual(result, Seat(row:44, column:5))
        XCTAssertEqual(myClass.computeSeatID(result), 357)
    }
    
    func testDecodeSeatExample2() {
        let result = myClass.decodeSeat("BFFFBBFRRR")
        
        XCTAssertEqual(result, Seat(row:70, column:7))
        XCTAssertEqual(myClass.computeSeatID(result), 567)
    }
    
    func testDecodeSeatExample3() {
        let result = myClass.decodeSeat("FFFBBBFRRR")
        
        XCTAssertEqual(result, Seat(row:14, column:7))
        XCTAssertEqual(myClass.computeSeatID(result), 119)
    }
    
    func testDecodeSeatExample4() {
        let result = myClass.decodeSeat("BBFFBBFRLL")
        
        XCTAssertEqual(result, Seat(row:102, column:4))
        XCTAssertEqual(myClass.computeSeatID(result), 820)
    }
    
    func testDecodeSeatExample0() {
        let result = myClass.decodeSeat("FFFFFFFLLL")
        
        XCTAssertEqual(result, Seat(row:0, column:0))
        //XCTAssertEqual(myClass.computeSeatID(result), 820)
    }
}
