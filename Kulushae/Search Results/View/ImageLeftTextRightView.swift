//
//  ImageLeftTextRightView.swift
//  Kulushae
//
//  Created by ios on 23/11/2023.
//

import SwiftUI

struct ImageLeftTextRightView: View {
    
    @EnvironmentObject var languageManager: LanguageManager
    
    var text: String
    var image: String
    
    var body: some View {
        
        HStack {
            Image(image)
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.gray)
            Text(LocalizedStringKey(text))
                .foregroundColor(Color.gray)
                .font(.roboto_16())
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
            
        }
        .background(.white)
//        .frame( width: (.screenWidth / 4 ) - 10, height: 20)
        .frame( height: 20)
    }
}
