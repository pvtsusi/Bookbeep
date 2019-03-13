//
//  BookbeepTests.swift
//  BookbeepTests
//
//  Created by Petteri Susi on 12/03/2019.
//  Copyright © 2019 Petteri Susi. All rights reserved.
//

import XCTest
@testable import Bookbeep

class BookbeepTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //MARK: Book Class tests
    func testValidBookInit() {
        XCTAssertNotNil(Book.init(isbn: "9789510437193"))
        XCTAssertNotNil(Book.init(isbn: "9789510437193", title: "Title", author: "Author"))
    }
    
    func testInvalidBookInit() {
        XCTAssertNil(Book.init(isbn: ""))
        XCTAssertNil(Book.init(isbn: "not an ISBN"))
    }

    
}
