//
//  Extension_Font.swift
//  Easy Buy
//
//  Created by ios on 03/10/2023.
//

import SwiftUI

extension Font {
    
    static func customFont(_ name:String, _ size: Double ) -> Font {
        return Font.custom(name, size: size)
    }
    
    static func roboto_10() -> Font {
        return Font.custom("Roboto-Regular", size: 10.0)
    }
    
    static func roboto_14() -> Font {
        return Font.custom("Roboto-Regular", size: 14.0)
    }
    
    static func roboto_14_Medium() -> Font {
        return Font.custom("Roboto-Medium", size: 14.0)
    }
    
    static func roboto_14_thin() -> Font {
        return Font.custom("Roboto-Thin", size: 14.0)
    }
    static func roboto_16() -> Font {
        return Font.custom("Roboto-Regular", size: 16.0)
    }
    
    static func roboto_16_bold() -> Font {
        return Font.custom("Roboto-Bold", size: 16.0)
    }
    
    static func roboto_18_bold() -> Font {
        return Font.custom("Roboto-Bold", size: 18.0)
    }
    static func roboto_18_thin() -> Font {
        return Font.custom("Roboto-Thin", size: 18.0)
    }
    
    static func roboto_20() -> Font {
        return Font.custom("Roboto-Regular", size: 20.0)
    }
    
    static func roboto_22() -> Font {
        return Font.custom("Roboto-Regular", size: 22.0)
    }
    
    static func roboto_22_semi() -> Font {
        return Font.custom("Roboto-Medium", size: 22.0)
    }
    
    static func roboto_24_semi() -> Font {
        return Font.custom("Roboto-Medium", size: 24.0)
    }
    
    static func roboto_24_bold() -> Font {
        return Font.custom("Roboto-Bold", size: 24.0)
    }
    
    static func roboto_40() -> Font {
        return Font.custom("Roboto-Regular", size: 40.0)
    }
}
