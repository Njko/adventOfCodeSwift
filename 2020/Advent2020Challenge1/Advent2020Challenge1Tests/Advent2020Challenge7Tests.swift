//
//  Created by Nicolas Linard on 07/12/2020.
//

import XCTest
@testable import Advent2020Challenge1

class MyClass202007 {
    func getNumberOfBagsContaining(_ bagName: String, withRules rules: Array<String>) -> Int {
        var listOfBags : Set<String> = Set([bagName])
        var previousNumberOfColors: Int
        repeat {
            previousNumberOfColors = listOfBags.count
            
            for rule in rules {
                let matches = rule.matches(regex: "(.*) bags contain (.*)")
                let matchedBagName: String = matches[0]
                let matchedContentList: String = matches[1]
                let content = matchedContentList.split(separator: ",").map({String($0)})
                var index = 0
                var foundMatch = false
                while index < content.count && !foundMatch && content[0] != "no other bags."{
                    let bag = content[index]
                    let cleanedBag = bag.replacingOccurrences(of: ".", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                    let bagData = cleanedBag.matches(regex: #"([0-9]) (.*) ba(.*)"#)
                    let nameOfBagContent = bagData[1]
                    if listOfBags.contains(nameOfBagContent) {
                        listOfBags.insert(matchedBagName)
                        foundMatch = true
                    }
                    index += 1
                }
            }
        } while previousNumberOfColors != listOfBags.count
        
        return listOfBags.count - 1 //remove the first bag we tried to find
    }
    
    func getNumberOfBagsInside(_ bagName: String, withRules rules: Array<String>) -> Int {
        var remainingRules = rules
        var index = 0
        var ruleFound : String?
        var totalOfBags = 0
        
        while index < rules.count {
            let matches = rules[index].matches(regex: "(.*) bags contain (.*)")
            if (matches[0] == bagName) {
                ruleFound = matches[1]
                remainingRules.remove(at: index)
                break
            }
            index += 1
        }
        
        let content = ruleFound?.split(separator: ",").map({String($0)}) ?? []
        
        if content.count == 1 && content[0] == "no other bags." {
            return 0
        }
        
        for bag in content {
            let cleanedBag = bag.replacingOccurrences(of: ".", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
            let bagData = cleanedBag.matches(regex: #"([0-9]) (.*) ba(.*)"#)
            let numberOfBags = Int(bagData[0]) ?? 0
            let nameOfBagContent = bagData[1]
            totalOfBags += numberOfBags + numberOfBags * getNumberOfBagsInside(nameOfBagContent, withRules: remainingRules)
        }
        
        return totalOfBags
    }
}

class Advent2020Challenge7Tests: XCTestCase {
    
    var myClass: MyClass202007!

    override func setUpWithError() throws {
        myClass = MyClass202007()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let rules = ["light red bags contain 1 bright white bag, 2 muted yellow bags.",
        "dark orange bags contain 3 bright white bags, 4 muted yellow bags.",
        "bright white bags contain 1 shiny gold bag.",
        "muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.",
        "shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.",
        "dark olive bags contain 3 faded blue bags, 4 dotted black bags.",
        "vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.",
        "faded blue bags contain no other bags.",
        "dotted black bags contain no other bags."]
        let result = myClass.getNumberOfBagsContaining("shiny gold", withRules: rules)
        XCTAssertEqual(result, 4)
    }
    
    func testGetNumberOfBagsContainingShinyGold() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_7", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let splittedArray = stringData.split(separator: "\n").map({String($0)})
            XCTAssertNotNil(splittedArray)
            
            let result = myClass.getNumberOfBagsContaining("shiny gold", withRules: splittedArray)
            XCTAssertEqual(result, 378)
        } else {
            XCTAssertNotNil(data)
        }
    }
    
    func testExample0() throws {
        let rules = [
        "shiny gold bags contain 2 dark olive bag.",
        "dark olive bags contain no other bags."]
        let result = myClass.getNumberOfBagsInside("shiny gold", withRules: rules)
        XCTAssertEqual(result, 2)
    }
    
    func testExample00() throws {
        let rules = [
        "shiny gold bags contain no other bags."]
        let result = myClass.getNumberOfBagsInside("shiny gold", withRules: rules)
        XCTAssertEqual(result, 0)
    }
    
    func testExample1() throws {
        let rules = [
        "shiny gold bags contain 2 dark blue bags.",
        "dark blue bags contain 2 dark olive bags.",
        "dark olive bags contain no other bags."]
        let result = myClass.getNumberOfBagsInside("shiny gold", withRules: rules)
        XCTAssertEqual(result, 6)
    }
    
    func testExample2() throws {
        let rules = ["light red bags contain 1 bright white bag, 2 muted yellow bags.",
        "dark orange bags contain 3 bright white bags, 4 muted yellow bags.",
        "bright white bags contain 1 shiny gold bag.",
        "muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.",
        "shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.",
        "dark olive bags contain 3 faded blue bags, 4 dotted black bags.",
        "vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.",
        "faded blue bags contain no other bags.",
        "dotted black bags contain no other bags."]
        let result = myClass.getNumberOfBagsInside("shiny gold", withRules: rules)
        XCTAssertEqual(result, 32)
    }
    
    func testExample3() throws {
        let rules = ["shiny gold bags contain 2 dark red bags.",
        "dark red bags contain 2 dark orange bags.",
        "dark orange bags contain 2 dark yellow bags.",
        "dark yellow bags contain 2 dark green bags.",
        "dark green bags contain 2 dark blue bags.",
        "dark blue bags contain 2 dark violet bags.",
        "dark violet bags contain no other bags."]
        let result = myClass.getNumberOfBagsInside("shiny gold", withRules: rules)
        XCTAssertEqual(result, 126)
    }
    
    func testgetNumberOfBagsInsideShinyGold() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_7", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let splittedArray = stringData.split(separator: "\n").map({String($0)})
            XCTAssertNotNil(splittedArray)
            
            let result = myClass.getNumberOfBagsInside("shiny gold", withRules: splittedArray)
            XCTAssertEqual(result, 27526)
        } else {
            XCTAssertNotNil(data)
        }
    }
}
