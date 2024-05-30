//
//  ViewController.swift
//  FOREX
//
//  Created by ebpearls on 5/28/24.
//

import UIKit
import DropDown

class ViewController: UIViewController {
    
    @IBOutlet weak var myDropDownView: UIView!
    @IBOutlet weak var fromCurrency: UIButton!
    @IBOutlet weak var toCurrency: UIButton!
    @IBOutlet weak var fromCurrencyField: UITextField!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var fromCurrencyLabel: UILabel!
    @IBOutlet weak var toCurrencyLabel: UILabel!
    
    //
//    lazy var submitButton: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle("Hello this is new button", for: .normal)
//        button.backgroundColor = .red
//        return button
//    }()
    
    let myDropDown1 = DropDown()
    let myDropDown2 = DropDown()
    
    var fromCurrencyValue = ""
    var toCurrencyValue = ""
    
    var converter = Converter()

    let currencyArray = [
        "ALL", "AFN", "ARS", "AWG", "AUD", "AZN", "BSD", "BBD", "BDT", "BYR", "BZD", "BMD", "BOB", "BAM", "BWP", "BGN", "BRL", "BND", "KHR", "CAD", "KYD", "CLP", "CNY", "COP", "CRC", "HRK", "CUP", "CZK", "DKK", "DOP", "XCD", "EGP", "SVC", "EEK", "EUR", "FKP", "FJD", "GHC", "GIP", "GTQ", "GGP", "GYD", "HNL", "HKD", "HUF", "ISK", "INR", "IDR", "IRR", "IMP", "ILS", "JMD", "JPY", "JEP", "KZT", "KPW", "KRW", "KGS", "LAK", "LVL", "LBP", "LRD", "LTL", "MKD", "MYR", "MUR", "MXN", "MNT", "MZN", "NAD", "NPR", "ANG", "NZD", "NIO", "NGN", "NOK", "OMR", "PKR", "PAB", "PYG", "PEN", "PHP", "PLN", "QAR", "RON", "RUB", "SHP", "SAR", "RSD", "SCR", "SGD", "SBD", "SOS", "ZAR", "LKR", "SEK", "CHF", "SRD", "SYP", "TWD", "THB", "TTD", "TRY", "TRL", "TVD", "UAH", "GBP", "USD", "UYU", "UZS", "VEF", "VND", "YER", "ZWD"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.addSubview(submitButton)
//        
//        submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100).isActive = true
//        submitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        
        converter.delegate = self
        
        myDropDown1.anchorView = fromCurrency
        myDropDown1.dataSource = currencyArray
        myDropDown1.bottomOffset = CGPoint(x: 0, y: (myDropDown1.anchorView?.plainView.bounds.height)!)
        myDropDown1.topOffset = CGPoint(x: 0, y: -(myDropDown1.anchorView?.plainView.bounds.height)!)
        myDropDown1.direction = .bottom
        myDropDown1.selectionAction = { (index: Int, item: String) in
            self.fromCurrency.setTitle(self.currencyArray[index], for: .normal)
            DispatchQueue.main.async{
                self.fromCurrencyValue = self.fromCurrency.titleLabel?.text ?? "USD"
//                self.fromCurrencyLabel.text = self.fromCurrencyValue
                print(self.fromCurrencyValue)
            }
        }
        
        myDropDown2.anchorView = toCurrency
        myDropDown2.dataSource = currencyArray
        myDropDown2.bottomOffset = CGPoint(x: 0, y: (myDropDown2.anchorView?.plainView.bounds.height)!)
        myDropDown2.topOffset = CGPoint(x: 0, y: -(myDropDown2.anchorView?.plainView.bounds.height)!)
        myDropDown2.direction = .bottom
        myDropDown2.selectionAction = { (index: Int, item: String) in
            self.toCurrency.setTitle(self.currencyArray[index], for: .normal)
            DispatchQueue.main.async {
                self.toCurrencyValue = self.toCurrency.titleLabel?.text ?? "NPR"
                print(self.toCurrencyValue)
            }
        }
    }

    @IBAction func convertButtonPressed(_ sender: UIButton) {
        view.endEditing(true)
        selectedCurrency()
        
    }

    @IBAction func fromCurrencyIsPressed(_ sender: UIButton) {
        myDropDown1.show()
    }
    
    
    @IBAction func toCurrencyIsTapped(_ sender: UIButton) {
        myDropDown2.show()
    }
    
    func selectedCurrency() {
        converter.completeURL(fromCurrency: fromCurrencyValue, toCurrency: toCurrencyValue)
    }

    
}

extension ViewController: ConverterDelegate {
    func didUpdatePrice(_ converter: Converter, converted: ReturnData) {
        DispatchQueue.main.async {
            self.currencyLabel.text = converted.countryCode
            self.amountLabel.text = converted.amountString
            self.fromCurrencyLabel.text = self.fromCurrencyValue
            
            
            let fromDouble = Double( self.fromCurrencyField.text ?? "0") ?? .zero
            
            let convertedAmt = converted.amount * fromDouble
            
            self.toCurrencyLabel.text = String(format: "%.4f", convertedAmt)
            
        }
    }  
}



