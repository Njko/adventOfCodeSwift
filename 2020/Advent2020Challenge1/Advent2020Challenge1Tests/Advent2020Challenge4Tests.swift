//
//  Created by Nicolas Linard on 04/12/2020.
//

import XCTest
@testable import Advent2020Challenge1

struct PassportField{
    static let BirthYear =      (key: "byr", regex: #"(\d{4})"#,length : 4, range: 1920...2002)
    static let IssueYear =      (key: "iyr", regex: #"(\d{4})"#,length : 4, range: 2010...2020)
    static let ExpirationYear = (key: "eyr", regex: #"(\d{4})"#,length : 4,range: 2020...2030)
    static let Height =         (key: "hgt", regex: #"(\d*)(in|cm)"#,rangeInch: 59...76, rangeCentimeters: 150...193)
    static let HairColor =      (key: "hcl", regex: "(\\#[a-f0-9]{6})", length: 7)
    static let EyeColor =       (key: "ecl",regex: #"(amb|blu|brn|gry|grn|hzl|oth)"#, length: 3)
    static let PassportId =     (key: "pid",regex: #"(\d{9})"#, length: 9)
}

enum PassportStatus {
    case valid
    case invalid(PassportRejectReason)
}

enum PassportRejectReason {
    case incorrectNumberOfFields
    case missingRequiredFields
    case invalidBirthYear
    case invalidIssueYear
    case invalidExpirationYear
    case invalidHeight
    case invalidHairColor
    case invalidEyeColor
    case invalidPassportID
}

class MyClass202004 {
    
    let EmptyString = ""

    func getNumberOfValidPassports(_ data: Array<String>, withReinforcedChecks: Bool = false) -> Int {
        var numberOfValidPassport = 0
        
        let passports : Array<Dictionary<String, String>> = extractPassports(data)
        
        for passport in passports {
            let passportValidity: Array<PassportStatus> = isPassportValid(passport, withReinforcedChecks: withReinforcedChecks)
            var isPasspordValid = true
            //print("PassportStatus: \(passportValidity)")
            
            for fieldChecked in passportValidity {
                switch fieldChecked {
                    case .invalid(_):
                    isPasspordValid = false
                    case .valid:
                        break
                }
            }
            
            if isPasspordValid {
                //print(passport)
                numberOfValidPassport += 1
            }
        }
        
        return numberOfValidPassport
    }
    
    private func extractPassports(_ data: Array<String>) -> Array<Dictionary<String, String>> {
        var extractedPassport : Array<Dictionary<String, String>>  = []
        
        for passportAsText in data {
            var passport : Dictionary<String, String> = [:]
            let lines = passportAsText.split(separator: "\n").map({ String($0) })
            for line in lines {
                let components = line.split(separator: " ")
                for component in components {
                    let keyValue = component.split(separator: ":")
                    let key = String(keyValue[0])
                    let value = String(keyValue[1])
                  passport[key] = value
                }
            }
            extractedPassport.append(passport)
        }
        
        return extractedPassport
    }
    
    private func isPassportValid(_ passort : Dictionary<String, String>, withReinforcedChecks: Bool) -> [PassportStatus]{
        
        let keys = Set(passort.keys)
        let requiredKeys = Set([PassportField.BirthYear.key,
                                PassportField.IssueYear.key,
                                PassportField.ExpirationYear.key,
                                PassportField.Height.key,
                                PassportField.HairColor.key,
                                PassportField.EyeColor.key,
                                PassportField.PassportId.key])
        
        guard keys.count >= 7 else {
            return [.invalid(.incorrectNumberOfFields)]
        }
        guard requiredKeys.isSubset(of: keys) else {
            return [.invalid(.missingRequiredFields)]
        }
        
        if (!withReinforcedChecks) {
            return [.valid]
        }
        
        let dateOfBirth: PassportStatus = isDateOfBirthValid(passort) ? .valid : .invalid(.invalidBirthYear)
        let issueYear: PassportStatus = isIssueYearValid(passort) ? .valid : .invalid(.invalidIssueYear)
        let expirationYear: PassportStatus = isExpirationYearValid(passort) ? .valid : .invalid(.invalidExpirationYear)
        let height: PassportStatus = isHeightValid(passort) ? .valid : .invalid(.invalidHeight)
        let hairColor: PassportStatus = isHairColorValid(passort) ? .valid : .invalid(.invalidHairColor)
        let isEyeColor: PassportStatus = isEyeColorValid(passort) ? .valid : .invalid(.invalidEyeColor)
        let passportId: PassportStatus = isPassportIdValid(passort) ? .valid : .invalid(.invalidPassportID)
        
        return [dateOfBirth, issueYear, expirationYear, height,hairColor,isEyeColor,passportId]
    }
    
    func isDateOfBirthValid(_ passort : Dictionary<String, String>) -> Bool{
        
        guard let dateValue = passort[PassportField.BirthYear.key],
              dateValue.count == PassportField.BirthYear.length else {
            return false
        }
        let matchedDate = dateValue.matches(regex: PassportField.BirthYear.regex).first ?? EmptyString
        return !matchedDate.isEmpty && PassportField.BirthYear.range.contains(Int(matchedDate) ?? 0)
    }
    
    func isIssueYearValid(_ passort : Dictionary<String, String>) -> Bool{
        
        guard let dateValue = passort[PassportField.IssueYear.key],
              dateValue.count == PassportField.IssueYear.length else {
            return false
        }
        let matchedDate = dateValue.matches(regex: PassportField.IssueYear.regex).first ?? EmptyString
        return !matchedDate.isEmpty && PassportField.IssueYear.range.contains(Int(matchedDate) ?? 0)
    }
    
    func isExpirationYearValid(_ passort : Dictionary<String, String>) -> Bool{
        
        guard let dateValue = passort[PassportField.ExpirationYear.key],
              dateValue.count == PassportField.ExpirationYear.length else {
            return false
        }
        let matchedDate = dateValue.matches(regex: PassportField.ExpirationYear.regex).first ?? EmptyString
        return !matchedDate.isEmpty && PassportField.ExpirationYear.range.contains(Int(matchedDate) ?? 0)
    }
    
    func isHeightValid(_ passort : Dictionary<String, String>) -> Bool{
        
        guard let heightAsString = passort[PassportField.Height.key] else {
            return false
        }
        
        let matchedHeightValue = heightAsString.matches(regex: PassportField.Height.regex)
        if matchedHeightValue.count < 2 {
            return false
        }
        
        let value = matchedHeightValue[0]
        let measure = matchedHeightValue[1]
        
        guard let intValue = Int(value) else {
            return false
        }
        
        switch measure {
        case "cm":
            return PassportField.Height.rangeCentimeters.contains(intValue)
        case "in":
            return PassportField.Height.rangeInch.contains(intValue)
        default:
            return false
        }
        
    }
    
    func isHairColorValid(_ passort : Dictionary<String, String>) -> Bool{
        
        guard let hairColorValue = passort[PassportField.HairColor.key],
              hairColorValue.count == PassportField.HairColor.length else {
            return false
        }
        let matchedHairColor = hairColorValue.matches(regex: PassportField.HairColor.regex).first ?? EmptyString
        return !matchedHairColor.isEmpty
    }
    
    func isEyeColorValid(_ passort : Dictionary<String, String>) -> Bool{
        
        guard let eyeColorValue = passort[PassportField.EyeColor.key],
              eyeColorValue.count == PassportField.EyeColor.length else {
            return false
        }
        
        
        let matchedEyeColor = eyeColorValue.matches(regex: PassportField.EyeColor.regex).first ?? EmptyString
        return !matchedEyeColor.isEmpty
    }
    
    func isPassportIdValid(_ passort : Dictionary<String, String>) -> Bool{
        
        guard let passportIdValue = passort[PassportField.PassportId.key],
              passportIdValue.count == PassportField.PassportId.length else {
            return false
        }
        let matchedPassportId = passportIdValue.matches(regex: PassportField.PassportId.regex).first ?? EmptyString
        return !matchedPassportId.isEmpty
    }

}

class Advent2020Challenge4Tests: XCTestCase {
    
    var myClass: MyClass202004!

    override func setUpWithError() throws {
        myClass = MyClass202004()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_4_example_part1", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let cleanedStringData = stringData.replacingOccurrences(of: "\n\n", with: ";")
            let splittedArray = cleanedStringData
                .split(separator: ";")
                .map({String($0).replacingOccurrences(of: "\n", with: " ")})
            XCTAssertNotNil(splittedArray)
            
            let result = myClass.getNumberOfValidPassports(splittedArray)
            XCTAssertEqual(result, 2)
        } else {
            XCTAssertNotNil(data)
        }
    }
    
    func testGetNumberOfValidPassports() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_4", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let cleanedStringData = stringData.replacingOccurrences(of: "\n\n", with: ";")
            let splittedArray = cleanedStringData
                .split(separator: ";")
                .map({String($0).replacingOccurrences(of: "\n", with: " ")})
            XCTAssertNotNil(splittedArray)
            
            let result = myClass.getNumberOfValidPassports(splittedArray)
            XCTAssertEqual(result, 192)
        } else {
            XCTAssertNotNil(data)
        }
    }
    
    func testExamplePart2Valid() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_4_example_part2_valid", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let cleanedStringData = stringData.replacingOccurrences(of: "\n\n", with: ";")
            let splittedArray = cleanedStringData
                .split(separator: ";")
                .map({String($0).replacingOccurrences(of: "\n", with: " ")})
            XCTAssertNotNil(splittedArray)
            
            let result = myClass.getNumberOfValidPassports(splittedArray,withReinforcedChecks: true)
            XCTAssertEqual(result, 4)
        } else {
            XCTAssertNotNil(data)
        }
    }
    
    func testExamplePart2Invalid() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_4_example_part2_invalid", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let cleanedStringData = stringData.replacingOccurrences(of: "\n\n", with: ";")
            let splittedArray = cleanedStringData
                .split(separator: ";")
                .map({String($0).replacingOccurrences(of: "\n", with: " ")})
            XCTAssertNotNil(splittedArray)
            
            let result = myClass.getNumberOfValidPassports(splittedArray,withReinforcedChecks: true)
            XCTAssertEqual(result, 0)
        } else {
            XCTAssertNotNil(data)
        }
    }
    
    func testGetNumberOfValidPassportsPart2() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_4", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let cleanedStringData = stringData.replacingOccurrences(of: "\n\n", with: ";")
            let splittedArray = cleanedStringData
                .split(separator: ";")
                .map({String($0)})
            XCTAssertNotNil(splittedArray)
            
            let result = myClass.getNumberOfValidPassports(splittedArray,withReinforcedChecks: true)
            XCTAssertEqual(result, 101)
        } else {
            XCTAssertNotNil(data)
        }
    }
    
    func testBirthYearIsValid() {
        
        XCTAssertTrue(myClass.isDateOfBirthValid(["byr":"1920"]))
        XCTAssertTrue(myClass.isDateOfBirthValid(["byr":"1984"]))
        XCTAssertTrue(myClass.isDateOfBirthValid(["byr":"2002"]))
    }
    
    func testBirthYearIsInvalid() {
        
        XCTAssertFalse(myClass.isDateOfBirthValid(["byr":"20022003"]))
        XCTAssertFalse(myClass.isDateOfBirthValid(["byr":"aze31"]))
        XCTAssertFalse(myClass.isDateOfBirthValid(["byr":""]))
        XCTAssertFalse(myClass.isDateOfBirthValid(["byr":"2003"]))
        XCTAssertFalse(myClass.isDateOfBirthValid(["byr":"azeZ"]))
    }
    
    func testIssueYearIsValid() {
        XCTAssertTrue(myClass.isIssueYearValid(["iyr":"2010"]))
        XCTAssertTrue(myClass.isIssueYearValid(["iyr":"2015"]))
        XCTAssertTrue(myClass.isIssueYearValid(["iyr":"2020"]))
    }
    
    func testIssueYearIsInvalid() {
        
        XCTAssertFalse(myClass.isIssueYearValid(["iyr":""]))
        XCTAssertFalse(myClass.isIssueYearValid(["iyr":"2003"]))
        XCTAssertFalse(myClass.isIssueYearValid(["iyr":"azer"]))
        XCTAssertFalse(myClass.isIssueYearValid(["iyr":"200302"]))
        XCTAssertFalse(myClass.isIssueYearValid(["iyr":"200azee"]))
    }
    
    func testExpirationYearIsValid() {
        
        XCTAssertTrue(myClass.isExpirationYearValid(["eyr":"2020"]))
        XCTAssertTrue(myClass.isExpirationYearValid(["eyr":"2025"]))
        XCTAssertTrue(myClass.isExpirationYearValid(["eyr":"2030"]))
    }
    
    func testExpirationYearIsInvalid() {
       
        XCTAssertFalse(myClass.isExpirationYearValid(["eyr":""]))
        XCTAssertFalse(myClass.isExpirationYearValid(["eyr":"2003"]))
        XCTAssertFalse(myClass.isExpirationYearValid(["eyr":"azer"]))
        XCTAssertFalse(myClass.isExpirationYearValid(["eyr":"200302"]))
        XCTAssertFalse(myClass.isExpirationYearValid(["eyr":"200azee"]))
    }
    
    func testHeighIsValid() {
        XCTAssertTrue(myClass.isHeightValid(["hgt":"150cm"]))
        XCTAssertTrue(myClass.isHeightValid(["hgt":"190cm"]))
        XCTAssertTrue(myClass.isHeightValid(["hgt":"193cm"]))
        
        XCTAssertTrue(myClass.isHeightValid(["hgt":"59in"]))
        XCTAssertTrue(myClass.isHeightValid(["hgt":"60in"]))
        XCTAssertTrue(myClass.isHeightValid(["hgt":"76in"]))
    }
    
    func testHeightIsInvalid() {
        
        XCTAssertFalse(myClass.isHeightValid(["hgt":"194"]))
        XCTAssertFalse(myClass.isHeightValid(["hgt":"cm"]))
        XCTAssertFalse(myClass.isHeightValid(["hgt":"in"]))
        XCTAssertFalse(myClass.isHeightValid(["hgt":""]))
        XCTAssertFalse(myClass.isHeightValid(["hgt":"149cm"]))
        XCTAssertFalse(myClass.isHeightValid(["hgt":"194cm"]))
        XCTAssertFalse(myClass.isHeightValid(["hgt":"58in"]))
        XCTAssertFalse(myClass.isHeightValid(["hgt":"77in"]))
        XCTAssertFalse(myClass.isHeightValid(["hgt":"165in"]))
    }
    
    func testHairColorIsValid() {
        
        XCTAssertTrue(myClass.isHairColorValid(["hcl":"#ffffff"]))
        XCTAssertTrue(myClass.isHairColorValid(["hcl":"#000000"]))
        XCTAssertTrue(myClass.isHairColorValid(["hcl":"#123abc"]))
        XCTAssertTrue(myClass.isHairColorValid(["hcl":"#a1b2c3"]))
        XCTAssertTrue(myClass.isHairColorValid(["hcl":"#abc123"]))
    }
    
    func testHairColorIsinvalid() {
       
        XCTAssertFalse(myClass.isHairColorValid(["hcl":"123abc"]))
        XCTAssertFalse(myClass.isHairColorValid(["hcl":""]))
        XCTAssertFalse(myClass.isHairColorValid(["hcl":"##123abc"]))
        XCTAssertFalse(myClass.isHairColorValid(["hcl":"#1234567"]))
        XCTAssertFalse(myClass.isHairColorValid(["hcl":"#AAAAAAA"]))
    }
    
    func testEyeColorIsValid() {
        XCTAssertTrue(myClass.isEyeColorValid(["ecl":"amb"]))
        XCTAssertTrue(myClass.isEyeColorValid(["ecl":"blu"]))
        XCTAssertTrue(myClass.isEyeColorValid(["ecl":"brn"]))
        XCTAssertTrue(myClass.isEyeColorValid(["ecl":"gry"]))
        XCTAssertTrue(myClass.isEyeColorValid(["ecl":"grn"]))
        XCTAssertTrue(myClass.isEyeColorValid(["ecl":"hzl"]))
        XCTAssertTrue(myClass.isEyeColorValid(["ecl":"oth"]))
    }
    
    func testEyeColorIsInvalid() {
        
        XCTAssertFalse(myClass.isEyeColorValid(["ecl":"wat"]))
        XCTAssertFalse(myClass.isEyeColorValid(["ecl":"blue"]))
        XCTAssertFalse(myClass.isEyeColorValid(["ecl":""]))
        XCTAssertFalse(myClass.isEyeColorValid(["ecl":"123456"]))
        XCTAssertFalse(myClass.isEyeColorValid(["ecl":"#ffffff"]))
    }
    
    func testPassportIdIsValid() {
        
        XCTAssertTrue(myClass.isPassportIdValid(["pid":"123456789"]))
        XCTAssertTrue(myClass.isPassportIdValid(["pid":"000000001"]))
        XCTAssertTrue(myClass.isPassportIdValid(["pid":"000000000"]))
    }
    
    func testPassportIdIsInvalid() {
        
        XCTAssertFalse(myClass.isPassportIdValid(["pid":"0123456789"]))
        XCTAssertFalse(myClass.isPassportIdValid(["pid":""]))
        XCTAssertFalse(myClass.isPassportIdValid(["pid":"azearearar"]))
    }
}
