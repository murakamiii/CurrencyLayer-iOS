//
//  CurrencyService.swift
//  CurrencyLayeriOS
//
//  Created by murakami Taichi on 2019/09/04.
//  Copyright © 2019 murakammm. All rights reserved.
//

import Foundation
import RxSwift

struct Quote: Codable {
    var currency: String
    var rate: Double
    
    static func quotes(from dict: [String: Double]) -> [Quote] {
        return dict.map { Quote(currency: String($0.key.suffix(3)), rate: $0.value) }
    }
}

struct Exchange {
    let quote: Quote
    private let input: Double
    private let base: Double
    
    init(quote: Quote, input: Double, base: Double) {
        self.quote = quote
        self.input = input
        self.base = base
    }
    
    func output() -> Double {
        return quote.rate * input / base
    }
}

class CurrencyService {
    let listRepo: ListRepositoryProtocol
    let liveRepo: LiveRepositoryProtocol
    
    init(list: ListRepositoryProtocol, live: LiveRepositoryProtocol) {
        listRepo = list
        liveRepo = live
    }
    
    func quotes() -> Observable<[String]> {
        return listRepo.getList().map { Array($0.keys).sorted() }
    }
    
    func exchange(input: Double, base: Double) -> Observable<[Exchange]> {
        return liveRepo.getQuotes().map {
            $0.map { quote in
                Exchange(quote: quote, input: input, base: base)
            }
            .sorted(by: { (lhs, rhs) in lhs.quote.currency < rhs.quote.currency  })
        }
    }
    
    func baseRateFromUSD(base: String) -> Observable<Double> {
        return liveRepo.getQuotes().map {
            $0.first(where: { q in
                q.currency == base
            })?.rate ?? 1.0
        }
    }
}
