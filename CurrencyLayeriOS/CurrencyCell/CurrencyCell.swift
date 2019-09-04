//
//  CurrencyCell.swift
//  CurrencyLayeriOS
//
//  Created by murakami Taichi on 2019/09/04.
//  Copyright © 2019 murakammm. All rights reserved.
//

import Foundation
import UIKit

class CurrencyCell: UICollectionViewCell {
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    static let cellLength: CGFloat = 80.0

    func set(exchange: Exchange) {
        quoteLabel.text = exchange.quote.currency
        valueLabel.text = String(round(exchange.output() * 100) / 100)
    }
}
