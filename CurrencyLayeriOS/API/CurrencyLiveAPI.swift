//
//  CurrencyLiveAPI.swift
//  CurrencyLayeriOS
//
//  Created by murakami Taichi on 2019/09/04.
//  Copyright © 2019 murakammm. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct LiveResponse: Codable {
    var success: Bool
    
    // success: true
    var terms: URL?
    var privacy: URL?
    var timestamp: Int?
    var source: String?
    var quotes: [String: Double]?
    
    // success: false
    var error: CLError?
}

protocol LiveAPIProtocol {
    func liveResponse() -> Observable<LiveResponse>
}

class CurrencyLiveAPI: LiveAPIProtocol {
    func liveResponse() -> Observable<LiveResponse> {
        let session = URLSession.shared
        guard let key = ProcessInfo.processInfo.environment["access_key"] else {
            return Observable.error(APIError.application)
        }
        let url = URL(string: "http://www.apilayer.net/api/live?access_key=\(key)")!
        let req = URLRequest(url: url)
        
        return session.rx.response(request: req).map { resp, data in
            if resp.statusCode != 200 {
                throw APIError.server(info: nil)
            }
            
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(LiveResponse.self, from: data) {
                if let errInfo = decoded.error {
                    throw APIError.server(info: errInfo)
                }
                return decoded
            } else {
                throw APIError.application
            }
        }
    }
}

class MockLiveAPI: LiveAPIProtocol {
    func liveResponse() -> Observable<LiveResponse> {
        let data = """
        {
        "success":true,
        "terms":"https://currencylayer.com/terms",
        "privacy":"https://currencylayer.com/privacy",
        "timestamp":1567526886,
        "source":"USD",
        "quotes":{
        "USDAED":3.673099,
        "USDAFN":78.25025,
        "USDALL":111.190253,
        "USDAMD":476.329688,
        "USDANG":1.78505,
        "USDAOA":362.002504,
        "USDARS":55.746995,
        "USDAUD":1.47985,
        "USDAWG":1.8,
        "USDAZN":1.704983,
        "USDBAM":1.788051,
        "USDBBD":2.0191,
        "USDBDT":84.496027,
        "USDBGN":1.783598,
        "USDBHD":0.37702,
        "USDBIF":1860,
        "USDBMD":1,
        "USDBND":1.35045,
        "USDBOB":6.91025,
        "USDBRL":4.1674,
        "USDBSD":0.99995,
        "USDBTC":9.3744944e-5,
        "USDBTN":72.3305,
        "USDBWP":11.067964,
        "USDBYN":2.123905,
        "USDBYR":19600,
        "USDBZD":2.015699,
        "USDCAD":1.333115,
        "USDCDF":1664.999907,
        "USDCHF":0.98725,
        "USDCLF":0.026289,
        "USDCLP":725.297348,
        "USDCNY":7.178974,
        "USDCOP":3439,
        "USDCRC":569.449664,
        "USDCUC":1,
        "USDCUP":26.5,
        "USDCVE":100.720235,
        "USDCZK":23.551903,
        "USDDJF":177.720602,
        "USDDKK":6.79945,
        "USDDOP":51.394958,
        "USDDZD":120.530193,
        "USDEGP":16.54402,
        "USDERN":15.000142,
        "USDETB":29.525002,
        "USDEUR":0.91182,
        "USDFJD":2.19455,
        "USDFKP":0.831023,
        "USDGBP":0.82743,
        "USDGEL":2.940118,
        "USDGGP":0.827468,
        "USDGHS":5.47988,
        "USDGIP":0.830975,
        "USDGMD":50.425008,
        "USDGNF":9230.0001,
        "USDGTQ":7.68515,
        "USDGYD":209.214947,
        "USDHKD":7.84258,
        "USDHNL":24.523961,
        "USDHRK":6.754499,
        "USDHTG":95.355503,
        "USDHUF":301.027007,
        "USDIDR":14181.25,
        "USDILS":3.539299,
        "USDIMP":0.827468,
        "USDINR":72.216701,
        "USDIQD":1190,
        "USDIRR":42105.000063,
        "USDISK":127.020287,
        "USDJEP":0.827468,
        "USDJMD":135.830261,
        "USDJOD":0.709012,
        "USDJPY":105.892501,
        "USDKES":103.896797,
        "USDKGS":69.845102,
        "USDKHR":4094.999952,
        "USDKMF":449.049954,
        "USDKPW":900.06577,
        "USDKRW":1212.595001,
        "USDKWD":0.304397,
        "USDKYD":0.833405,
        "USDKZT":388.640025,
        "USDLAK":8785.000246,
        "USDLBP":1508.05025,
        "USDLKR":180.390067,
        "USDLRD":207.725014,
        "USDLSL":15.139973,
        "USDLTL":2.95274,
        "USDLVL":0.60489,
        "USDLYD":1.419785,
        "USDMAD":9.6824,
        "USDMDL":17.775495,
        "USDMGA":3705.000143,
        "USDMKD":56.058499,
        "USDMMK":1527.501224,
        "USDMNT":2668.573828,
        "USDMOP":8.07885,
        "USDMRO":357.000024,
        "USDMUR":36.244506,
        "USDMVR":15.401804,
        "USDMWK":724.935042,
        "USDMXN":19.98133,
        "USDMYR":4.209202,
        "USDMZN":61.435001,
        "USDNAD":15.139973,
        "USDNGN":362.500507,
        "USDNIO":33.670277,
        "USDNOK":9.10489,
        "USDNPR":115.734999,
        "USDNZD":1.581075,
        "USDOMR":0.385026,
        "USDPAB":1.00005,
        "USDPEN":3.405903,
        "USDPGK":3.38785,
        "USDPHP":52.225498,
        "USDPKR":156.749936,
        "USDPLN":3.964421,
        "USDPYG":6257.349933,
        "USDQAR":3.640983,
        "USDRON":4.310201,
        "USDRSD":107.230147,
        "USDRUB":67.087502,
        "USDRWF":920,
        "USDSAR":3.75105,
        "USDSBD":8.142798,
        "USDSCR":13.670099,
        "USDSDG":45.113502,
        "USDSEK":9.83575,
        "USDSGD":1.39074,
        "USDSHP":1.320901,
        "USDSLL":9299.999768,
        "USDSOS":580.000032,
        "USDSRD":7.457973,
        "USDSTD":21560.79,
        "USDSVC":8.75115,
        "USDSYP":515.000332,
        "USDSZL":15.139753,
        "USDTHB":30.61034,
        "USDTJS":9.690103,
        "USDTMT":3.5,
        "USDTND":2.858498,
        "USDTOP":2.328402,
        "USDTRY":5.7234,
        "USDTTD":6.77975,
        "USDTWD":31.391497,
        "USDTZS":2298.820298,
        "USDUAH":25.26897,
        "USDUGX":3682.150046,
        "USDUSD":1,
        "USDUYU":36.620307,
        "USDUZS":9374.198387,
        "USDVEF":9.987497,
        "USDVND":23208.5,
        "USDVUV":118.412975,
        "USDWST":2.686761,
        "USDXAF":599.69004,
        "USDXAG":0.052249,
        "USDXAU":0.000646,
        "USDXCD":2.70265,
        "USDXDR":0.732932,
        "USDXOF":590.999945,
        "USDXPF":109.124993,
        "USDYER":250.298235,
        "USDZAR":15.12935,
        "USDZMK":9001.226387,
        "USDZMW":13.110963,
        "USDZWL":322.000001
        }
        }
        """.data(using: .utf8)!
        print("live呼ばれ")
        let decoder = JSONDecoder()
        let decoded = try! decoder.decode(LiveResponse.self, from: data)
        return Observable.of(decoded)
    }
}
