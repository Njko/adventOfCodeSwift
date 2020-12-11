//
//  Created by Nicolas Linard on 10/12/2020.
//

import XCTest
@testable import Advent2020Challenge1

let infinity = 10000000

struct DirectionModifier {
    var x:Int
    var y:Int
}

struct Direction {
    static let topLeft = DirectionModifier(x: -1, y: -1)
    static let top = DirectionModifier(x:0,y:-1)
    static let topRight = DirectionModifier(x:1,y:-1)
    static let right = DirectionModifier(x:1,y:0)
    static let bottomRight = DirectionModifier(x:1,y:1)
    static let bottom = DirectionModifier(x:0,y:1)
    static let bottomLeft = DirectionModifier(x:-1,y:1)
    static let left = DirectionModifier(x: -1, y: 0)
}

class MyClass202011 {
    
    func getAdjacentCells(_ position : (x:Int, y:Int),with data: Array<Array<Character>>) -> Array<Character> {
        
        var adjacentCells : Array<Character> = []
        for y in max(0, position.y-1) ... min(position.y+1,data.count-1) {
            for x in max(0, position.x-1) ... min(position.x+1,data[y].count-1) {
                
                if x == position.x && y == position.y {
                    continue
                }
                adjacentCells.append(data[y][x])
            }
        }
        
        return adjacentCells
    }
    
    func getNumberOfSeatsTakenAround(_ position : (x:Int, y:Int),with data: Array<Array<Character>>) -> Int {
        let scannedNeighbors = [
            scanInDirection(position, with: data, andDirection: Direction.topLeft),
            scanInDirection(position, with: data, andDirection: Direction.top),
            scanInDirection(position, with: data, andDirection: Direction.topRight),
            scanInDirection(position, with: data, andDirection: Direction.right),
            scanInDirection(position, with: data, andDirection: Direction.bottomRight),
            scanInDirection(position, with: data, andDirection: Direction.bottom),
            scanInDirection(position, with: data, andDirection: Direction.bottomLeft),
            scanInDirection(position, with: data, andDirection: Direction.left)
        ]
        
        //print("scannedNeighbors \(String(scannedNeighbors)) for position \(position.x) \(position.y)")
        
        return scannedNeighbors.filter{ $0 == "#"}.count
    }
    
    func scanInDirection (_ position : (x:Int, y:Int),with data: Array<Array<Character>>, andDirection direction: DirectionModifier) -> Character {
        var nextItemX = position.x + direction.x
        var nextItemY = position.y + direction.y
        while (0..<data.count).contains(nextItemY) && (0..<data[nextItemY].count).contains(nextItemX) {
            if data[nextItemY][nextItemX] != "." {
                return data[nextItemY][nextItemX]
            }
            nextItemX += direction.x
            nextItemY += direction.y
        }
        
        return "."
    }
    
    func processOneStepAtPosition(_ position : (x:Int, y:Int),with data: Array<Array<Character>>, useScannedSeat: Bool = false) -> Character? {
        
        let numberOfSeatsTaken = useScannedSeat
            ? getNumberOfSeatsTakenAround(position, with: data)
            : getAdjacentCells(position, with: data).filter{ $0 == "#"}.count
        
        switch (data[position.y][position.x], numberOfSeatsTaken) {
        case ("L", 0):
            return "#"
        case ("#", (useScannedSeat ? 5 : 4) ..< infinity):
            return "L"
        default:
            break
        }
        return nil
    }
    
    func processOneStepInGrid(with data: Array<Array<Character>>, useSeatScanner: Bool = false) -> (Array<Array<Character>>, hasChanged:Bool) {
        var nextSubStep = data
        var hasChanged = false
        for y in 0..<data.count {
            for x in 0..<data[y].count {
                if let characterChanged = processOneStepAtPosition((x,y), with: data, useScannedSeat: useSeatScanner) {
                    hasChanged = true
                    nextSubStep[y][x] = characterChanged
                }
            }
        }
        return (nextSubStep, hasChanged)
    }
    
    
    
    func getNumberOfSeatsTakenWithStabilizedFerry(_ data: Array<Array<Character>>, andSeatScanner useScanner: Bool = false) -> Int {
        
        var stabilized = false
        var nextStep = data
        var numberOfSeats = 0
        var numberOfSteps = 0
        repeat {
            let result = processOneStepInGrid(with: nextStep, useSeatScanner: useScanner)
            numberOfSteps += 1
            stabilized = !result.hasChanged
            nextStep = result.0
        } while !stabilized
        print("stabilized in \(numberOfSteps) steps")
        for row in nextStep {
            numberOfSeats += row.filter{ $0 == "#"}.count
        }
        
        return numberOfSeats
    }
}

class Advent2020Challenge11Tests: XCTestCase {
    
    var myClass: MyClass202011!
    
    override func setUpWithError() throws {
        myClass = MyClass202011()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: PART 1
    func testExample() throws {
        let data = [Array("..."),Array(".L."),Array("...")]
        let result = myClass.processOneStepAtPosition((1,1), with:data, useScannedSeat: false)
        XCTAssertEqual(result, "#")
    }
    
    func testExample2() throws {
        let data = [Array("..."),Array("#L#"),Array("...")]
        let result = myClass.processOneStepAtPosition((1,1), with:data, useScannedSeat: false)
        XCTAssertNil(result)
    }
    
    func testExample3() throws {
        let data = [Array("#.."),Array(".L."),Array("...")]
        let result = myClass.processOneStepAtPosition((1,1), with:data, useScannedSeat: false)
        XCTAssertNil(result)
    }
    
    func testGetAdjacentSeat() throws {
        let data = [Array("..."),Array(".L."),Array("...")]
        let expected = Array("........")
        let result = myClass.getAdjacentCells((1,1), with:data)
        XCTAssertEqual(expected, result)
    }
    
    func testGetAdjacentSeat1() throws {
        let data = [Array("#.."),Array(".L."),Array("...")]
        let expected = Array("#.......")
        let result = myClass.getAdjacentCells((1,1), with:data)
        XCTAssertEqual(expected, result)
    }
    
    func testGetAdjacentSeat2() throws {
        let data = [Array("X.."),Array("..."),Array("...")]
        let expected = Array("...")
        let result = myClass.getAdjacentCells((0,0), with:data)
        XCTAssertEqual(expected, result)
    }
    
    func testGetAdjacentSeat4() throws {
        let data = [Array("..."),Array("..#"),Array(".#X")]
        let expected = Array(".##")
        let result = myClass.getAdjacentCells((2,2), with:data)
        XCTAssertEqual(expected, result)
    }
    
    func testGetAdjacentSeat5() throws {
        let data = [Array("..."),Array("..#"),Array(".X#")]
        let expected = Array("..#.#")
        let result = myClass.getAdjacentCells((1,2), with:data)
        XCTAssertEqual(expected, result)
    }
    
    func testExampleStep1() throws {
        let data = """
        L.LL.LL.LL
        LLLLLLL.LL
        L.L.L..L..
        LLLL.LL.LL
        L.LL.LL.LL
        L.LLLLL.LL
        ..L.L.....
        LLLLLLLLLL
        L.LLLLLL.L
        L.LLLLL.LL
        """
        let splittedData = data.split(separator: "\n").map({Array(String($0))})
        
        let expected = """
        #.##.##.##
        #######.##
        #.#.#..#..
        ####.##.##
        #.##.##.##
        #.#####.##
        ..#.#.....
        ##########
        #.######.#
        #.#####.##
        """
        let splittedExpected = expected.split(separator: "\n").map({Array(String($0))})
        
        let result = myClass.processOneStepInGrid(with: splittedData, useSeatScanner: false)
        
        XCTAssertEqual(result.0, splittedExpected)
    }
    
    func testExampleStep2() throws {
        let data = """
        #.##.##.##
        #######.##
        #.#.#..#..
        ####.##.##
        #.##.##.##
        #.#####.##
        ..#.#.....
        ##########
        #.######.#
        #.#####.##
        """
        let splittedData = data.split(separator: "\n").map({Array(String($0))})
        
        let expected = """
        #.LL.L#.##
        #LLLLLL.L#
        L.L.L..L..
        #LLL.LL.L#
        #.LL.LL.LL
        #.LLLL#.##
        ..L.L.....
        #LLLLLLLL#
        #.LLLLLL.L
        #.#LLLL.##
        """
        let splittedExpected = expected.split(separator: "\n").map({Array(String($0))})
        
        let result = myClass.processOneStepInGrid(with: splittedData)
        
        XCTAssertEqual(result.0, splittedExpected)
    }
    
    func testExampleStep3() throws {
        let data = """
        #.LL.L#.##
        #LLLLLL.L#
        L.L.L..L..
        #LLL.LL.L#
        #.LL.LL.LL
        #.LLLL#.##
        ..L.L.....
        #LLLLLLLL#
        #.LLLLLL.L
        #.#LLLL.##
        """
        let splittedData = data.split(separator: "\n").map({Array(String($0))})
        
        let expected = """
        #.##.L#.##
        #L###LL.L#
        L.#.#..#..
        #L##.##.L#
        #.##.LL.LL
        #.###L#.##
        ..#.#.....
        #L######L#
        #.LL###L.L
        #.#L###.##
        """
        let splittedExpected = expected.split(separator: "\n").map({Array(String($0))})
        
        let result = myClass.processOneStepInGrid(with: splittedData)
        
        XCTAssertEqual(result.0, splittedExpected)
    }
    
    func testStabilizedFerryExample() throws {
        let data = """
        L.LL.LL.LL
        LLLLLLL.LL
        L.L.L..L..
        LLLL.LL.LL
        L.LL.LL.LL
        L.LLLLL.LL
        ..L.L.....
        LLLLLLLLLL
        L.LLLLLL.L
        L.LLLLL.LL
        """
        let splittedArray = data.split(separator: "\n").map({Array(String($0))})
        
        let result = myClass.getNumberOfSeatsTakenWithStabilizedFerry(splittedArray, andSeatScanner: false)
        
        XCTAssertEqual(result, 37)
    }
    
    func testGetNumberOfSeatsTakenWithStabilizedFerry() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_11", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let splittedArray = stringData.split(separator: "\n").map({Array(String($0))})
            XCTAssertNotNil(splittedArray)
            
            let result = myClass.getNumberOfSeatsTakenWithStabilizedFerry(splittedArray, andSeatScanner: false)
            XCTAssertEqual(result, 2265)
        } else {
            XCTAssertNotNil(data)
        }
    }
    

    // MARK: PART 2
    func testGetScannedSeats1() throws {
        let data = """
        .......#.
        ...#.....
        .#.......
        .........
        ..#L....#
        ....#....
        .........
        #........
        ...#.....
        """
        let splittedArray = data.split(separator: "\n").map({Array(String($0))})
        
        let result = myClass.getNumberOfSeatsTakenAround((x: 3, y: 4), with: splittedArray)
        
        XCTAssertEqual(result, 8)
    }
    
    func testGetScannedSeats2() throws {
        let data = """
        .............
        .L.L.#.#.#.#.
        .............
        """
        let splittedArray = data.split(separator: "\n").map({Array(String($0))})
        
        let result = myClass.getNumberOfSeatsTakenAround((x: 1, y: 1), with: splittedArray)
        
        XCTAssertEqual(result, 0)
    }
    
    func testGetScannedSeats3() throws {
        let data = """
        .............
        .L.L.#.#.#.#.
        .............
        """
        let splittedArray = data.split(separator: "\n").map({Array(String($0))})
        
        let result = myClass.getNumberOfSeatsTakenAround((x: 3, y: 1), with: splittedArray)
        
        XCTAssertEqual(result, 1)
    }
    
    func testGetScannedSeats4() throws {
        let data = """
        .##.##.
        #.#.#.#
        ##...##
        ...L...
        ##...##
        #.#.#.#
        .##.##.
        """
        let splittedArray = data.split(separator: "\n").map({Array(String($0))})
        
        let result = myClass.getNumberOfSeatsTakenAround((x: 3, y: 3), with: splittedArray)
        
        XCTAssertEqual(result, 0)
    }
    
    func testExampleWithScannerStep1() throws {
        let data = """
        L.LL.LL.LL
        LLLLLLL.LL
        L.L.L..L..
        LLLL.LL.LL
        L.LL.LL.LL
        L.LLLLL.LL
        ..L.L.....
        LLLLLLLLLL
        L.LLLLLL.L
        L.LLLLL.LL
        """
        let splittedData = data.split(separator: "\n").map({Array(String($0))})
        
        let expected = """
        #.##.##.##
        #######.##
        #.#.#..#..
        ####.##.##
        #.##.##.##
        #.#####.##
        ..#.#.....
        ##########
        #.######.#
        #.#####.##
        """
        let splittedExpected = expected.split(separator: "\n").map({Array(String($0))})
        
        let result = myClass.processOneStepInGrid(with: splittedData, useSeatScanner: true)
        
        XCTAssertEqual(result.0, splittedExpected)
    }
    
    func testExampleWithScannerStep2() throws {
        let data = """
        #.##.##.##
        #######.##
        #.#.#..#..
        ####.##.##
        #.##.##.##
        #.#####.##
        ..#.#.....
        ##########
        #.######.#
        #.#####.##
        """
        let splittedData = data.split(separator: "\n").map({Array(String($0))})
        
        let expected = """
        #.LL.LL.L#
        #LLLLLL.LL
        L.L.L..L..
        LLLL.LL.LL
        L.LL.LL.LL
        L.LLLLL.LL
        ..L.L.....
        LLLLLLLLL#
        #.LLLLLL.L
        #.LLLLL.L#
        """
        let splittedExpected = expected.split(separator: "\n").map({Array(String($0))})
        
        let result = myClass.processOneStepInGrid(with: splittedData, useSeatScanner: true)
        
        XCTAssertEqual(result.0, splittedExpected)
    }
    
    func testStabilizedFerryExampleAndScanner() throws {
        let data = """
        L.LL.LL.LL
        LLLLLLL.LL
        L.L.L..L..
        LLLL.LL.LL
        L.LL.LL.LL
        L.LLLLL.LL
        ..L.L.....
        LLLLLLLLLL
        L.LLLLLL.L
        L.LLLLL.LL
        """
        let splittedArray = data.split(separator: "\n").map({Array(String($0))})
        
        let result = myClass.getNumberOfSeatsTakenWithStabilizedFerry(splittedArray, andSeatScanner: true)
        
        XCTAssertEqual(result, 26)
    }
    
    func testGetNumberOfSeatsTakenWithStabilizedFerryAndSeatScanner() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_11", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let splittedArray = stringData.split(separator: "\n").map({Array(String($0))})
            XCTAssertNotNil(splittedArray)
            
            let result = myClass.getNumberOfSeatsTakenWithStabilizedFerry(splittedArray, andSeatScanner: true)
            XCTAssertEqual(result, 2045)
        } else {
            XCTAssertNotNil(data)
        }
    }
    
}
