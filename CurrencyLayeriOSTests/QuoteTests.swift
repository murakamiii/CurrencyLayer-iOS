//
//  QuoteTests.swift
//  CurrencyLayeriOSTests
//
//  Created by murakami Taichi on 2019/09/05.
//  Copyright © 2019 murakammm. All rights reserved.
//

import XCTest
@testable import CurrencyLayeriOS

class QuoteTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_quotes() {
        let dict = ["JPNUSD": 105.11, "JPNEUR": 135.000_1]
        let quotes = Quote.quotes(from: dict).sorted { $0.currency < $1.currency }
        XCTAssertEqual(quotes, [
            Quote(currency: "EUR", rate: 135.000_1),
            Quote(currency: "USD", rate: 105.11)])
    }
}
