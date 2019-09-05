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
    private let service: CurrencyService
    let quotes: Observable<[String]>
    let exchange: Observable<[Exchange]>
    
    init(input: (amount: Driver<String>, currency: Driver<String>), service: CurrencyService) {
        self.service = service
        quotes = service.quotes()
        
        let baseRate = input.currency
            .map { service.baseRateFromUSD(base: $0)}
            .asObservable()
            .flatMap { $0 }
            .asDriver(onErrorJustReturn: 0.0)
        
        exchange = Driver
            .combineLatest(input.amount, baseRate) { (amount, base) in
                service.exchange(input: Double(amount) ?? 0.0, base: base)
            }
            .asObservable()
            .flatMap { $0 }
    }
}
