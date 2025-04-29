//
//  MissingProfileInfoView.swift
//  Kulushae
//
//  Created by ios on 29/04/2024.
//

import SwiftUI

struct MissingProfileInfoView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var languageManager: LanguageManager
    @State var isOpenProfileEdit: Bool = false
    @StateObject var dataHandler = ProfileViewModel.ViewModel()
    //    let goHome: () -> Void
    var body: some View {
        
        VStack {
            VStack {
                NavigationTopBarView(titleVal: "" )
                    .padding(.top, 70)
                Image("Sad_alt")
                    .padding(.top, 40)
                
                Text(LocalizedStringKey("We’re sorry to fetch your information, please initiate it manually"))
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .font(.roboto_24_bold())
                    .padding(.all, 20)
            }
            .frame(width: .screenWidth, height: 400)
            .background(Color.customColor(hex: 0x32688A))
            Spacer()
            VStack(spacing: 15) {
                let fname = PersistenceManager.shared.loggedUser?.firstName ?? ""
                let lname = PersistenceManager.shared.loggedUser?.lastName ?? ""
                if fname == "" {
                    profileInfo(image: "icn_name", title: "First Name")
                }
                if lname == "" {
                    profileInfo(image: "icn_name", title: "Last Name")
                }
                let email = PersistenceManager.shared.loggedUser?.email ?? ""
                if   email == "" {
                    profileInfo(image: "icn_mail_opened", title: "Email")
                }
                let phone = PersistenceManager.shared.loggedUser?.phone ?? ""
                if   phone == "" {
                    profileInfo(image: "icn_phone", title: "Phone")
                }
                
            }
            .padding(.horizontal, 20)
            Spacer()
            AppButton(titleVal: "Complete your profile", isSelected: .constant(true))
                .padding(.horizontal, 25)
                .padding(.bottom, 25)
                .onTapGesture {
                    isOpenProfileEdit = true
                }
        }
        .frame(width: .screenWidth, height: .screenHeight)
        .background(Color.white)
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(false)
        .onAppear() {
            if let userId = PersistenceManager.shared.loggedUser?.id {
                dataHandler.getProfileDetails(request:
                                                ProfileViewModel.GetProfileDetailsRequest.Request(
                                                    userId:  Int(userId) ?? -1))
            }
        }
        
        NavigationLink("", destination:  ProfileEditView(dataHandler: dataHandler, fromView: "MissingView"),
                       isActive: $isOpenProfileEdit)
        .navigationBarBackButtonHidden(true)
        
    }
}

struct profileInfo: View {
    @EnvironmentObject var languageManager: LanguageManager
    var image: String = ""
    var title: String = ""
    var body: some View {
        HStack {
            HStack() {
                Image(image)
                    .frame(width: 15)
                Text(LocalizedStringKey(title))
                    .foregroundColor(.black)
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .font(.roboto_14())
            }
            Spacer()
            HStack {
                Image("info")
                Text(LocalizedStringKey("Missing"))
                    .foregroundColor(.black)
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .font(.roboto_14())
            }
        }
        .padding(.horizontal, 25)
    }
    
}

//struct MissingProfileInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        MissingProfileInfoView()
//    }
//}
