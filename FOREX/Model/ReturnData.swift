//
//  ReturnData.swift
//  FOREX
//
//  Created by ebpearls on 5/30/24.
//

import Foundation

struct ReturnData {
    var countryCode: String
    var amount: Double
    var amountString: String {
        return String(format: "%.5f", amount)
    }
}
