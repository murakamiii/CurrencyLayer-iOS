//
//  LocalCache.swift
//  CurrencyLayeriOS
//
//  Created by murakami Taichi on 2019/09/05.
//  Copyright © 2019 murakammm. All rights reserved.
//

import Foundation

struct LocalCache {
    enum udKey: String {
        case live = "live_list"
        case currencies = "currencies_list"
    }
    
    let ud: UserDefaults
    init(_ ud: UserDefaults) {
        self.ud = ud
    }
    
    func save(live: LiveResponse) {
        let data =  try! JSONEncoder().encode(live)
        UserDefaults.standard.set(data, forKey: udKey.live.rawValue)
    }
    
    func getLiveResponse() -> LiveResponse? {
        if let data = UserDefaults.standard.data(forKey: udKey.live.rawValue),
            let resp = try? JSONDecoder().decode(LiveResponse.self, from: data) {
            return resp
        }
        return nil
    }
    
    func save(currency: ListResponse) {
        let data =  try! JSONEncoder().encode(currency)
        UserDefaults.standard.set(data, forKey: udKey.currencies.rawValue)
    }
    
    func getCurrencyResponse() -> ListResponse? {
        if let data = UserDefaults.standard.data(forKey: udKey.currencies.rawValue),
            let resp = try? JSONDecoder().decode(ListResponse.self, from: data) {
            return resp
        }
        return nil
    }
    
    static func standard() -> LocalCache {
        return LocalCache(UserDefaults.standard)
    }
}
