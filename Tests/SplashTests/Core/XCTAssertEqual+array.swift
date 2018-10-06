/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

import XCTest

/**
 This version of function XCTAssertEqual will compare each of element separately, so you will get a better error message.
 
 It assumes that you provide the first list as one line variable and second as an array literal with each element on a new line:
 
 ```
 let testOutput = [true, false, false]
 XCTAssertEqual(testOutput, [
 true,
 true,
 false
 ])
 ```
 
 - parameters:
     - expression1: An expression of type [T], where T is Equatable.
     - expression2: An expression of type [T], where T is Equatable.
     - message: An optional description of the failure.
     - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
     - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
 */

func XCTAssertEqual<T>(_ expression1: @autoclosure () throws -> [T], _ expression2: @autoclosure () throws -> [T], _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) where T : Equatable {
    
    let list1 = try! expression1()
    let list2 = try! expression2()
    
    let list1Count = list1.count
    let list2Count = list2.count
    
    func updateLine(_ i:Int) -> UInt {
        if i >= list2Count {
           return line
        }
        return line + UInt(i+1)
    }
    
    let count = max(list1Count, list2Count)
    for i in 0..<count {
        let value1 = list1[safe:i]
        let value2 = list2[safe:i]
        if value1 != nil && value2 != nil {
            XCTAssertEqual(value1!, value2!, file: file, line: updateLine(i))
        } else {
            XCTAssertEqual(value1, value2, file: file, line: updateLine(i))
        }
    }
}

extension Collection {
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


