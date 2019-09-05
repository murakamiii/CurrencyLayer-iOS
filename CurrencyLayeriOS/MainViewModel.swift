//
//  MainViewModel.swift
//  CurrencyLayeriOS
//
//  Created by murakami Taichi on 2019/09/04.
//  Copyright © 2019 murakammm. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel {
    private let service: CurrencyServiceProtocol
    let quotes: Observable<[String]>
    let exchange: Observable<[Exchange]>
    let error: Observable<APIError>

    init(input: (amount: Driver<String>, currency: Driver<String>), service: CurrencyServiceProtocol) {
        self.service = service
        quotes = service.quotes()
        
        let baseRate = input.currency
            .map { service.baseRateFromUSD(base: $0)}
            .asObservable()
            .flatMap { $0 }
            .asDriver(onErrorJustReturn: 0.0)
        
        let res = Driver
            .combineLatest(input.amount, baseRate) { (amount, base) in
                service.exchange(input: Double(amount) ?? 0.0, base: base)
            }
            .asObservable()
            .flatMap { $0 }
            .materialize().share(replay: 1)
        exchange = res.filter { event in
            event.element != nil
        }
        .map { $0.element! }
        
        error = res.filter { event in
            event.error != nil
        }
        .map { $0.error as? APIError ?? APIError.application }
    }
}
