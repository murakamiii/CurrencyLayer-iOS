//
//  CurrencyLayeriOSTests.swift
//  CurrencyLayeriOSTests
//
//  Created by murakami Taichi on 2019/09/04.
//  Copyright © 2019 murakammm. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxRelay
import RxBlocking
import RxTest

@testable import CurrencyLayeriOS

class MainViewModelTests: XCTestCase {

    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        amountDriver = scheduler.createColdObservable([
            .next(10, "0"),
            .next(15, "10.0"),
            .next(25, "20.1")
            ]).asDriver(onErrorJustReturn: "-0.1")
        
        currencyDriver = scheduler.createColdObservable([
            .next(10, "USD"),
            .next(20, "JPY"),
            .next(30, "USD")
            ]).asDriver(onErrorJustReturn: "")
    }

    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    let disposeBag = DisposeBag()
    
    let mockService = MockCurrencyService(
        quotesMock: ["USD", "JPY", "EUR"],
        exchangeMock: { input, base in
            let rates = ["USD": 1.0, "JPY": 108.5, "EUR": 0.9]
            return Quote.quotes(from: rates).sorted(by: { l, r in l.currency < r.currency }).map { Exchange(quote: $0, input: input, base: base) }
        }, baseRateFromUSDMock: { str in
            let rates = ["USD": 1.0, "JPY": 108.5, "EUR": 0.9]
            return rates[str] ?? 0.0
        }
    )
    
    var scheduler: TestScheduler!
    var amountDriver: Driver<String>!
    var currencyDriver: Driver<String>!
    func test_quotes() {
        let vm = MainViewModel(input: (amount: amountDriver, currency: currencyDriver),
                               service: mockService)

        let quotes = scheduler.createObserver([String].self)
        vm.quotes
            .subscribe(quotes)
            .disposed(by: disposeBag)
        
        scheduler.start()
        XCTAssertEqual(quotes.events.first, Recorded.next(0, ["USD", "JPY", "EUR"]))
    }
    
    func test_exchanges() {
        let vm = MainViewModel(input: (amount: amountDriver, currency: currencyDriver),
                               service: mockService)
        let exchanges = scheduler.createObserver([Exchange].self)
        vm.exchange
            .subscribe(exchanges)
            .disposed(by: disposeBag)
        scheduler.start()
        
        let expected10 = [
            Exchange(quote: Quote(currency: "EUR", rate: 0.9), input: 0.0, base: 1.0),
            Exchange(quote: Quote(currency: "JPY", rate: 108.5), input: 0.0, base: 1.0),
            Exchange(quote: Quote(currency: "USD", rate: 1.0), input: 0.0, base: 1.0)
        ]
        
        let expected15 = [
            Exchange(quote: Quote(currency: "EUR", rate: 0.9), input: 10.0, base: 1.0),
            Exchange(quote: Quote(currency: "JPY", rate: 108.5), input: 10.0, base: 1.0),
            Exchange(quote: Quote(currency: "USD", rate: 1.0), input: 10.0, base: 1.0)
        ]
        
        let expected20 = [
            Exchange(quote: Quote(currency: "EUR", rate: 0.9), input: 10.0, base: 108.5),
            Exchange(quote: Quote(currency: "JPY", rate: 108.5), input: 10.0, base: 108.5),
            Exchange(quote: Quote(currency: "USD", rate: 1.0), input: 10.0, base: 108.5)
        ]
        
        let expected25 = [
            Exchange(quote: Quote(currency: "EUR", rate: 0.9), input: 20.1, base: 108.5),
            Exchange(quote: Quote(currency: "JPY", rate: 108.5), input: 20.1, base: 108.5),
            Exchange(quote: Quote(currency: "USD", rate: 1.0), input: 20.1, base: 108.5)
        ]
        
        let expected30 = [
            Exchange(quote: Quote(currency: "EUR", rate: 0.9), input: 20.1, base: 1.0),
            Exchange(quote: Quote(currency: "JPY", rate: 108.5), input: 20.1, base: 1.0),
            Exchange(quote: Quote(currency: "USD", rate: 1.0), input: 20.1, base: 1.0)
        ]
        
        XCTAssertEqual(exchanges.events, [
            .next(10, expected10),
            .next(15, expected15),
            .next(20, expected20),
            .next(25, expected25),
            .next(30, expected30)
        ])
    }
    
}
