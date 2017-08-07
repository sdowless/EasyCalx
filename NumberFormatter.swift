//
//  NumberFormatter.swift
//  Easy Calx
//
//  Created by Stephan Dowless on 11/22/16.
//  Copyright © 2016 Stephan Dowless. All rights reserved.
//

import Foundation
class NumberFormatter {
    let price = 123.436 as NSNumber
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
}
