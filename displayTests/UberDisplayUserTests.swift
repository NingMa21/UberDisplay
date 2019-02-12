//
//  UberDisplayUserTests.swift
//  displayTests
//
//  Created by Ben Hanrahan on Monday 2/11/19.
//  Copyright © 2019 Ning Ma. All rights reserved.
//

import XCTest
@testable import display

class UberDisplayUserTests: XCTestCase {

    var user = UberDisplayUser()
    
    override func setUp() {
        self.user.emailAddress = "hanrahan.ben@gmail.com"
        self.user.password = "1234pass!"
        
        self.runCreateUserInFirebase()
    }

    override func tearDown() {
        if self.user.fireBaseUser != nil {
            self.runDeleteUserinFirebase()
        }
    }
    
    func runCreateUserInFirebase() {
        let expectation = self.expectation(description: "Creating a user in firebase")
        var success = true
        
        self.user.createUserinFirebase( {(user) in
            expectation.fulfill()
        }, onError: {(error) in
            success = false
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: TimeInterval.init(120), handler: nil)
    }
    
    func runSignUserIntoFirebase() {
        let expectation = self.expectation(description: "Signing a user in firebase")
        var success = true
        
        self.user.signUserIntoFirebase( {(user) in
            expectation.fulfill()
        }, onError: {(error) in
            success = false
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: TimeInterval.init(120), handler: nil)
    }
    
    func runDeleteUserinFirebase() {
        let expectation = self.expectation(description: "Deleting a user in firebase")
        var success = true
        
        self.user.deleteUserinFirebase( {(user) in
            expectation.fulfill()
        }, onError: {(error) in
            success = false
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: TimeInterval.init(120), handler: nil)
    }

    func testCreateUserInFirebase() {
        XCTAssertNotNil(self.user.fireBaseUser)
    }
    
    func testSignUserIntoFirebase() {
        self.runSignUserIntoFirebase()
        XCTAssertNotNil(self.user.fireBaseUser)
    }
    
    func testDeleteUserInFirebase() {
        self.runSignUserIntoFirebase()
        self.runDeleteUserinFirebase()
        XCTAssertNil(self.user.fireBaseUser)
    }

}
