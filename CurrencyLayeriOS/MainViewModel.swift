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
    
    init(input: Driver<String>, service: CurrencyService) {
        self.service = service
        quotes = service.quotes()
        
        exchange = input
            .map { Double($0) }
            .map { service.exchange(input: $0 ?? 0.0) }
            .asObservable()
            .flatMap { $0 }
    }
}
