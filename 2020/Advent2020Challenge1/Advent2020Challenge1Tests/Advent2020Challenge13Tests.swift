//
//  Created by Nicolas Linard on 10/12/2020.
//

import XCTest
@testable import Advent2020Challenge1

class MyClass202013 {
    func arrivalOfBus(_ busFrequency: Int, startingAt startTime: Int, allowJustInTime: Bool = false) -> Int {
        return startTime - startTime % busFrequency + (allowJustInTime ? 0 : busFrequency)
    }
    
    func takeEarliestBus( _ listOfBusses: Array<Int>, startingAt startTime: Int) -> Int {
        
        var earliestBus = listOfBusses[0]
        var earliestBusArrival = arrivalOfBus(listOfBusses[0], startingAt: startTime)
        
        for index in 1..<listOfBusses.count {
            let nextBusArrival = arrivalOfBus(listOfBusses[index], startingAt: startTime)
            
            if nextBusArrival < earliestBusArrival {
                earliestBusArrival = nextBusArrival
                earliestBus = listOfBusses[index]
            }
        }
        
        return earliestBus * (earliestBusArrival - startTime)
    }
    
    func extractBussesFrequenciesAndOffsets( _ listOfBusses: Array<String>) -> Array<(Int, Int)> {
        var frequenciesAndOffsets: Array<(Int, Int)> = []
        
        for index in 0..<listOfBusses.count {
            if let busFrequency = Int(listOfBusses[index]) {
                frequenciesAndOffsets.append((busFrequency, index))
            }
        }
        
        return frequenciesAndOffsets
    }
    
    //This raw translation of the exercice could solve the first
    //examples quickly, this algorithm could not scale
    //I knew that I would have to inscrease the step size but by how many?
    
    /*func findEarlisetMatchOfTimetables(_ listOfBusses: Array<String>) -> Int {
        
        let frequenciesAndOffsets = extractBussesFrequenciesAndOffsets(listOfBusses)
        let largestFrequencyAndOffset: (Int, Int) = frequenciesAndOffsets.max(by: {$0.0 < $1.0 }) ?? (0,0)
        var timestamp = 100000000000000 + largestFrequencyAndOffset.0 - largestFrequencyAndOffset.1
        var areAllBussesHere = false
        
        while !areAllBussesHere {
            var indexOfBus = 0
            areAllBussesHere = true
            while indexOfBus < frequenciesAndOffsets.count {
                let busArrival = arrivalOfBus(frequenciesAndOffsets[indexOfBus].0,
                                                    startingAt: timestamp,
                                                    allowJustInTime: indexOfBus == 0) - frequenciesAndOffsets[indexOfBus].1
                areAllBussesHere = areAllBussesHere && (busArrival == timestamp)
                if !areAllBussesHere {
                    break
                }
                indexOfBus += 1
            }
            timestamp += largestFrequencyAndOffset.0
        }
        
        return timestamp - largestFrequencyAndOffset.0
    }*/
    
    //Well done to tginsberg for the solution so much more efficient than mine
    //The idea behind this is to store the step multiplier after each match with the
    //correct schedule and offset.
    //The value steps keeps the combination of all the previous results matching our rules.
    //
    //Anyway, lesson learned for next time: use a varying step size to quickly decrease the
    //possible cases to test
    
    //https://github.com/tginsberg/advent-2020-kotlin/blob/main/src/main/kotlin/com/ginsberg/advent2020/Day13.kt
    func findEarlisetMatchOfTimetables(_ listOfBusses: Array<String>) -> Int {
        
        let frequenciesAndOffsets = extractBussesFrequenciesAndOffsets(listOfBusses)
        var timestamp = 0
        var steps = frequenciesAndOffsets[0].0
        
        for bus in frequenciesAndOffsets[1..<frequenciesAndOffsets.count] {
            while ((timestamp + bus.1) % bus.0) != 0 {
                timestamp += steps
            }
            steps *= bus.0
        }
        
        return timestamp
    }
    
}

class Advent2020Challenge13Tests: XCTestCase {
    
    var myClass: MyClass202013!
    
    override func setUpWithError() throws {
        myClass = MyClass202013()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: PART 1
    
    func testBusesArrivals() throws {
        XCTAssertEqual(myClass.arrivalOfBus(7, startingAt:939), 945)
        XCTAssertEqual(myClass.arrivalOfBus(13, startingAt:939), 949)
        XCTAssertEqual(myClass.arrivalOfBus(59, startingAt:939), 944)
        XCTAssertEqual(myClass.arrivalOfBus(31, startingAt:939), 961)
        XCTAssertEqual(myClass.arrivalOfBus(19, startingAt:939), 950)
        
        XCTAssertEqual(myClass.arrivalOfBus(7, startingAt:1068781, allowJustInTime: true), 1068781)
    }
    
    func testExample1() throws {
        let data = """
            939
            7,13,x,x,59,x,31,19
            """
        let splittedArray = data.split(separator: "\n").map({ String($0) })
        let listOfBussesTimetables = splittedArray[1].split(separator: ",").map({ Int($0) ?? 0 }).filter({ $0 > 0})
        
        let result = myClass.takeEarliestBus(listOfBussesTimetables, startingAt: Int(splittedArray[0]) ?? 0)
        XCTAssertEqual(result, 295)
    }
    
    func testTakeEarlistBus() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_13", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let splittedArray = stringData.split(separator: "\n").map({ String($0) })
            let listOfBussesTimetables = splittedArray[1].split(separator: ",").map({ Int($0) ?? 0 }).filter({ $0 > 0})
            
            let result = myClass.takeEarliestBus(listOfBussesTimetables, startingAt: Int(splittedArray[0]) ?? 0)
            XCTAssertEqual(result, 102)
        } else {
            XCTAssertNotNil(data)
        }
    }
    

    // MARK: PART 2
    
    func testGetBussesFrequencyAndOffset() throws {
        let data = """
            939
            7,13,x,x,59,x,31,19
            """
        let splittedArray = data.split(separator: "\n").map({ String($0) })
        let listOfBussesTimetables = splittedArray[1].split(separator: ",").map({ String($0) })
        
        let expected = [(7,0), (13,1), (59,4), (31, 6), (19, 7)]
        
        let result = myClass.extractBussesFrequenciesAndOffsets(listOfBussesTimetables)
        XCTAssertEqual(expected[0].0, result[0].0)
        XCTAssertEqual(expected[0].1, result[0].1)
        XCTAssertEqual(expected[1].0, result[1].0)
        XCTAssertEqual(expected[1].1, result[1].1)
        XCTAssertEqual(expected[2].0, result[2].0)
        XCTAssertEqual(expected[2].1, result[2].1)
        XCTAssertEqual(expected[3].0, result[3].0)
        XCTAssertEqual(expected[3].1, result[3].1)
        XCTAssertEqual(expected[4].0, result[4].0)
        XCTAssertEqual(expected[4].1, result[4].1)
    }
    
    func testEarliestMatchOfTimetables() throws {
        XCTAssertEqual(myClass.findEarlisetMatchOfTimetables(["17", "x", "13", "19"]), 3417)
        XCTAssertEqual(myClass.findEarlisetMatchOfTimetables(["67", "7", "59", "61"]), 754018)
        XCTAssertEqual(myClass.findEarlisetMatchOfTimetables(["67", "x", "7", "59", "61"]), 779210)
        XCTAssertEqual(myClass.findEarlisetMatchOfTimetables(["67", "7", "x", "59", "61"]), 1261476)
        XCTAssertEqual(myClass.findEarlisetMatchOfTimetables(["1789", "37", "47", "1889"]), 1202161486)
    }
    
    func testFindEarlisetMatchOfTimetables() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_13", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let splittedArray = stringData.split(separator: "\n").map({ String($0) })
            let listOfBussesTimetables = splittedArray[1].split(separator: ",").map({ String($0) })
            XCTAssertNotNil(splittedArray)
            
            let result = myClass.findEarlisetMatchOfTimetables(listOfBussesTimetables)
            XCTAssertEqual(result, 52203)
        } else {
            XCTAssertNotNil(data)
        }
    }
    
}
