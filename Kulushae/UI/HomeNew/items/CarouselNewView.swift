//
//  CarouselNewView.swift
//  Kulushae
//
//  Created by Waseem  on 09/11/2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct CarouselNewView: View {
    @EnvironmentObject var languageManager: LanguageManager
    var carList: [BannerModel]
    
    @Binding var isSelectedId: Int
    @Binding var selectedType: String
    @Binding var isSelected: Bool
    
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

//#Preview {
//    CarouselNewView()
//}
