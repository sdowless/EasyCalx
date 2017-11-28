//
//  CalcModel.swift
//  Easy Calx
//
//  Created by Stephan Dowless on 11/18/16.
//  Copyright © 2016 Stephan Dowless. All rights reserved.
//

import Foundation
/Users/Stephan/Desktop/Easy Calx/CalcModel.swift
// Global variables for shopping list in discoutn calx

var items = [String]()
var prices = [Double]()
var discountedPrices = [Double]()


class Cart {
    
    func addComma(inputValue: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: inputValue))!
    }
    
    func sumTotal() -> Double {
        var sum = 0.0
        let count = discountedPrices.count
        
        if count >= 1 {
            for i in 0..<count {
                sum += discountedPrices[i]
            }
        }
        return sum
    }
    
    func sumMoneySaved() -> Double {
        var sum = 0.0
        let count = prices.count
        
        if count >= 1 {
            for i in 0..<count {
                sum += prices[i]
            }
        }
        return (sum - sumTotal())
    }
}

class DiscountCalculation {
    var price: Double = 0
    var discount: Double = 0
    var tax: Double = 0
    var additionalDiscount: Double = 0
    var finalPriceFormatted: String = ""
    var moneySavedFormatted: String = ""
    var total: Double {
        get {
            return price + (price * (tax / 100))
        }
    }
    
    func addComma(inputValue: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: inputValue))!
    }
    
    func toNumberFromCurrency(inputValue: String) -> Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.number(from: inputValue)! as Double
    }
    
    func toNumber(inputValue: String) -> Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.number(from: inputValue)! as Double
    }
    
    func toDecimal(inputValue: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: inputValue))!
    }
    
    func toDecimalTax(inputValue: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 3
        formatter.maximumFractionDigits = 3
        return formatter.string(from: NSNumber(value: inputValue))!
    }
    
    func calcDiscount(segmentA: Bool, segmentB: Bool) -> String {
        
        if segmentA == false && segmentB == false {
            
            let discountedPrice = price - discount - additionalDiscount
            let finalPrice = discountedPrice + (discountedPrice * (tax / 100 ))
            let finalPriceFormatted = addComma(inputValue: finalPrice)
            
            return finalPriceFormatted
            
        } else if segmentA == true && segmentB == true {
            discount /= 100
            additionalDiscount /= 100
            
            let firstDiscountedPrice = price - (price * discount)
            let finalDiscountedPrice = (firstDiscountedPrice - (firstDiscountedPrice * additionalDiscount))
            let finalPrice = finalDiscountedPrice + (finalDiscountedPrice * (tax / 100))
            let finalPriceFormatted = addComma(inputValue: finalPrice)

            return finalPriceFormatted
        } else if segmentA == false && segmentB == true {
            additionalDiscount /= 100
            
            let totalAfterFirstDiscount = price - discount
            let totalBeforeTax = totalAfterFirstDiscount - (totalAfterFirstDiscount * additionalDiscount)
            let totalAfterTax = totalBeforeTax + (totalBeforeTax * tax / 100)
            let finalPriceFormatted = addComma(inputValue: totalAfterTax)
            
            return finalPriceFormatted
        } else {
            
            discount /= 100
            let firstDiscount = discount * price
            let totalAfterFirstDiscount = price - firstDiscount
            let totalAfterSecondDiscount = totalAfterFirstDiscount - additionalDiscount
            let totalAfterTax = totalAfterSecondDiscount + totalAfterSecondDiscount * tax / 100
            let finalPriceFormatted = addComma(inputValue: totalAfterTax)
            
            return finalPriceFormatted

        }
    }
    
    func calcMoneySaved(segmentA: Bool, segmentB: Bool) -> String {
        
        if segmentA == false && segmentB == false {
            
            let moneySavedBeforeTax = (discount + additionalDiscount)
            let moneySaved = moneySavedBeforeTax + (moneySavedBeforeTax * (tax / 100))
            let moneySavedFormatted = addComma(inputValue: moneySaved)
            
            return moneySavedFormatted
        } else if segmentA == true && segmentB == true {
            
            let firstDiscount = price * discount
            let totalAfterFirstDiscount = price - firstDiscount
            let moneySavedBeforeTax = firstDiscount + (totalAfterFirstDiscount * additionalDiscount)
            let moneySaved = moneySavedBeforeTax + (moneySavedBeforeTax * (tax / 100))
            let moneySavedFormatted = addComma(inputValue: moneySaved)
            
            return moneySavedFormatted
        } else if segmentA == false && segmentB == true {
            
            let totalAfterFirstDiscount = price - discount
            let secondDiscount = totalAfterFirstDiscount * additionalDiscount
            let moneySaved = discount + secondDiscount
            let moneySavedAfterTax = moneySaved + (moneySaved * (tax / 100))
            let moneySavedFormatted = addComma(inputValue: moneySavedAfterTax)
            
            return moneySavedFormatted
        } else {
            
            let firstDiscount = discount * price
            let moneySaved = additionalDiscount + firstDiscount
            let moneySavedAfterTax = moneySaved + (moneySaved * tax / 100)
            let moneySavedFormatted = addComma(inputValue: moneySavedAfterTax)
            
            return moneySavedFormatted
        }
        
    }
    
}

class LoanCalc {
    
    var interestRate: Double = 0
    var loanAmount: Double = 0
    var termInMonths: Double = 0
    var downPayment: Double = 0
    var monthlyInterestRate: Double {
        get {
            return (interestRate / 12.0)
        }
    }
    var monthlyPayment: Double {
        get {
            return ((loanAmount - downPayment) * monthlyInterestRate) /
                (1 - (pow(1 + monthlyInterestRate, -termInMonths)))
        }
    }
    var totalAmount: Double {
        get {
            return monthlyPayment * termInMonths
        }
    }
    var totalInterest: Double {
        get {
            return totalAmount - (loanAmount - downPayment)
        }
    }
    
    func toNumber(inputValue: String) -> Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.number(from: inputValue)! as Double
    }
    
    func toDecimal(inputValue: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: inputValue))!
    }
    
    func addComma(inputValue: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: inputValue))!
    }
}

class paycheckCalc {
    
    var hoursWorked: Double = 0
    var hourlyRate: Double = 0
    var federalTax: Double = 0
    var grossPay: Double {
        get {
            return hoursWorked * hourlyRate
        }
    }
    let socialSecurity = 0.062
    let medicare = 0.0145
    var withholdings: Double = 0
    
    func amountToWithhold(payPeriod: String, numOfWithholdings: Double) -> Double {
        
        if payPeriod == "Weekly" {
            return 77.9 * numOfWithholdings
        } else if payPeriod == "Bi-Weekly"{
            return 155.8 * numOfWithholdings
        }else if payPeriod == "Semi-Monthly" {
            return 168.8 * numOfWithholdings
        }else {
            return 337.5 * numOfWithholdings
        }
    }
    
    func toNumber(inputValue: String) -> Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.number(from: inputValue)! as Double
    }
    
    func toDecimal(inputValue: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: inputValue))!
    }
    
    func addComma(inputValue: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: inputValue))!
    }
    
    func fedTaxBiWeeklySingle(_ grossPay: Double) -> Double {
        if (87 <= grossPay && grossPay < 443) {
            federalTax = ((grossPay - 87) * 0.10)
        } else if (443 <= grossPay && grossPay < 1535) {
            federalTax = ((grossPay - 443) * 0.15) + 35.60
        } else if (1535 <= grossPay && grossPay < 3592) {
            federalTax = ((grossPay - 1535) * 0.25) + 199.40
        } else if (3592 <= grossPay && grossPay < 7400) {
            federalTax = ((grossPay - 3592) * 0.28) + 713.65
        } else if (7400 <= grossPay && grossPay < 15985) {
            federalTax = ((grossPay - 7400) * 0.33) + 1779.89
        } else if (15985 <= grossPay && grossPay < 16050) {
            federalTax = ((grossPay - 15985) * 0.35) + 4612.94
        } else if (grossPay >= 16050) {
            federalTax = ((grossPay - 16050) * 39.6) + 4635.69
        } else if (0 <= grossPay && grossPay < 87) {
            federalTax = 0.0
        }
        return federalTax
    }
    
    func fedTaxWeeklySingle(_ grossPay: Double)  -> Double {
        
        if (43 <= grossPay && grossPay < 222) {
            federalTax = ((grossPay - 43) * 0.10)
        } else if (222 <= grossPay && grossPay < 767) {
            federalTax = ((grossPay - 222) * 0.15) + 17.90
        } else if (767 <= grossPay && grossPay < 1796) {
            federalTax = ((grossPay - 767) * 0.25) + 99.65
        } else if (1796 <= grossPay && grossPay < 3700) {
            federalTax = ((grossPay - 1795) * 0.28) + 356.9
        } else if (3700 <= grossPay && grossPay < 7992) {
            federalTax = ((grossPay - 3700) * 0.33) + 890.02
        } else if (7992 <= grossPay && grossPay < 8025) {
            federalTax = ((grossPay - 7992) * 0.35) + 2306.38
        } else if (grossPay >= 8025) {
            federalTax = ((grossPay - 8025) * 39.6) + 2317.93
        } else if (0 <= grossPay && grossPay < 43) {
            federalTax = 0.0
        }
        return federalTax
    }
    
    
    func fedTaxSemiMonthlySingle(_ grossPay: Double) -> Double {
        if (94 <= grossPay && grossPay < 480) {
            federalTax = ((grossPay - 94) * 0.10)
        } else if (480 <= grossPay && grossPay < 1663) {
            federalTax = ((grossPay - 480) * 0.15) + 38.60
        } else if (1663 <= grossPay && grossPay < 3892) {
            federalTax = ((grossPay - 1663) * 0.25) + 216.05
        } else if (3892 <= grossPay && grossPay < 8017) {
            federalTax = ((grossPay - 3592) * 0.28) + 773.30
        } else if (8017 <= grossPay && grossPay < 17317) {
            federalTax = ((grossPay - 8017) * 0.33) + 1928.30
        } else if (17317 <= grossPay && grossPay < 17388) {
            federalTax = ((grossPay - 17317) * 0.35) + 4997.30
        } else if (grossPay >= 17388) {
            federalTax = ((grossPay - 117388) * 39.6) + 5022.15
        } else if (0 <= grossPay && grossPay < 94) {
            federalTax = 0.0
        }
        return federalTax
    }
    
    func fedTaxMonthlySingle(_ grossPay: Double) -> Double {
        if (188 <= grossPay && grossPay < 960) {
            federalTax = ((grossPay - 188) * 0.10)
        } else if (960 <= grossPay && grossPay < 3325) {
            federalTax = ((grossPay - 960) * 0.15) + 77.2
        } else if (3325 <= grossPay && grossPay < 7783) {
            federalTax = ((grossPay - 1663) * 0.25) + 431.95
        } else if (7783 <= grossPay && grossPay < 16033) {
            federalTax = ((grossPay - 3592) * 0.28) + 1546.45
        } else if (16033 <= grossPay && grossPay < 34633) {
            federalTax = ((grossPay - 8017) * 0.33) + 3856.45
        } else if (34633 <= grossPay && grossPay < 34775) {
            federalTax = ((grossPay - 17317) * 0.35) + 9994.45
        } else if (grossPay >= 34775) {
            federalTax = ((grossPay - 34775) * 39.6) + 10044.15
        } else if (0 <= grossPay && grossPay < 188) {
            federalTax = 0.0
        }
        return federalTax
    }
    
    func fedTaxWeeklyMarried(_ grossPay: Double) -> Double {
        if (164 <= grossPay && grossPay < 521) {
            federalTax = ((grossPay - 164) * 0.10)
        } else if (521 <= grossPay && grossPay < 1613) {
            federalTax = ((grossPay - 521) * 0.15) + 35.7
        } else if (1613 <= grossPay && grossPay < 3086) {
            federalTax = ((grossPay - 1613) * 0.25) + 199.5
        } else if (3086 <= grossPay && grossPay < 4615) {
            federalTax = ((grossPay - 3086) * 0.28) + 567.75
        } else if (4615 <= grossPay && grossPay < 8113) {
            federalTax = ((grossPay - 4615) * 0.33) + 995.87
        } else if (8113 <= grossPay && grossPay < 9144) {
            federalTax = ((grossPay - 8113) * 0.35) + 2150.21
        } else if (grossPay >= 9144) {
            federalTax = ((grossPay - 9144) * 39.6) + 2511.06
        } else if (0 <= grossPay && grossPay < 164) {
            federalTax = 0.0
        }
        return federalTax
    }
    
    func fedTaxBiWeeklyMarried(_ grossPay: Double) -> Double {
        if (329 <= grossPay && grossPay < 1042) {
            federalTax = ((grossPay - 329) * 0.10)
        } else if (1042 <= grossPay && grossPay < 3225) {
            federalTax = ((grossPay - 1042) * 0.15) + 71.3
        } else if (3225 <= grossPay && grossPay < 6171) {
            federalTax = ((grossPay - 3225) * 0.25) + 398.75
        } else if (6171 <= grossPay && grossPay < 9231) {
            federalTax = ((grossPay - 6171) * 0.28) + 1135.25
        } else if (9231 <= grossPay && grossPay < 16227) {
            federalTax = ((grossPay - 9231) * 0.33) + 1992.05
        } else if (16227 <= grossPay && grossPay < 18288) {
            federalTax = ((grossPay - 16227) * 0.35) + 4300.73
        } else if (grossPay >= 18288) {
            federalTax = ((grossPay - 18288) * 39.6) + 5022.08
        } else if (0 <= grossPay && grossPay < 329) {
            federalTax = 0.0
        }
        return federalTax
    }
    
    func fedTaxSemiMonthlyMarried(_ grossPay: Double) -> Double {
        if (356 <= grossPay && grossPay < 1129) {
            federalTax = ((grossPay - 356) * 0.10)
        } else if (1129 <= grossPay && grossPay < 3494) {
            federalTax = ((grossPay - 1129) * 0.15) + 77.3
        } else if (3494 <= grossPay && grossPay < 6685) {
            federalTax = ((grossPay - 3494) * 0.25) + 432.05
        } else if (6685 <= grossPay && grossPay < 10000) {
            federalTax = ((grossPay - 6685) * 0.28) + 1229.8
        } else if (10000 <= grossPay && grossPay < 17579) {
            federalTax = ((grossPay - 10000) * 0.33) + 2158
        } else if (17579 <= grossPay && grossPay < 19813) {
            federalTax = ((grossPay - 17579) * 0.35) + 4659.07
        } else if (grossPay >= 19813) {
            federalTax = ((grossPay - 19813) * 39.6) + 5440.97
        } else if (0 <= grossPay && grossPay < 356) {
            federalTax = 0.0
        }
        return federalTax
    }
    
    
}


