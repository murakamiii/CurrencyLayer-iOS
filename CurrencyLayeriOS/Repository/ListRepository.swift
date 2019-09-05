//
//  ListRepository.swift
//  CurrencyLayeriOS
//
//  Created by murakami Taichi on 2019/09/04.
//  Copyright © 2019 murakammm. All rights reserved.
//

import Foundation
import RxSwift

protocol ListRepositoryProtocol {
    func getList() -> Observable<[String: String]>
}

class ListRepository: ListRepositoryProtocol {
    private let api: ListAPIProtocol
    private let cache: LocalCache

    init(api: ListAPIProtocol, cache: LocalCache) {
        self.api = api
        self.cache = cache
    }
    
    func getList() -> Observable<[String: String]> {
        if let resp = cache.getCurrencyResponse() {
            return Observable.of(resp.currencies ?? [:])
        }
        
        return api.listResponse().map { resp -> [String: String] in
            if resp.success == true {
                self.cache.save(currency: resp)
            }
            return resp.currencies ?? [:]
        }
    }
}
