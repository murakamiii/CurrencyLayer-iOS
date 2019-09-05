//
//  LIveRepository.swift
//  CurrencyLayeriOS
//
//  Created by murakami Taichi on 2019/09/04.
//  Copyright © 2019 murakammm. All rights reserved.
//

import Foundation
import RxSwift

protocol LiveRepositoryProtocol {
    func getQuotes() -> Observable<[Quote]>
}

class LiveRepository: LiveRepositoryProtocol {
    private let api: LiveAPIProtocol
    private let cache: LocalCache
    init(api: LiveAPIProtocol, cache: LocalCache) {
        self.api = api
        self.cache = cache
    }
    
    func getQuotes() -> Observable<[Quote]> {
        if let resp = cache.getLiveResponse(),
            resp.timestamp! + 60 * 30 > Int(Date().timeIntervalSince1970) {
            return Observable.of(Quote.quotes(from: resp.quotes ?? [:]))
        }
        
        return api.liveResponse().map { resp in
            if resp.success == true {
                self.cache.save(live: resp)
            }
            return Quote.quotes(from: resp.quotes ?? [:])
        }
    }
}
