//
//  SelectLanguagePopupView.swift
//  Kulushae
//
//  Created by Waseem  on 08/01/2025.
//

import SwiftUI

struct SelectLanguagePopupView: View {
    
    @EnvironmentObject var languageManager: LanguageManager
    var handler: (()->())? = nil
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.clear
            
            VStack(spacing: 20) {
                
                englishOptionView
                
                arabicOptionView
            }
            .padding(.top, 30)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity)
            .background(
                Color.white
                    .cornerRadius(30, corners: [.topLeft, .topRight])
                    .ignoresSafeArea(edges: .bottom)
            )
        }
        .padding(.top, 28)
        .cleanNavigation()
    }
    
    
    var englishOptionView: some View {
        Button(action: {
            setLanguage(language: "en")
        }) {
            VStack(spacing: 0) {
                Text("English")
                    .font(.Roboto.Medium(of: 18))
                    .foregroundStyle(.black)
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black.opacity(0.87), lineWidth: 1.0)
            }
        }
    }
    
    var arabicOptionView: some View {
        Button(action: {
            setLanguage(language: "ar")
        }) {
            VStack(spacing: 0) {
                Text("عربي")
                    .font(.Roboto.Medium(of: 18))
                    .foregroundStyle(.black)
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black.opacity(0.87), lineWidth: 1.0)
            }
        }
    }
    
    func setLanguage(language: String) {
        UserDefaults.standard.set(language, forKey: "AppLanguage")
        languageManager.setLanguage(language)
        handler?()
    }
}

#Preview {
    SelectLanguagePopupView()
}
