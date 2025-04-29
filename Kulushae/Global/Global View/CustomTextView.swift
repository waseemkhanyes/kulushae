//
//  CustomTextView.swift
//  Kulushae
//
//  Created by ios on 13/10/2023.
//

import SwiftUI
import Combine

struct CustomTextField: View {
    @EnvironmentObject var languageManager: LanguageManager
    @Binding var text: String
    var placeholder: String
    var keyboardType: UIKeyboardType
    var isSecure: Bool
    var leadingImage: Image?
    var trailingImage: Image?
    
    @FocusState private var isFocused: Bool 
    
    @State private var showPassword = false
    
    private var borderColor: Color {
        isFocused ? .black : .unselectedTextBackgroundColor
    }
    
    private var imageToDisplay: Image {
        if showPassword {
            return Image("eye_opend")
        } else {
            return isSecure ? Image("eye_closed") : trailingImage ?? Image( "")
        }
    }
    
    private var secureText: String {
        return showPassword ? text : String(repeating: "•", count: text.count)
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(isFocused ? .unselectedTextBackgroundColor : .unselectedTextBackgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(borderColor, lineWidth: 1)
                )
            
            HStack {
                if let leadingImage = leadingImage {
                    leadingImage
                        .padding(.leading, 10)
                }
                
                if isSecure {
                    if showPassword {
                        TextField(LocalizedStringKey(placeholder), text: $text)
                            .font(.roboto_14())
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .keyboardType(keyboardType)
                            .focused($isFocused)
                            .onTapGesture {
                                isFocused = true
                            }
                            .foregroundColor(.black)
                    } else {
                        SecureField(LocalizedStringKey(placeholder), text: $text)
                            .font(.roboto_14())
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .keyboardType(keyboardType)
                            .focused($isFocused)
                            .onTapGesture {
                                isFocused = true
                            }
                            .foregroundColor(.black)
                    }
                } else {
                    TextField(LocalizedStringKey(placeholder), text: $text)
                        .font(.roboto_14())
                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                        .keyboardType(keyboardType)
                        .focused($isFocused)
                        .onTapGesture {
                            isFocused = true
                        }
                        .foregroundColor(.black)
                }
                
                Button(action: {
                    showPassword.toggle()
                }) {
                    imageToDisplay
                }
                .padding(.trailing, 10)
            }
            .frame(height: 50)
        }
        .onChange(of: showPassword) { newValue in
            if !isSecure {
                text = newValue ? "" : text
            }
        }
    }
}


