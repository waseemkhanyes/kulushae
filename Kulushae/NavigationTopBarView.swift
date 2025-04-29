//
//  NavigationTopBarView.swift
//  Kulushae
//
//  Created by ios on 13/10/2023.
//

import SwiftUI

struct NavigationTopBarView: View {
    
    @EnvironmentObject var languageManager: LanguageManager
    @Environment(\.dismiss) var dismiss
    @State var titleVal: String = ""
    @State var isShowBAckButton: Bool = true
    @Environment(\.safeAreaInsets) var safeAreaInsets
    
    var body: some View {
        topView
//        HStack {
//            ZStack {
//                Image(isShowBAckButton ? "back" : "")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 24, height: 15, alignment: .center)
//                    .clipped()
//                    .scaleEffect(languageManager.currentLanguage == "ar" ? CGSize(width: -1, height: 1) : CGSize(width: 1, height: 1))
//            }
//            .frame(width: 35, height: 35)
//                .onTapGesture {
//                    if(isShowBAckButton) {
//                        dismiss()
//                    }
//                   
//                }
//            Text(LocalizedStringKey(titleVal))
//                .font(.roboto_22_semi())
//                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
//                .foregroundColor(Color.black)
////                .padding(.leading, 10)
//            Spacer()
//        }
    }
    
    var topView: some View {
        HStack(spacing: 0) {
            if isShowBAckButton {
                Button(action: {
                    dismiss()
                }) {
                    VStack(spacing: 0) {
                        Image("back")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 17, height: 12, alignment: .center)
                            .clipped()
                            .scaleEffect(languageManager.currentLanguage == "ar" ? CGSize(width: -1, height: 1) : CGSize(width: 1, height: 1))
                    }
                    .frame(width: 35, height: 35)
                }
                .padding(.leading, 12)
            }
            
            Text(LocalizedStringKey(titleVal))
                .font(.Roboto.Medium(of: 22))
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                .foregroundColor(Color.black)
                .padding(.leading, 5)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 50)
        .padding(.top, safeAreaInsets.top)
    }
}

#Preview {
    NavigationTopBarView()
}
