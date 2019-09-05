//
//  ExchangeTests.swift
//  CurrencyLayeriOSTests
//
//  Created by murakami Taichi on 2019/09/05.
//  Copyright © 2019 murakammm. All rights reserved.
//

import XCTest
@testable import CurrencyLayeriOS

class ExchangeTests: XCTestCase {
    let quotes = [
        Quote(currency: "USD", rate: 105.11),
        Quote(currency: "EUR", rate: 135.000_1)
    ]
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_exchange() {
        let case1 = Exchange(quote: quotes[0], input: 1.0, base: 2.0)
        XCTAssertEqual(case1.output(), 52.555)
        
        let case2 = Exchange(quote: quotes[0], input: 0.1, base: 0.2)
        XCTAssertEqual(case2.output(), 52.555)
    }
}
