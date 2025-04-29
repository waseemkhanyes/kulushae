//
//  BrandsMotorMakesView.swift
//  Kulushae
//
//  Created by Waseem  on 10/11/2024.
//

import SwiftUI
import Kingfisher

struct BrandsMotorMakesView: View {
    var arrayMakes: [MotorMake]
    @EnvironmentObject var languageManager: LanguageManager
    var action: ((MotorMake)->())
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 14), count: 3), spacing: 15) {
                    ForEach(Array(arrayMakes.enumerated()), id: \.element.id) { itemIndex, item in
                        VStack(spacing: 0) {
                            KFImage(URL(string: (Config.imageBaseUrl) + (item.image)))
                                .placeholder {
                                    Image("default_property")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 62)
                                        .cornerRadius(15, corners: [.topLeft, .topRight])
                                        .clipped()
                                }
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                                .padding(.top, 15)
                            
                            
                            Spacer()
                            
                            Text(item.title)
                                .font(.roboto_14())
                                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.black)
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 3)
                                .padding(.bottom, 10)
                        }
                        .frame(height: 109)
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(hex: "#cccccc"), lineWidth: 1)
                        }
                        .onTapGesture {
                            action(item)
                        }
                    }
                }
                .padding(.horizontal, 18)
            }
        }
        .frame(maxHeight: .infinity)
    }
}

//#Preview {
//    BrandsMotorMakesView()
//}
