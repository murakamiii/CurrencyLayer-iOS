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
    
    init(api: LiveAPIProtocol) {
        self.api = api
    }
    
    func getQuotes() -> Observable<[Quote]> {
        if let data = UserDefaults.standard.data(forKey: "live_list"),
            let resp = try? JSONDecoder().decode(LiveResponse.self, from: data),
            resp.timestamp! + 60 * 30 > Int(Date().timeIntervalSince1970) {
            return Observable.of(Quote.quotes(from: resp.quotes ?? [:]))
        }
        
        return api.liveResponse().map { resp in
            let data =  try! JSONEncoder().encode(resp)
            if resp.success == true {
                UserDefaults.standard.set(data, forKey: "live_list")
            }
            return Quote.quotes(from: resp.quotes ?? [:])
        }
    }
}
