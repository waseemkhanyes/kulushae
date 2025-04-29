//
//  Extension_Date.swift
//  Kulushae
//
//  Created by ios on 06/11/2023.
//

import Foundation
extension Date {
    
    func toString(withFormat format: String = "EEEE ، d MMMM yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation() ?? "UTC")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
        
    }
    
    func string(format: String) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            return formatter.string(from: self)
        }
}
