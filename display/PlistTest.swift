//
//  PlistTest.swift
//  Transport Share
//
//  Created by Ben Hanrahan on Thursday 8/25/16.
//  Copyright © 2016 PSU CHCI. All rights reserved.
//

import XCTest
@testable import display

class PlistTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        if let plist = Plist(name: "data") {
            let dict = plist.getMutablePlistFile()!
            dict["testArray"] = []
            
            do {
                try plist.addValuesToPlistFile(dict)
            }
            catch {
                print("couldn't save the plist")
            }
        }
    }
    
    override func tearDown() {
        super.tearDown()
        if let plist = Plist(name: "data") {
            let dict = plist.getMutablePlistFile()!
            dict["testArray"] = []
            
            do {
                try plist.addValuesToPlistFile(dict)
            }
            catch {
                print("couldn't save the plist")
            }
        }
    }
    
    func testSaveSimple() {
        if let plist = Plist(name: "data") {
            let dict = plist.getMutablePlistFile()!
            let testArray = dict["testArray"] as! NSArray
            
            dict["testArray"] = testArray.adding("test")
            do {
                try plist.addValuesToPlistFile(dict)
            }
            catch {
                print("couldn't save the plist")
                XCTAssertTrue(false)
            }
        } else {
            print("Unable to get Plist")
            XCTAssertTrue(false)
        }
    }
    
    func testSaveDict() {
        if let plist = Plist(name: "data") {
            let dict = plist.getMutablePlistFile()!
            let testArray = dict["testArray"] as! NSArray
            
            var testDict: Dictionary<String, String> = [:]
            testDict["one"] = "1"
            dict["testArray"] = testArray.adding(testDict)
            do {
                try plist.addValuesToPlistFile(dict)
            }
            catch {
                print("couldn't save the plist")
                XCTAssertTrue(false)
            }
        } else {
            print("Unable to get Plist")
            XCTAssertTrue(false)
        }
        
        if let plist = Plist(name: "data") {
            let dict = plist.getMutablePlistFile()!
            let testArray = dict["testArray"] as! NSArray
            
            print(testArray)
        } else {
            print("Unable to get Plist")
            XCTAssertTrue(false)
        }
    }
    
}
