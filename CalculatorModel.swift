//
//  CalculatorModel.swift
//  Easy Calx
//
//  Created by Stephan Dowless on 11/18/16.
//  Copyright © 2016 Stephan Dowless. All rights reserved.
//

import Foundation

class DiscountCalculation {
    var price : Double
    var discount: Double
    var tax: Double
    var additionalDiscount: Double
    var total: Double {
        get {
            return price + (price * (tax / 100))
        }
    }
    
    init(price: Double, discount: Double, tax: Double, additionalDiscount: Double) {
        self.price = price
        self.discount = discount
        self.tax = tax
        self.additionalDiscount = additionalDiscount
    }
}
