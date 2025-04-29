//
//  Extension_String.swift
//  Easy Buy
//
//  Created by ios on 03/10/2023.
//

import CryptoKit
import UIKit

// MARK: - Custom Font Names -
extension String {
    static var robotoBold = "Roboto-Bold"
    static var robotoLight = "Roboto-Light"
    static var robotoThin = "Roboto-Thin"
    static var robotoThinItalic = "Roboto-ThinItalic"
    static var robotoMedium = "Roboto-Medium"
    static var robotoMediumItalic = "Roboto-MediumItalic"
    static var robotoRegular = "Roboto-Regular"
    static var robotoCondensed = "Roboto-Condensed"
    //MARK : UAE numberformat
//    func formatPhoneNumber() -> String {
//        let cleanedNumber = self.replacingOccurrences(of: " ", with: "")
//        var formattedNumber = cleanedNumber
//        if formattedNumber.hasPrefix("00971") {
//            formattedNumber = formattedNumber.replacingOccurrences(of: "00971", with: "+971")
//        }
//        
//        if formattedNumber.hasPrefix("0") {
//            formattedNumber = formattedNumber.replacingOccurrences(of: "0", with: "+971", options: .anchored, range: formattedNumber.range(of: "0"))
//        }
//        return formattedNumber
//    }
//    
    func createSignature() {
        let inputData = Data(self.utf8)
        let hashed = SHA256.hash(data: inputData)
        let signatureString = hashed.compactMap { String(format: "%02x", $0) }.joined()
        print("signature is", signatureString)
        UserDefaults.standard.set(signatureString, forKey: "signatureString")
        UserDefaults.standard.synchronize()
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (self as NSString).size(withAttributes: fontAttributes)
        return size.width
    }
    
    func isValidPhone() -> Bool {
        
        let phoneNumberRegex = "^(?:\\+971|0(0971)?)(?:[234679]|5[01256])\\d{7}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        return predicate.evaluate(with: self)
    }
}
