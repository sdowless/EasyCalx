//
//  PaymentView.swift
//  Easy Calx
//
//  Created by Stephan Dowless on 11/19/16.
//  Copyright © 2016 Stephan Dowless. All rights reserved.
//

import Foundation
import UIKit

class PaymentView: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var grossPay: UITextField!
    @IBOutlet weak var socialSecurity: UITextField!
    @IBOutlet weak var stateTax: UITextField!
    @IBOutlet weak var netPay: UITextField!
    @IBOutlet weak var fedTax: UITextField!
    @IBOutlet weak var medicare: UITextField!
    
    var grossPayTransfer: Double!
    var federalTaxTransfer: Double!
    var socialSecurityTransfer: Double!
    var medicareTransfer: Double!
    var netPayTransfer: Double!
    
    // Instance of paycheckCalc class
    var paycheck = paycheckCalc()
    
    // Load data in payment view based on values from previous view
    override func viewDidLoad() {
        super.viewDidLoad()
        grossPay.text = paycheck.addComma(inputValue: grossPayTransfer)
        fedTax.text = String(format: "-%.2f", (federalTaxTransfer))
        medicare.text = String(format: "-%.2f", (medicareTransfer))
        socialSecurity.text = String(format: "-%.2f", (socialSecurityTransfer))
        netPay.text = paycheck.addComma(inputValue: netPayTransfer)
    }
}

