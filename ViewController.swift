//
//  ViewController.swift
//  Easy Calx
//
//  Created by Stephan Dowless on 11/18/16.
//  Copyright © 2016 Stephan Dowless. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{
    
    //MARK: Properties
    @IBOutlet weak var itemPrice: UITextField!
    @IBOutlet weak var taxTextField: UITextField!
    @IBOutlet weak var discountPercent: UITextField!
    @IBOutlet weak var addDiscountTextField: UITextField!
    @IBOutlet weak var discountSegmentedControl: UISegmentedControl!
    @IBOutlet weak var addDiscountSegmentedControl: UISegmentedControl!
    @IBOutlet weak var moneySavedTextField: UITextField!
    @IBOutlet weak var finalPriceTextView: UITextField!
    @IBOutlet weak var itemDescription: UITextField!
    @IBOutlet weak var addToCartBtn: UIButton!
    
    let discCalc = DiscountCalculation()
    var percentSelected  = true
    var otherPercentSelected = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide add to cart button when view is loaded
        addToCartBtn.isHidden = true
        
        // Set delegates to self
        itemPrice.delegate = self
        taxTextField.delegate = self
        itemDescription.delegate = self
        
        // Loading saved sales tax value
        let taxDefault = UserDefaults.standard
        if taxDefault.value(forKey: "setTax") != nil {
            discCalc.tax = taxDefault.value(forKey: "setTax") as! Double
            taxTextField.text = "\(discCalc.toDecimalTax(inputValue: discCalc.tax))"
        }
        
        // Add done button to keyboards
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        
        itemPrice.inputAccessoryView = toolBar
        taxTextField.inputAccessoryView = toolBar
        discountPercent.inputAccessoryView = toolBar
        addDiscountTextField.inputAccessoryView = toolBar
    }
    
    // Function to dismiss keyboard when done button is clicked
    func doneClicked() {
        view.endEditing(true)
    }
    
    // Format text field values to decimal values
    func textFieldDidEndEditing(_ textField: UITextField){
        discCalc.tax = Double((taxTextField.text! as NSString).doubleValue)
        discCalc.price = Double((itemPrice.text! as NSString).doubleValue)
        
        itemPrice.tag = 0
        taxTextField.tag = 1
        itemDescription.tag = 2
        
        if textField.tag == 0 {
            itemPrice.text = discCalc.toDecimal(inputValue: discCalc.price)
        }
        if  textField.tag == 1 {
            taxTextField.text = discCalc.toDecimalTax(inputValue: discCalc.tax)
        }
        if textField.tag == 2 {
            addToCartBtn.isHidden = false
            calculatePressed()
        }
        discCalc.tax = Double((taxTextField.text! as NSString).doubleValue) / 100
        discCalc.price = Double((itemPrice.text! as NSString).doubleValue)
    }
    
    // Dismiss keyboard for item description and calculate when done button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        itemDescription.tag = 0
        
        if textField.tag == 0 {
            calculatePressed()
            itemDescription.resignFirstResponder()
            return true
        }
        return false
    }
    
    func calculatePressed() {
        // Dismiss keyboards when calculate button pressed
        itemPrice.resignFirstResponder()
        taxTextField.resignFirstResponder()
        discountPercent.resignFirstResponder()
        addDiscountTextField.resignFirstResponder()
        itemDescription.resignFirstResponder()
        
        // Convert text field values to double values for calculation
        if itemPrice.hasText {
            discCalc.price = discCalc.toNumber(inputValue: itemPrice.text!)
        } else {
            discCalc.price = 0
        }
        discCalc.tax = Double((taxTextField.text! as NSString).doubleValue)
        discCalc.additionalDiscount = Double((addDiscountTextField.text! as NSString).doubleValue)
        discCalc.discount = Double((discountPercent.text! as NSString).doubleValue)
        
        // Save user input for tax data. See viewDidLoad function for additional code
        let taxDefault = UserDefaults.standard
        taxDefault.set(discCalc.tax, forKey: "setTax")
        taxDefault.synchronize()
        
        if discountSegmentedControl.selectedSegmentIndex == 0 {
            percentSelected = false
        } else {
            percentSelected = true
        }
        
        if addDiscountSegmentedControl.selectedSegmentIndex == 0 {
            otherPercentSelected = false
        } else {
            otherPercentSelected = true
        }
        
        finalPriceTextView.text = discCalc.calcDiscount(segmentA: percentSelected, segmentB: otherPercentSelected)
        moneySavedTextField.text = discCalc.calcMoneySaved(segmentA: percentSelected, segmentB: otherPercentSelected)
    }

    //MARK: Actions
    @IBAction func calculateTapped(_ sender: UIButton) {
        calculatePressed()
        
    }
    
    @IBAction func addToCart(_ sender: UIButton) {
        
        if itemDescription.hasText {
            items.append(itemDescription.text!)
            itemDescription.resignFirstResponder()
        } else {
            items.append("Item Description")
        }
        
        let price = discCalc.total
        prices.append(price)
        
        let discountedPrice = discCalc.toNumberFromCurrency(inputValue: finalPriceTextView.text!)
        //moneySavedTextField.text = "\(discountedPrice)"
        discountedPrices.append(discountedPrice)
                
        addToCartBtn.isHidden = true
        itemDescription.text = ""
    }
}


