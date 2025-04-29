//
//  FormDropDownOptionsPopup.swift
//  Kulushae
//
//  Created by Waseem  on 21/12/2024.
//

import SwiftUI

struct FormDropDownOptionsPopup: View {
    var placeholder: String = "BedRoom"
    var items: [String] = []
    @EnvironmentObject var languageManager: LanguageManager
    @State var scrollContent: CGFloat = .zero
    var handler: ((String?)->())? = nil
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.2)
                .onTapGesture {
                    self.handler?(nil)
                }
            
            VStack(spacing: 0) {
                
                topView
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        itemslistView
                    }
                    .readSize { size in
                        scrollContent = size.height
                    }
                }
                .frame(height: scrollHeight())
            }
            .frame(maxWidth: .infinity)
            .background(
                Color.white
                    .cornerRadius(30, corners: [.topLeft, .topRight])
                    .ignoresSafeArea(edges: .bottom)
            )
        }
        .environment(\.layoutDirection, languageManager.layoutDirection)
        .cleanNavigationAndSafeArea()
    }
    
    var topView: some View {
        VStack(spacing: 0) {
            Text(LocalizedStringKey(placeholder))
                .font(.Roboto.Bold(of: 22))
                .frame(maxHeight: .infinity)
            
            Spacer()
                .frame(maxWidth: .infinity)
                .frame(height: 1)
                .background(.black.opacity(0.5))
        }
        .frame(height: 60)
    }
    
    func scrollHeight() -> CGFloat {
        let topHeader = 60.0
        let contentSize = topHeader + scrollContent
        let scrollHeight =  contentSize > screenHeight ? screenHeight - 60 : scrollContent
        return scrollHeight
    }
    
    var itemslistView: some View {
        VStack(spacing: 8) {
            ForEach(items, id:  \.self) { item in
//            ForEach(["1", "2", "3", "4", "5", "6", "7", "8", "9"], id: \.self) { item in
                Button(action: {
                    handler?(item)
                }) {
                    VStack {
                        Text(LocalizedStringKey(item))
                            .padding()
                            .foregroundColor(Color.black)
                            .font(.Roboto.Medium(of: 16))
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .frame(height: 40)
                        
                        Spacer()
                            .frame(height: 1)
                            .frame(maxWidth: .infinity)
                            .background(.black.opacity(0.3))
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
        .padding(.vertical, 20)
    }
}

#Preview {
    FormDropDownOptionsPopup()
        .environmentObject(LanguageManager())
}
