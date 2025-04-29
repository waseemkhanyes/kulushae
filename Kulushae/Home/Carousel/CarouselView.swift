//
//  CarouselView.swift
//  Kulushae
//
//  Created by Imran-Dev on 31/10/2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct CarouselView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @Binding var carList: [BannerModel]
    @Binding var isSelectedId: Int
    @Binding var selectedType: String
    @Binding var isSelected: Bool
    @Binding var isFavourite: Bool
    @Binding var isLoginSheetPresented: Bool
    @Binding var isFavClicked: Bool
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(carList.indices, id: \.self) { index in
                    Button {
                        selectedType = carList[index].type ?? ""
                        isSelected = true
                        isSelectedId = carList[index].id 
                    } label : {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack{
                                Spacer()
//                                self.cachedWebImage(urlString:  (Config.imageBaseUrl) + (carList[index].images?.first?.image ?? ""))
//                                    .clipped()
                                let url = (Config.imageBaseUrl) + (carList[index].image ?? "")
                                AsyncImage(url: URL(string:url )) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: .screenWidth*0.85, height: 144)
                                        .cornerRadius(15, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight])
                                        .clipped()
                                } placeholder: {
                                    Image("default_property")
                                        .resizable()
                                        .frame(width: .screenWidth*0.85, height: 144)
                                        .cornerRadius(15, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight])
                                }
                                Spacer()
                            }
                            
                            //                            Spacer()
                        }
                        
                        .frame(width: .screenWidth*0.85, height: 144)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.gray, lineWidth: 0.5)
                                .shadow(radius: 5)
                        )
                    }
                }
            }
        }
    }
}



