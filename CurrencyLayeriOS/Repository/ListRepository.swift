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
        if let data = UserDefaults.standard.data(forKey: "currencies_list"),
            let resp = try? JSONDecoder().decode(ListResponse.self, from: data) {
            return Observable.of(resp.currencies ?? [:])
        }
        
        return api.listResponse().map { resp -> [String : String] in
            let data = try! JSONEncoder().encode(resp)
            if resp.success == true {
                UserDefaults.standard.set(data, forKey: "currencies_list")
            }
            return resp.currencies ?? [:]
        }
    }
}
