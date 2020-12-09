//
//  Created by Nicolas Linard on 10/12/2020.
//

import XCTest
@testable import Advent2020Challenge1

class MyClass202010 {
    
    
}

class Advent2020Challenge10Tests: XCTestCase {
    
    var myClass: MyClass202010!
    
    override func setUpWithError() throws {
        myClass = MyClass202010()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
       
    }
    
    func testGetFirstInvalidNumber() throws {
        let path:String = Bundle.main.path(forResource: "Input2020_9", ofType: "txt")!
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        if let stringData = data {
            let splittedArray = stringData.split(separator: "\n").map({Int($0) ?? 0})
            XCTAssertNotNil(splittedArray)
            
            //let result = myClass.getFirstInvalidNumber(splittedArray,preambleSize: 25)
            //XCTAssertEqual(result, 57195069)
        } else {
            XCTAssertNotNil(data)
        }
    }
}
