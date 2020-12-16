//
//  Created by Nicolas Linard on 10/12/2020.
//

import XCTest
@testable import Advent2020Challenge1

class MyClass202016 {
    func getErrorRate(withRules rules : Array<String>, ticket: Array<Int>, andNearbyTickets nearbyTickets: Array<String>) -> Int {
        let rulesRanges = extractRangesInRules(rules)
        var errors: Array<Int> = []
        
        for nearbyTicket in nearbyTickets {
            let ticketComponents = nearbyTicket.split(separator: ",").map({ Int($0) ?? 0})
            for component in ticketComponents {
                var componentInRange = false
                var ruleIndex = 0
                while !componentInRange && ruleIndex<rulesRanges.count {
                    if rulesRanges[ruleIndex].rangeLow.contains(component) || rulesRanges[ruleIndex].rangeHigh.contains(component) {
                        componentInRange = true
                    }
                    ruleIndex += 1
                }
                if !componentInRange {
                    errors.append(component)
                }
            }
            
        }
        
        return errors.reduce(0,+)
    }

    func getValidTickets (withRules rules : Array<String>, ticket: Array<Int>, andNearbyTickets nearbyTickets: Array<String>) -> Array<Array<Int>> {
        let rulesRanges = extractRangesInRules(rules)
        var validTickets : Array<Array<Int>> = []
        var invalidTicketsIndex : Set<Int> = []

        for indexTicket in 0 ..< nearbyTickets.count {
            let nearbyTicketContent = nearbyTickets[indexTicket].split(separator: ",").map({ Int($0) ?? 0})

            var isTicketValid = true

            for indexValue in 0 ..< nearbyTicketContent.count {
                let value = nearbyTicketContent[indexValue]
                var valueInRange = false
                var ruleIndex = 0
                while !valueInRange && ruleIndex < rulesRanges.count {
                    if rulesRanges[ruleIndex].rangeLow.contains(value) || rulesRanges[ruleIndex].rangeHigh.contains(value) {
                        valueInRange = true
                    }
                    ruleIndex += 1
                }
                if !valueInRange {
                    isTicketValid = false
                }
            }

            if isTicketValid {
                validTickets.append(nearbyTicketContent)
            }
        }
        
        return validTickets
    }

    func isCurrentTicketValid(ticket :Array<Int>, withRules rules:Array<(name:String, rangeLow: ClosedRange<Int>, rangeHigh:ClosedRange<Int>)>) -> Bool {

        for index in 0 ..< rules.count {
            if ticket.filter({ rules[index].rangeLow.contains($0) || rules[index].rangeHigh.contains($0) }).count == ticket.count {
                return true
            }
        }
        return false
    }
    
    func extractRangesInRules(_ rules: Array<String>) -> Array<(name:String, rangeLow: ClosedRange<Int>, rangeHigh:ClosedRange<Int>)> {
        
        var ranges : Array<(name:String, rangeLow: ClosedRange<Int>, rangeHigh:ClosedRange<Int>)> = []
        
        for rule in rules {
            let matches = rule.matches(regex: #"(.*): (\d*)-(\d*) or (\d*)-(\d*)"#)
            
            if matches.count<5 {
                continue
            }
            let value1 = Int(matches[1]) ?? 0
            let value2 = Int(matches[2]) ?? 0
            let value3 = Int(matches[3]) ?? 0
            let value4 = Int(matches[4]) ?? 0
            ranges.append((name: matches[0], rangeLow: value1...value2, rangeHigh: value3...value4))
        }
        
        return ranges
    }
    
    func matchInfos(withRules rules : Array<String>, ticket: Array<Int>, andNearbyTickets nearbyTickets: Array<String>) -> Dictionary<Int,String>{
        var rulesRanges = extractRangesInRules(rules)
        var validTickets = getValidTickets(withRules: rules, ticket: ticket, andNearbyTickets: nearbyTickets)
        validTickets.insert(ticket, at: 0)
        var rulesMatched : Dictionary<Int,[String]> = [:]
        for rowIndex in 0 ..< validTickets[0].count { // foreach row
            //let reducedRules = rulesRanges.filter({ !rulesMatched.values.contains($0.name) })
            rulesMatched[rowIndex] = []
            for rule in rulesRanges { // find a rule that matches
                var ruleMatched = true
                for ticketValue in validTickets {
                    if !rule.rangeLow.contains(ticketValue[rowIndex])
                               && !rule.rangeHigh.contains(ticketValue[rowIndex]) {
                        ruleMatched = false
                    }
                }
                if ruleMatched {
                    rulesMatched[rowIndex]?.append(rule.name)
                }
            }
        }
        //rows and rules are matched only a lot of results to reduce
        var reducedMatches : Dictionary<Int,String> = [:]
        var foundItems : Array<String> = []
        for match in rulesMatched.sorted(by: { $0.1.count < $1.1.count }) {

            var possibility = Set(match.value)
            possibility.subtract(Set(foundItems))
                // error
            assert(possibility.count == 1)
            //ok
            reducedMatches[match.key] = Array(possibility)[0]
            foundItems.append(Array(possibility)[0])
        }
        
        return reducedMatches
    }
    
    func validNearbyTicketsToRowValues(_ nearbyTickets: Array<Array<Int>>, withNumberOfRules nbRules:Int) -> Array<Array<Int>> {
        
        var rowValues = Array(repeating: Array(repeating: 0, count: nearbyTickets.count), count: nbRules)
        
        for x in 0 ..< nearbyTickets.count  {
            for y in 0 ..< nbRules{
                rowValues[y][x] = nearbyTickets[x][y]
            }
        }
        
        return rowValues
    }
    
    func findRowValue(withRules rules : Array<String>, ticket: Array<Int>, andNearbyTickets nearbyTickets: Array<String>, withName name:String) -> Int {
        
        let matchingFields: Dictionary<Int, String> = matchInfos(withRules: rules, ticket: ticket, andNearbyTickets: nearbyTickets)
        
        var result = 1
        for match in matchingFields.filter({$0.value.contains(name)}) {
            result *= ticket[match.key]
        }

        return result
    }
}

class Advent2020Challenge16Tests: XCTestCase {
    
    var myClass: MyClass202016!
    
    override func setUpWithError() throws {
        myClass = MyClass202016()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: PART 1
    
    func testExtractRules () {
        let stringData = """
        class: 1-3 or 5-7
        row: 6-11 or 33-44
        seat: 13-40 or 45-50
"""
        let rules = stringData.split(separator: "\n").map({ String($0) })
        
        let result = myClass.extractRangesInRules(rules)
        XCTAssertEqual(result[0].rangeLow, 1...3)
        XCTAssertEqual(result[0].rangeHigh, 5...7)
        XCTAssertEqual(result[1].rangeLow, 6...11)
        XCTAssertEqual(result[1].rangeHigh, 33...44)
        XCTAssertEqual(result[2].rangeLow, 13...40)
        XCTAssertEqual(result[2].rangeHigh, 45...50)
    }
    
    func testExamples() {
       let stringData = """
        class: 1-3 or 5-7
        row: 6-11 or 33-44
        seat: 13-40 or 45-50

        your ticket:
        7,1,14

        nearby tickets:
        7,3,47
        40,4,50
        55,2,20
        38,6,12
        """
        
        let cleanedStringData = stringData.replacingOccurrences(of: "\n\n", with: ";")
        let splittedData = cleanedStringData
            .split(separator: ";")
            .map({String($0)})
        
        let rules = splittedData[0].split(separator: "\n").map({ String($0) })
        let ticket = splittedData[1].split(separator: "\n").map({ String($0) })[1].split(separator: ",").map({ Int($0) ?? 0})
        var nearbyTickets = splittedData[2].split(separator: "\n").map({ String($0) })
        nearbyTickets.remove(at: 0)
        
        let result = myClass.getErrorRate(withRules: rules, ticket: ticket, andNearbyTickets: nearbyTickets)
        
        XCTAssertEqual(result, 71)
        
    }
        
    func testGetErrorRate() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_16", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            
            let cleanedStringData = stringData.replacingOccurrences(of: "\n\n", with: ";")
            let splittedData = cleanedStringData
                .split(separator: ";")
                .map({String($0)})
            
            let rules = splittedData[0].split(separator: "\n").map({ String($0) })
            let ticket = splittedData[1].split(separator: "\n").map({ String($0) })[1].split(separator: ",").map({ Int($0) ?? 0})
            var nearbyTickets = splittedData[2].split(separator: "\n").map({ String($0) })
            nearbyTickets.remove(at: 0)
            
            let result = myClass.getErrorRate(withRules: rules, ticket: ticket, andNearbyTickets: nearbyTickets)
            XCTAssertEqual(result, 29759)
        } else {
            XCTAssertNotNil(data)
        }
    }
    

    // MARK: PART 2
    
    func testExamplesPart2() {
        let stringData = """
         class: 1-3 or 5-7
         row: 6-11 or 33-44
         seat: 13-40 or 45-50

         your ticket:
         7,1,14

         nearby tickets:
         7,3,47
         40,4,50
         55,2,20
         38,6,12
         """
         
         let cleanedStringData = stringData.replacingOccurrences(of: "\n\n", with: ";")
         let splittedData = cleanedStringData
             .split(separator: ";")
             .map({String($0)})
         
         let rules = splittedData[0].split(separator: "\n").map({ String($0) })
         let ticket = splittedData[1].split(separator: "\n").map({ String($0) })[1].split(separator: ",").map({ Int($0) ?? 0})
         var nearbyTickets = splittedData[2].split(separator: "\n").map({ String($0) })
         nearbyTickets.remove(at: 0)
         
         let result = myClass.getValidTickets(withRules: rules, ticket: ticket, andNearbyTickets: nearbyTickets)
         
         XCTAssertEqual(result, [[7,3,47]])
    }
    
    func testExample2Part2() {
        let stringData = """
         class: 1-3 or 5-7
         row: 6-11 or 33-44
         seat: 13-40 or 45-50

         your ticket:
         7,1,14

         nearby tickets:
         3,9,18
         15,1,5
         5,14,9
         """
         
         let cleanedStringData = stringData.replacingOccurrences(of: "\n\n", with: ";")
         let splittedData = cleanedStringData
             .split(separator: ";")
             .map({String($0)})
         
         let rules = splittedData[0].split(separator: "\n").map({ String($0) })
         let ticket = splittedData[1].split(separator: "\n").map({ String($0) })[1].split(separator: ",").map({ Int($0) ?? 0})
         var nearbyTickets = splittedData[2].split(separator: "\n").map({ String($0) })
         nearbyTickets.remove(at: 0)
         
         let result = myClass.getValidTickets(withRules: rules, ticket: ticket, andNearbyTickets: nearbyTickets)
         
         XCTAssertEqual(result, [[3,9,18],[15,1,5],[5,14,9]])
    }
    
    func testValidTicketsToRowOfValues() {
        let validTickets = [[3,9,18],[15,1,5],[5,14,9]]
        let expected = [[3,15,5], [9,1,14], [18,5,9]]
        let result = myClass.validNearbyTicketsToRowValues(validTickets, withNumberOfRules: 3)
        XCTAssertEqual(expected,result)
    }
    
    func testMatching() {
       let stringData = """
        class: 0-1 or 4-19
        row: 0-5 or 8-19
        seat: 0-13 or 16-19

        your ticket:
        11,12,13

        nearby tickets:
        3,9,18
        15,1,5
        5,14,9
        """
        
        let cleanedStringData = stringData.replacingOccurrences(of: "\n\n", with: ";")
        let splittedData = cleanedStringData
            .split(separator: ";")
            .map({String($0)})
        
        let rules = splittedData[0].split(separator: "\n").map({ String($0) })
        let ticket = splittedData[1].split(separator: "\n").map({ String($0) })[1].split(separator: ",").map({ Int($0) ?? 0})
        var nearbyTickets = splittedData[2].split(separator: "\n").map({ String($0) })
        nearbyTickets.remove(at: 0)
        
        let result = myClass.matchInfos(withRules: rules, ticket: ticket, andNearbyTickets: nearbyTickets)
        
        XCTAssertEqual(result[0],"row")
        XCTAssertEqual(result[2], "seat")
        XCTAssertEqual(result[1],"class")
    }
    
    func testFindDepartureExample() {
        let stringData = """
         class: 0-1 or 4-19
         row: 0-5 or 8-19
         seat: 0-13 or 16-19

         your ticket:
         11,12,13

         nearby tickets:
         3,9,18
         15,1,5
         5,14,9
         """
         
         let cleanedStringData = stringData.replacingOccurrences(of: "\n\n", with: ";")
         let splittedData = cleanedStringData
             .split(separator: ";")
             .map({String($0)})
         
         let rules = splittedData[0].split(separator: "\n").map({ String($0) })
         let ticket = splittedData[1].split(separator: "\n").map({ String($0) })[1].split(separator: ",").map({ Int($0) ?? 0})
         var nearbyTickets = splittedData[2].split(separator: "\n").map({ String($0) })
         nearbyTickets.remove(at: 0)
        
         XCTAssertEqual(myClass.findRowValue(withRules: rules, ticket: ticket, andNearbyTickets: nearbyTickets, withName:"row"),11)
        XCTAssertEqual(myClass.findRowValue(withRules: rules, ticket: ticket, andNearbyTickets: nearbyTickets, withName:"class"),12)
        XCTAssertEqual(myClass.findRowValue(withRules: rules, ticket: ticket, andNearbyTickets: nearbyTickets, withName:"seat"),13)
    }
    
    func testFindRowValue() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_16", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            
            let cleanedStringData = stringData.replacingOccurrences(of: "\n\n", with: ";")
            let splittedData = cleanedStringData
                .split(separator: ";")
                .map({String($0)})
            
            let rules = splittedData[0].split(separator: "\n").map({ String($0) })
            let ticket = splittedData[1].split(separator: "\n").map({ String($0) })[1].split(separator: ",").map({ Int($0) ?? 0})
            var nearbyTickets = splittedData[2].split(separator: "\n").map({ String($0) })
            nearbyTickets.remove(at: 0)
            
            let result = myClass.findRowValue(withRules: rules, ticket: ticket, andNearbyTickets: nearbyTickets, withName: "departure")
            XCTAssertEqual(result, 1307550234719)
        } else {
            XCTAssertNotNil(data)
        }
    }
}
