//
//  Constants.swift
//  Polly
//
//  Created by Nikki Fernandez on 28/07/2016.
//  Copyright © 2016 SourcePad. All rights reserved.
//

import UIKit


// MARK: COLORS
func UIColorFromHEX(colorCode: String, alpha: Float = 1.0) -> UIColor {
    let scanner = NSScanner(string:colorCode)
    var color:UInt32 = 0;
    scanner.scanHexInt(&color)
    
    let mask = 0x000000FF
    let r = CGFloat(Float(Int(color >> 16) & mask)/255.0)
    let g = CGFloat(Float(Int(color >> 8) & mask)/255.0)
    let b = CGFloat(Float(Int(color) & mask)/255.0)
    
    return UIColor(red: r, green: g, blue: b, alpha: CGFloat(alpha))
}

let COLOR_POLLY_GREEN = UIColorFromHEX("A2D7DA")
let COLOR_POLLY_PINK = UIColorFromHEX("EECDCC")
let COLOR_POLLY_THEME_LIGHT = UIColorFromHEX("A98DA2")
let COLOR_POLLY_THEME_DARK = UIColorFromHEX("6F677B")
let COLOR_POLLY_TEXT = UIColorFromHEX("434343")