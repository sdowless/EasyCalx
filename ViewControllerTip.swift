//
//  ViewControllerTip.swift
//  Easy Calx
//
//  Created by Stephan Dowless on 11/18/16.
//  Copyright © 2016 Stephan Dowless. All rights reserved.
//

import Foundation
import UIKit

class ViewControllerTip: UIViewController, UITextFieldDelegate {
    
    
    // MARK: Properties
    @IBOutlet weak var totalTextField: UITextField!
    @IBOutlet weak var tipPctSlider: UISlider!
    @IBOutlet weak var tipPctLabel: UILabel!
    @IBOutlet weak var otherTipTextField: UITextField!
    @IBOutlet weak var splitCheckSlider: UISlider!
    @IBOutlet weak var splitCheckLabel: UILabel!
    @IBOutlet weak var tipTextField: UITextField!
    @IBOutlet weak var totalWithTip: UITextField!
    @IBOutlet weak var totalPerPerson: UITextField!
    @IBOutlet weak var tipPerPerson: UITextField!
    @IBOutlet weak var perPersonLbl: UILabel!
    @IBOutlet weak var tipPerPersonLbl: UILabel!
   
     let tipCalc = TipCalc()
    
    override func viewDidLoad() {
        
        totalPerPerson.isHidden = true
        tipPerPerson.isHidden = true
        tipPerPersonLbl.isHidden = true
        perPersonLbl.isHidden = true
        
        super.viewDidLoad()
        totalTextField.delegate = self
        otherTipTextField.delegate = self
        
        // Add done button to keyboards
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        
        totalTextField.inputAccessoryView = toolBar
        otherTipTextField.inputAccessoryView = toolBar

    }
    
    override func viewDidAppear(_ animated: Bool) {
        totalPerPerson.isHidden = true
        tipPerPerson.isHidden = true
        tipPerPersonLbl.isHidden = true
        perPersonLbl.isHidden = true
    }
    
    // Function to dismiss keyboard when done button is clicked
    func doneClicked() {
        view.endEditing(true)
    }
    
    // Number formatting functions for user input values
    func textFieldDidEndEditing(_ textField: UITextField) {
        totalTextField.tag = 0
        otherTipTextField.tag = 1
        
        tipCalc.total = Double((totalTextField.text! as NSString).doubleValue)
        tipCalc.otherTip = Double((otherTipTextField.text! as NSString).doubleValue)

        if textField.tag == 0 {
            totalTextField.text = tipCalc.toDecimal(inputValue: tipCalc.total)
        }
        if textField.tag == 1 {
            if otherTipTextField.hasText {
            otherTipTextField.text = tipCalc.toDecimal(inputValue: tipCalc.otherTip)
            }else {
                otherTipTextField.text = ""
            }
        }
    }
    
    // MARK: Actions
    @IBAction func calculateTapped(_ sender: UIButton) {
        calculate()
    }
    
    // Update label text with tip value based on slider
    @IBAction func tipPctChanged(_ sender: Any) {
        calculate()
        tipPctLabel.text = "Tip Percentage(\(Int(tipPctSlider.value))%)"
        totalTextField.resignFirstResponder()
    }
    
    // Update label text with split number based on slider
    @IBAction func splitNumberChanged(_ sender: Any) {
        calculate()
        splitCheckLabel.text = "Split Check(\(Int(splitCheckSlider.value)))"
        otherTipTextField.resignFirstResponder()
        
        totalPerPerson.isHidden = false
        tipPerPerson.isHidden = false
        tipPerPersonLbl.isHidden = false
        perPersonLbl.isHidden = false
    }
    
    func calculate() {
        totalTextField.resignFirstResponder()
        otherTipTextField.resignFirstResponder()
        
        // Checks if total text field has text for calculations. Should use optional here.
        if totalTextField.hasText {
            tipCalc.total = tipCalc.toNumber(inputValue: totalTextField.text!)
        } else {
            tipCalc.total = 0
        }
        
        // Floor slider value and set to tip value
        let tipPercentFloored = floor(tipPctSlider.value) / 100.0
        tipCalc.tipPct = Double(tipPercentFloored)
        
        let totalWithTipText = String(format: "%.2f", (tipCalc.totalWithTip))
        totalWithTip.text = "$\(totalWithTipText)"
        
        // Floor split number and update corresponding text fields
        tipCalc.splitNumber = Double(splitCheckSlider.value)
        let splitNumberFloored = floor(tipCalc.splitNumber)
        let totalPerPersonText = String(format: "%.2f", (tipCalc.totalWithTip / splitNumberFloored))
        totalPerPerson.text = "$\(totalPerPersonText)"
        
        let tipText = String(format: "%.2f", (tipCalc.getTip))
        tipTextField.text = "$\(tipText)"
        tipPerPerson.text = String(format: "$%.2f", tipCalc.getTip / splitNumberFloored)
        
        // Sets alternate tip input value as tip, over rides slider tip value
        if otherTipTextField.hasText {
            tipCalc.total = tipCalc.toNumber(inputValue: totalTextField.text!)
            tipCalc.otherTip = Double((otherTipTextField.text! as NSString).doubleValue) / 100
            
            let totalWithTipText = String(format: "%.2f", (tipCalc.totalWithOtherTip))
            totalWithTip.text = "$\(totalWithTipText)"
            tipCalc.splitNumber = Double(splitCheckSlider.value)
            let splitNumberFloored = floor(tipCalc.splitNumber)
            
            let totalPerPersonText = String(format: "%.2f", (tipCalc.totalWithOtherTip / splitNumberFloored))
            totalPerPerson.text = "$\(totalPerPersonText)"
            
            let tipText = String(format:"%.2f", (tipCalc.getOtherTip))
            tipTextField.text = "$\(tipText)"
            tipPerPerson.text = String(format: "$%.2f", tipCalc.getOtherTip / splitNumberFloored)
            
        }

    }

}
