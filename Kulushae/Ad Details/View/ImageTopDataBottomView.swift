//
//  ImageTopDataBottomView.swift
//  Kulushae
//
//  Created by ios on 18/11/2023.
//

import SwiftUI

struct ImageTopDataBottomView: View {
    
    @EnvironmentObject var languageManager: LanguageManager
    
    var text: String
    var image: String
    
    var body: some View {
        
        VStack {
            Image(image)
                .resizable()
                .foregroundColor(.black)
                .frame(width: 25, height: 25)
            Text(LocalizedStringKey(text))
                .foregroundColor(Color.black)
                .font(.roboto_16())
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
            
        }
        .background(.white)
        .frame( width: 85, height: 61)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .inset(by: 0.5)
                .stroke(.black, lineWidth: 1)
            
        )
    }
}
