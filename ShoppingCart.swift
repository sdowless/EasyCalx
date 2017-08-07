//
//  ShoppingCart.swift
//  Easy Calx
//
//  Created by Stephan Dowless on 12/19/16.
//  Copyright © 2016 Stephan Dowless. All rights reserved.
//

import UIKit

class ShoppingCart: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalTxt: UITextField!
    @IBOutlet weak var moneySavedTxt: UITextField!
    
    let cart = Cart()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Clear shopping list
    @IBAction func clearBtn(_ sender: Any) {
        items.removeAll()
        prices.removeAll()
        discountedPrices.removeAll()
        
        totalTxt.text = ""
        moneySavedTxt.text = ""
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let totalDisplay = cart.sumTotal()
        let moneySavedDisplay = cart.sumMoneySaved()
        
        totalTxt.text = "\(cart.addComma(inputValue: totalDisplay))"
        moneySavedTxt.text = "\(cart.addComma(inputValue: moneySavedDisplay))"
        
        tableView.reloadData()
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        
        let originalPrice = prices[indexPath.row]
        let discountedPrice = discountedPrices[indexPath.row]
        
        cell.itemDescription.text = items[indexPath.row]
        cell.originalPrice.text = cart.addComma(inputValue: originalPrice)
        cell.discountedPrice.text = cart.addComma(inputValue: discountedPrice)
        
        return cell
    }
}
