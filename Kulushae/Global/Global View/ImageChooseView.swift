//
//  ImageChooseView.swift
//  Kulushae
//
//  Created by ios on 08/12/2023.
//

import SwiftUI

struct ImageChooseView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @Binding var selectedPicType: ImageSource
    @Binding var isOpen: Bool
    @State var title = "Choose Image from"
    
    var body: some View {
        VStack(spacing: 25) {
           HStack {
                Spacer()
                Text(LocalizedStringKey(title))
                    .font(.roboto_22_semi())
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .foregroundColor(Color.black)
                    .padding(.vertical, 25)
                    .padding(.horizontal, 20)
                Spacer()
                Button(action: {
                    isOpen = false
                }) {
                    Image(uiImage: UIImage(named: "close") ?? UIImage())
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.black)
                }
                .frame(width: 35 , height: 35)
                .padding(.trailing, 16)
            }
            
            
            Button(action: {
                selectedPicType = .camera
                isOpen = false
            }) {
                Text(LocalizedStringKey("Take Photo"))
                    .font(.roboto_16_bold())
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .foregroundColor(Color.black)
            }
            
            Button(action: {
                selectedPicType = .gallery
                isOpen = false
            }) {
                Text(LocalizedStringKey("Upload from Gallery"))
                    .font(.roboto_16_bold())
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .foregroundColor(Color.black)
            }
            Spacer()
        }
        .frame(width: .screenWidth)
        .background(Color.appBackgroundColor)
        .cornerRadius(40, corners: [.topLeft, .topRight])
        .clipped()
        .ignoresSafeArea()
    }
}

//#Preview {
//    ImageChooseView()
//}

