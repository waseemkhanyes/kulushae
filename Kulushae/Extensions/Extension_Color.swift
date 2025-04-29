//
//  Extension_Color.swift
//  Easy Buy
//
//  Created by ios on 03/10/2023.
//

import SwiftUI

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        let red = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0x00FF00) >> 8) / 255.0
        let blue = Double(hex & 0x0000FF) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
    
    static func customColor(hex: UInt) -> Color {
        return Color(hex: hex)
    }
    static let appBackgroundColor = Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 1)
    static let appPrimaryColor = Color(red: 1.00, green: 0.51, blue: 0.05, opacity: 1.00)
    static let iconSelectionColor = Color(red: 0.47, green: 0.65, blue: 0.79, opacity: 1.00)
    static let unselectedBorderColor = Color(red: 0.93, green: 0.93, blue: 0.93, opacity: 1)
    static let unselectedTextBackgroundColor = Color(red: 0.98, green: 0.98, blue: 0.98, opacity: 1)
    static let backgroundCategoryColor  = Color(red: 0.96, green: 0.96, blue: 0.96)
    static let selectedTextBackgroundColor = Color(red: 0.77, green: 0.77, blue: 0.77)
    static let backgroundWithLessOpacity = Color(red: 0.98, green: 0.98, blue: 0.96, opacity: 1)
}
