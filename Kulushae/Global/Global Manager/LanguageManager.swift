//
//  LanguageManager.swift
//  Easy Buy
//
//  Created by ios on 04/10/2023.
//

import Foundation
import SwiftUI

class LanguageManager: ObservableObject {
    @Published var currentLanguage: String
    @Published var layoutDirection: LayoutDirection
    
    init() {
        // Initialize with a default language, e.g., "en" for English
        
        self.currentLanguage = UserDefaults.standard.string(forKey: "AppLanguage") ?? "en"
        self.layoutDirection = (UserDefaults.standard.string(forKey: "AppLanguage") ?? "en" == "ar") ? .rightToLeft : .leftToRight 
    }
    
    func setLanguage(_ language: String) {
        DispatchQueue.main.async {
            self.currentLanguage = language
            self.layoutDirection = (language == "ar") ? .rightToLeft : .leftToRight
            print("setting lang to ", language)
            UserDefaults.standard.set(language, forKey: "AppLanguage")
            UserDefaults.standard.synchronize() // Add this line to synchronize UserDefaults
            
            // Update the app's language
            if let bundlePath = Bundle.main.path(forResource: language, ofType: "lproj") {
                Bundle.setLanguage(language)
            }
            
            // Update the locale to trigger text localization
            let newLocale = Locale(identifier: language)
            UserDefaults.standard.set([newLocale.identifier], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            
            // Update text direction based on the selected language
            // Notify the app about the language change
                        NotificationCenter.default.post(name: .didChangeLanguage, object: nil)
          
        }
    }
}
extension Notification.Name {
    static let didChangeLanguage = Notification.Name("didChangeLanguage")
}
struct Kulushae {
    enum LayoutDirection {
        case leftToRight
        case rightToLeft
    }
}


extension Bundle {
    static func setLanguage(_ language: String) {
        guard let bundlePath = Bundle.main.path(forResource: language, ofType: "lproj") else {
            return
        }
        
        if let bundle = Bundle(path: bundlePath) {
            objc_setAssociatedObject(self, &AssociatedKeys.Bundle, bundle, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        UserDefaults.standard.set([language], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
    
    private struct AssociatedKeys {
        static var Bundle = "Bundle"
    }
}
