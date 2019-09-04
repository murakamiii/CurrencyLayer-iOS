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
    
    init(api: ListAPIProtocol) {
        self.api = api
    }
    
    func getList() -> Observable<[String: String]> {
        if let data = UserDefaults.standard.data(forKey: "currencies_list"),
            let resp = try? JSONDecoder().decode(ListResponse.self, from: data) {
            return Observable.of(resp.currencies)
        }
        
        return api.listResponse().map { resp -> [String : String] in
            let data =  try! JSONEncoder().encode(resp)
            UserDefaults.standard.set(data, forKey: "currencies_list")
            
            return resp.currencies
        }
    }
}
