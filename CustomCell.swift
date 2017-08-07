//
//  CustomCell.swift
//  Easy Calx
//
//  Created by Stephan Dowless on 12/19/16.
//  Copyright © 2016 Stephan Dowless. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var originalPrice: UITextField!
    @IBOutlet weak var discountedPrice: UITextField!
    @IBOutlet weak var itemDescription: UILabel!

    

    override func awakeFromNib() {
        super.awakeFromNib()
    }


}
