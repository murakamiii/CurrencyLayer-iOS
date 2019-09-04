//
//  APIError.swift
//  CurrencyLayeriOS
//
//  Created by murakami Taichi on 2019/09/04.
//  Copyright © 2019 murakammm. All rights reserved.
//

import Foundation

enum APIError: Error, Equatable {
    case server(info: CLError?)
    case network
    case application
    case rateLimit
}

struct CLError: Codable, Equatable {
    var code: Int
    var info: String
}
