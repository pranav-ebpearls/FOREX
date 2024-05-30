//
//  Converter.swift
//  FOREX
//
//  Created by ebpearls on 5/30/24.
//

import UIKit
protocol ConverterDelegate {
    func didUpdatePrice(_ converter: Converter, converted: ReturnData)
//    func didFailWithError(error: Error)
}

struct Converter {
    
    var delegate: ConverterDelegate?
    
    func completeURL(fromCurrency: String, toCurrency: String) {
  
        let baseUrl = "https://api.currencyapi.com/v3/latest"
        let apiKey = "apikey=cur_live_FTj6r8ltlk5fajchgyguzsABL9THuKSsgxtTU5vA"
        let currencyTo = "currencies=\(toCurrency)"
        let baseCurrency = "base_currency=\(fromCurrency)"
        
        let urlString = "\(baseUrl)?\(apiKey)&\(currencyTo)&\(baseCurrency)"
        performRequest(with: urlString, toCurrency: toCurrency)
    }
    
    func performRequest(with urlString: String, toCurrency: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let e = error {
                    print(e)
                }
                if let safeData = data {
                    
//                    FOR DYNAMIC KEYS
                    
//                    {
//                        "meta": {
//                            "last_updated_at": "2024-05-29T23:59:59Z"
//                        },
//                        "data": {
//                            "NPR": {
//                                "code": "NPR",
//                                "value": 1.4357915646
//                            }
//                        }
//                    }
                    
                    
                    let jsonObject = try? JSONSerialization.jsonObject(with: safeData, options: [])
                    
                    if let jsonDictionary = jsonObject as? [String: Any],
                       let dataDict = jsonDictionary["data"] as? [String: Any],
                       let innerDictionary = dataDict[toCurrency] as? [String: Any],
                       let code = innerDictionary["code"] as? String,
                       let value = innerDictionary["value"] as? Double
                    {
                        
                        // Accessing parsed data
                        
                        print("Code: \(code)")
                        print("Value: \(value)")
                        
                        let model = ReturnData(countryCode: code, amount: value)
                        self.delegate?.didUpdatePrice(self, converted: model)
                        
                    } else {
                        print("Invalid JSON format")
                    }
                }
            }
            task.resume()
        }
    }
    
    //    func parseJSON()
    
}



