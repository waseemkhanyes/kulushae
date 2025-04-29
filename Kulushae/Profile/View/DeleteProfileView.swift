//
//  DeleteProfileView.swift
//  Kulushae
//
//  Created by ios on 22/05/2024.
//

import SwiftUI

struct DeleteProfileView: View {
    @StateObject var locationViewModel: LocationViewModel =  LocationViewModel()
    @Binding var isOpen: Bool
    @Binding var isDeleteClicked: Bool
    @EnvironmentObject var languageManager: LanguageManager
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image(uiImage: UIImage(named: "close") ?? UIImage())
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.black)
                    .onTapGesture(){
                        isOpen = false
                    }
            }
            .padding(.all, 22)
            
            Text(LocalizedStringKey("Are you sure you want to delete profile permanently?"))
                .font(.roboto_22_semi())
                .multilineTextAlignment(.center)
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                .foregroundColor(Color.black)
                .frame(height: 100)
                .padding(.all, 35)
            HStack() {
                AppButton(titleVal: "Yes, Delete my profile", isSelected: .constant(false))
                    .onTapGesture {
                        isOpen = false
                        isDeleteClicked = true
                    }
                Spacer()
                AppButton(titleVal: "No", isSelected: .constant(true))
                    .frame(width: 150)
                    .onTapGesture {
                        isOpen = false
                    }
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 25)
            
            Spacer()
        }
        
        .frame(width: .screenWidth)
        .background(Color.appBackgroundColor)
        .cornerRadius(40, corners: [.topLeft, .topRight])
        .clipped()
        .ignoresSafeArea()
    }
}
