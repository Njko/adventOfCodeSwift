//
//  Utils.swift
//  Advent2020Challenge1
//
//  Created by Nicolas Linard on 02/12/2020.
//

import Foundation



extension String {
    func matches(regex: String) -> [String] {
        var result = [String]()
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = self as NSString
            if let match = regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: nsString.length)) {
                for number in 1..<match.numberOfRanges {
                    result.append(nsString.substring(with: match.range(at: number)))
                }
            }
        } catch _ {
        }
        return result
    }
    
    
}

infix operator ^| : ComparisonPrecedence

extension Bool {
    static func ^| (lhs: Bool, rhs:Bool) -> Bool {
        
        return lhs && !rhs || !lhs && rhs
    }
}

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
