//
//  ViewControllerPaycheck.swift
//  Easy Calx
//
//  Created by Stephan Dowless on 11/19/16.
//  Copyright © 2016 Stephan Dowless. All rights reserved.
//

import Foundation
import UIKit

class ViewControllerPaycheck: UIViewController, UIPickerViewDelegate, UITextFieldDelegate {
    
    // MARK: Properties
    @IBOutlet weak var hoursWorked: UITextField!
    @IBOutlet weak var hourlyRate: UITextField!
    @IBOutlet weak var maritalStatusSegment: UISegmentedControl!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var payPeriodTextField: UITextField!
    @IBOutlet weak var withholdings: UITextField!
    
    // Picker view data
    var pickPayPeriod = ["Weekly", "Bi-Weekly", "Semi-Monthly", "Monthly"]
    var pickOption = ["Alabama", "Alaska", "Arizona", "Arkansas", "California", "Connecticut", "Colorado", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Iowa", "Indiana", "Illinois", "Kentucky", "Kansas", "Louisiana", "Montana", "Michigan", "Minnesota", "Massachusetts", "Maine", "Maryland", "Mississippi", "Missouri", "New Hampshire", "New Jersey", "New York", "North Carolina", "North Dakota", "New Mexico", "Nevada", "Nebraska", "Ohio", "Oregon", "Oaklahoma", "Rhode Island", "Pennsylvania", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "Wisconsin", "Wyoming", "West Virginia" ]
    
    // Instance of paycheckCalc class
    var paycheck = paycheckCalc()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Picker view declarations
        let pickerViewPayment = UIPickerView()
        pickerViewPayment.delegate = self
        payPeriodTextField.inputView = pickerViewPayment
        
        let pickerViewState = UIPickerView()
        pickerViewState.delegate = self
        stateTextField.inputView = pickerViewState
        
        pickerViewPayment.tag = 0
        pickerViewState.tag = 1
        
        // Format hourly pay to decimal
        hourlyRate.delegate = self
        
        // Load hourly rate 
        let hourlyRateDefault = UserDefaults.standard
        if hourlyRateDefault.value(forKey: "setHourlyRate") != nil {
            paycheck.hourlyRate = hourlyRateDefault.value(forKey: "setHourlyRate") as! Double
            hourlyRate.text = paycheck.toDecimal(inputValue: paycheck.hourlyRate)
        }
        
        // Add done button to keyboards
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        
        hoursWorked.inputAccessoryView = toolBar
        hourlyRate.inputAccessoryView = toolBar
        stateTextField.inputAccessoryView = toolBar
        withholdings.inputAccessoryView = toolBar
        payPeriodTextField.inputAccessoryView = toolBar

    }
    // Function to dismiss keyboard when done button is clicked
    func doneClicked() {
        view.endEditing(true)
    }
    
    // Save user input for hourly rate. See viewDidLoad function for additional code
    func textFieldDidEndEditing(_ textField: UITextField) {
        paycheck.hourlyRate = Double((hourlyRate.text! as NSString).doubleValue)
        hourlyRate.text = paycheck.toDecimal(inputValue: paycheck.hourlyRate)
        
        let hourlyRateDefault = UserDefaults.standard
        hourlyRateDefault.setValue(paycheck.hourlyRate, forKey: "setHourlyRate")
        hourlyRateDefault.synchronize()
    }
    
    // Functions for PickerViews
    func numberOfComponentsInPickerView(_ pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return 4
        } else if pickerView.tag == 1 {
            return 50
        }
        return pickPayPeriod.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            payPeriodTextField.text = pickPayPeriod[row]
        } else if pickerView.tag == 1 {
            stateTextField.text = pickOption[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 0) {
            return pickPayPeriod[row]
        } else if (pickerView.tag == 1) {
            return pickOption[row]
        }
        return ""
    }
    
    // Loading data from first to second view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "identifySegue") {
            let destViewController = segue.destination as! PaymentView
            
            // Calculate and log gross pay for PaycheckViewTwo
            if hourlyRate.hasText {
                paycheck.hourlyRate = paycheck.toNumber(inputValue: hourlyRate.text!)
            } else {
                paycheck.hourlyRate = 0
                // Could replace this by using optionals
            }
            paycheck.hoursWorked = Double((hoursWorked.text! as NSString).doubleValue)
            paycheck.withholdings = Double((withholdings.text! as NSString).doubleValue)
            destViewController.grossPayTransfer = paycheck.grossPay
            let amountToTax =  paycheck.grossPay - paycheck.amountToWithhold(payPeriod: payPeriodTextField.text!, numOfWithholdings: paycheck.withholdings)
            
            // Federal Tax Income Control Flow. Could be replaced by using function in model with proper inputs
            if (payPeriodTextField.text == "Weekly" && maritalStatusSegment.selectedSegmentIndex == 0){
                let fedTaxWeekly = paycheck.fedTaxWeeklySingle(amountToTax)
                destViewController.federalTaxTransfer = fedTaxWeekly
            } else if (payPeriodTextField.text == "Bi-Weekly" && maritalStatusSegment.selectedSegmentIndex == 0) {
                let fedTaxBiWeekly = paycheck.fedTaxBiWeeklySingle(amountToTax)
                destViewController.federalTaxTransfer = fedTaxBiWeekly
            } else if (payPeriodTextField.text == "Semi-Monthly" && maritalStatusSegment.selectedSegmentIndex == 0) {
                let fedTaxSemiMonthly = paycheck.fedTaxSemiMonthlySingle(amountToTax)
                destViewController.federalTaxTransfer = fedTaxSemiMonthly
            } else if (payPeriodTextField.text == "Monthly" && maritalStatusSegment.selectedSegmentIndex == 0) {
                let fedTaxMonthly = paycheck.fedTaxMonthlySingle(amountToTax)
                destViewController.federalTaxTransfer = fedTaxMonthly
            } else if (payPeriodTextField.text == "Weekly" && maritalStatusSegment.selectedSegmentIndex == 1) {
                let fedTaxWeeklyMarried = paycheck.fedTaxWeeklyMarried(amountToTax)
                destViewController.federalTaxTransfer = fedTaxWeeklyMarried
            } else if (payPeriodTextField.text == "Bi-Weekly" && maritalStatusSegment.selectedSegmentIndex == 1) {
                let fedTaxBiWeeklyMarried = paycheck.fedTaxBiWeeklyMarried(amountToTax)
                destViewController.federalTaxTransfer = fedTaxBiWeeklyMarried
            } else if (payPeriodTextField.text == "Semi-Monthly" && maritalStatusSegment.selectedSegmentIndex == 1) {
                let fedTaxSemiMonthlyMarried = paycheck.fedTaxSemiMonthlyMarried(amountToTax)
                destViewController.federalTaxTransfer = fedTaxSemiMonthlyMarried
            } else {
                // Need to create function for monthly pay and marital status: married. This data is incorrect
                let fedTaxMonthlyMarried = paycheck.fedTaxSemiMonthlyMarried(amountToTax)
                destViewController.federalTaxTransfer = fedTaxMonthlyMarried
            }
            
            // Social Security Tax
            destViewController.socialSecurityTransfer = paycheck.grossPay * paycheck.socialSecurity
            
            // Medicare Tax
            destViewController.medicareTransfer = paycheck.grossPay * paycheck.medicare
            
            // Net Pay
            destViewController.netPayTransfer = paycheck.grossPay - destViewController.federalTaxTransfer -
                destViewController.socialSecurityTransfer - destViewController.medicareTransfer
        }
    }
}
