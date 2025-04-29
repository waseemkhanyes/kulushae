//
//  FilterDropDownOptionsPopup.swift
//  Kulushae
//
//  Created by Waseem  on 04/01/2025.
//

import SwiftUI

struct FilterDropDownOptionsPopup: View {
    @StateObject var viewModel: FilterDropDownViewModel
    @EnvironmentObject var languageManager: LanguageManager
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.2)
                .onTapGesture {
                    viewModel.onClickFreeArea()
                }
            
            VStack(spacing: 0) {
                
                topView
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        itemslistView
                    }
                    .readSize { size in
                            viewModel.scrollContent = size.height
                    }
                }
                .frame(height: scrollHeight())
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 30)
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
        ZStack(alignment: .trailing) {
            VStack(spacing: 0) {
                Text(viewModel.title)
                    .font(.Roboto.Bold(of: 22))
                    .frame(maxHeight: .infinity)
                
                Spacer()
                    .frame(maxWidth: .infinity)
                    .frame(height: 1)
                    .background(.black.opacity(0.5))
            }
            .frame(height: 60)
            
            Button(action: viewModel.onClickFreeArea) {
                VStack(spacing: 0) {
                    Image(.close)
                        .renderingMode(.template)
                        .foregroundStyle(.black)
                }
                .frame(width: 40, height: 40)
            }
            .padding(.trailing, 10)
        }
    }
    
    func scrollHeight() -> CGFloat {
        let topHeader = 60.0
        let contentSize = topHeader + viewModel.scrollContent
        let scrollHeight =  contentSize > screenHeight ? screenHeight - 60 : viewModel.scrollContent
        return scrollHeight
    }
    
    var itemslistView: some View {
        VStack(spacing: 8) {
            ForEach(viewModel.arrayOptions, id:  \.self.dictionaryValue["id"]?.intValue) { item in
//            ForEach(["1", "2", "3", "4", "5", "6", "7", "8", "9"], id: \.self) { item in
                Button(action: {
                    viewModel.onClickOption(item)
                }) {
                    VStack {
                        Text(item["name"].stringValue)
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
    FilterDropDownOptionsPopup(viewModel: .init(data: JSON([:])))
}
