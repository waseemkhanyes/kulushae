//
//  TopProfileView.swift
//  Kulushae
//
//  Created by ios on 15/05/2024.
//

import SwiftUI

struct TopProfileView: View {
    @State var dataHandler: ProfileViewModel.ViewModel
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        HStack {
            //            ZStack(alignment: .bottomTrailing) {
            AsyncImage(url: URL(string: (Config.imageBaseUrl) + (dataHandler.userObject.image ?? ""))) { image in
                image
                    .resizable()
                    .frame(width: 100,  height: 100)
                    .cornerRadius(30)
                    .padding(.trailing, 22)
            } placeholder: {
                Image("default_property")
                    .resizable()
                    .frame(width: 100,  height: 100)
                    .cornerRadius(30)
                    .shadow(radius: 10)
                    .padding(.trailing, 15)
            }
            
            //                Button(action: {
            //                    isOpenImageChooseView = true
            //                }) {
            //                    Image("camera")
            //                        .resizable()
            //                        .foregroundColor(.white)
            //                        .frame(width: 25, height: 25)
            //                        .foregroundColor(.blue)
            //                        .padding(8)
            //                }
            //                .background(Color.black)
            //                .clipShape(
            //                    RoundedRectangle(cornerRadius: 15)
            //                )
            //            }
            
            VStack(alignment: .leading) {
                Spacer()
                Text((dataHandler.userObject.firstName ?? "" ) + " " +  (dataHandler.userObject.lastName ?? "" ))
                    .font(.roboto_20())
                    .font(.headline.weight(.semibold))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color.black)
                
                HStack(spacing: 1) {
                    Text(LocalizedStringKey("Member Since"))
                        .font(.roboto_14())
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    Text(" \(dataHandler.userObject.createdAt ?? "")")
                        .font(.roboto_14())
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.gray)
                    Spacer()
                }
                Spacer()
            }
        }
        .frame(height: 100)
        .padding(.top, 35)
    }
}
//
//#Preview {
//    TopProfileView()
//}
