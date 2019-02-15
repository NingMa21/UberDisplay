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
        
        self.user.createUserinFirebase( {(user) in
            expectation.fulfill()
        }, onError: {(error) in
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: TimeInterval.init(120), handler: nil)
    }
    
    func runSignUserIntoFirebase() {
        let expectation = self.expectation(description: "Signing a user in firebase")
        
        self.user.signUserIntoFirebase( {(user) in
            expectation.fulfill()
        }, onError: {(error) in
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: TimeInterval.init(120), handler: nil)
    }
    
    func runDeleteUserinFirebase() {
        let expectation = self.expectation(description: "Deleting a user in firebase")
        
        self.user.deleteUserinFirebase( {(user) in
            expectation.fulfill()
        }, onError: {(error) in
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

    func testSaveUserPlist() {
        self.user.saveUsertoPlist()
        
        if let plist = Plist(name: "data") {
            let dict = plist.getMutablePlistFile()!
            let user_email = dict["user_email"] as? String
            let user_pass = dict["user_pass"] as? String
            
            XCTAssertEqual(user_email, "hanrahan.ben@gmail.com")
            XCTAssertEqual(user_pass, "1234pass!")
        } else {
            XCTAssertTrue(false)
        }
    }
    
    func testLoadUserPlist() {
        self.user.saveUsertoPlist()

        self.user.emailAddress = "1111hanrahan.ben@gmail.com"
        
        let loaded = self.user.loadUserfromPlist()
        XCTAssertTrue(loaded)
        XCTAssertEqual(self.user.emailAddress, "hanrahan.ben@gmail.com")
    }
    
    func testUserDataFirebase() {
        self.user.drivingArea = "State College"
        self.user.displayName = "BenJAMIN"
        self.user.phoneNumber = "555-555-1234"
        
        // CREATE
        var success = false
        let expectation = self.expectation(description: "Creating user data in firestore")
        
        self.user.saveUserDatatoFirebase( {(user) in
            success = true
            expectation.fulfill()
        }, onError: {(error) in
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: TimeInterval.init(120), handler: nil)
        XCTAssertTrue(success)
        
        // SAVE SLIDES
        let slideOne = Slide()
        slideOne.position = 1
        slideOne.title = "Test Slide One"
        slideOne.description = "Test Slide One"
        self.user.slides.append(slideOne)
        let slideTwo = Slide()
        slideTwo.position = 2
        slideTwo.title = "Test Slide Two"
        slideTwo.description = "Test Slide Two"
        self.user.slides.append(slideTwo)
        
        let expectationSaveSlide = self.expectation(description: "Saving slides")
        success = false

        self.user.saveSlidesFirebase( {(user) in
            success = true
            expectationSaveSlide.fulfill()
        }, onError: {(error) in
            expectationSaveSlide.fulfill()
        })
        
        waitForExpectations(timeout: TimeInterval.init(120), handler: nil)
        XCTAssertTrue(success)
        
        // READ
        self.user.drivingArea = "MARS!!!"
        
        let expectationTwo = self.expectation(description: "getting user data in firestore")
        success = false
        
        self.user.loadUserDatafromFirebase( {(user) in
            success = true
            expectationTwo.fulfill()
        }, onError: {(error) in
            expectationTwo.fulfill()
        })
        
        waitForExpectations(timeout: TimeInterval.init(120), handler: nil)
        XCTAssertTrue(success)
        XCTAssertEqual(self.user.drivingArea, "State College")
        
        // LOAD SLIDES
        self.user.slides = [Slide]()
        let expectationLoadSlides = self.expectation(description: "loading slides from firestore")
        success = false
        
        self.user.loadSlidesfromFirebase( {(user) in
            success = true
            expectationLoadSlides.fulfill()
        }, onError: {(error) in
            expectationLoadSlides.fulfill()
        })
        
        waitForExpectations(timeout: TimeInterval.init(120), handler: nil)
        XCTAssertTrue(success)
        XCTAssertTrue(self.user.slides.count > 0)

        
        // DELETE
        let expectationThree = self.expectation(description: "deleting user data in firestore")
        success = false
        
        self.user.deleteUserDatafromFirebase( {(user) in
            success = true
            expectationThree.fulfill()
        }, onError: {(error) in
            expectationThree.fulfill()
        })
        waitForExpectations(timeout: TimeInterval.init(120), handler: nil)
        XCTAssertTrue(success)
    }
}
