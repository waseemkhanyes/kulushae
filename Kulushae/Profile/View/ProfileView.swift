//
//  ProfileView.swift
//  Kulushae
//
//  Created by ios on 28/11/2023.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject var dataHandler = ProfileViewModel.ViewModel()
    @EnvironmentObject var languageManager: LanguageManager
    @State private var isOpenHome: Bool = false
    @State private var showAlertDelete = false
    @State private var showAlertLogout = false
    @State private var showingImagePicker = false
    @State private var uploadedImages: [MediaModel] = []
    @State private var isUploading = false
    @State var isEditProfileOpen: Bool = false
    @State private var imageSource: ImageSource = .notSelected
    @State var isOpenImageChooseView: Bool = false
    @State var isDeleteClicked: Bool = false
    @State var isOpenContactUs: Bool = false
    @State var isOpenMyProfile: Bool = false
    @State var isOpenMyAds: Bool = false
    @State var isOpenTerms: Bool = false
    
    @State private var showSupport = false
    var body: some View {
        UILoader(isShowing: dataHandler.isLoading) {
            ZStack() {
                VStack(alignment: .leading) {
                    //                    NavigationTopBarView(titleVal: "Profile", isShowBAckButton: false )
                    //                        .padding(.top, 70)
                    TopProfileSection
                    Divider()
                        .padding(.vertical, 40)
                        .padding(.horizontal, -20)
                    MyProfileSection
                    Spacer()
                }
                .padding(.horizontal, 20)
                .onAppear(){
                    if let userId = PersistenceManager.shared.loggedUser?.id {
                        dataHandler.getProfileDetails(request:
                                                        ProfileViewModel.GetProfileDetailsRequest.Request(
                                                            userId:  Int(userId) ?? -1))
                    }
                }
                
                //                .alert(isPresented: Binding<Bool>(
                //                    get: {
                //                        showAlertDelete
                //                    },
                //                    set: { newValue in
                //                        // Handle setting showAlertDelete and showAlertDeleteProperties if needed
                //                    })
                //                ) {
                //                    if showAlertDelete {
                //                        return Alert(
                //                            title: Text(LocalizedStringKey("Delete Account?"))
                //                                .font(.roboto_16_bold()),
                //                            message: Text(LocalizedStringKey("Are you sure you want to delete your account? This action cannot be undone."))
                //                                .font(.roboto_14()),
                //                            primaryButton: .destructive(
                //                                Text("Delete"),
                //                                action: {
                //                                    DeleteAccount()
                //                                }
                //                            ),
                //                            secondaryButton: .cancel{
                //                                showAlertDelete = false
                //                            }
                //                        )
                //                    }  else {
                //                        return Alert(title: Text(""), message: Text(""))
                //                    }
                //                }
                
                .sheet(isPresented: .constant(imageSource != .notSelected )) {
                    ImagePickerView( numOfSelectedPictures: uploadedImages.count, images: $uploadedImages, isUploading: $isUploading, fromView: "profile", typeKey: "USER_PROFILE_URL", sourceType: imageSource, chatId: "", pickerType: .constant("image"))
                        .onAppear() {
                            dataHandler.isLoading = isUploading
                        }
                }
                .onChange(of: uploadedImages) { image in
                    dataHandler.isLoading = true
                    if let userId = PersistenceManager.shared.loggedUser?.id {
                        dataHandler.updateUser(request: ProfileViewModel.UpdateUserDetailsRequest.Request(userId: Int(userId) ?? -1, image: image.first?.fileName ?? ""))
                        imageSource = .notSelected
                    }
                    
                }
                .onChange(of: isDeleteClicked) { isDelete in
                    if(isDelete) {
                        DeleteAccount()
                    }
                }
                
                BottomSheetView(isOpen: $showAlertDelete,
                                maxHeight: 400) {
                    DeleteProfileView( isOpen: $showAlertDelete, isDeleteClicked: $isDeleteClicked)
                    
                }.edgesIgnoringSafeArea(.all)
                    .frame(width: .screenWidth,
                           height: showAlertDelete ? .screenHeight   : 0.0,
                           alignment: .bottom)
                    .opacity(showAlertDelete ? 1.0 : 0.0)
                
                BottomSheetView(isOpen: $isOpenImageChooseView,
                                maxHeight: 250) {
                    ImageChooseView(selectedPicType: $imageSource, isOpen: $isOpenImageChooseView)
                    
                }.edgesIgnoringSafeArea(.all)
                    .frame(width: .screenWidth,
                           height: isOpenImageChooseView ? .screenHeight   : 0.0,
                           alignment: .bottom)
                    .opacity(isOpenImageChooseView ? 1.0 : 0.0)
            }
            .ignoresSafeArea()
            .background(isOpenImageChooseView ? Color.unselectedBorderColor : Color.white)
            .onAppear() {
                if let userId = PersistenceManager.shared.loggedUser?.id {
                    dataHandler.getAds(userId: Int(userId) ?? 0, page: 1)
                }
            }
        }
        .sheet(isPresented: $showSupport) {
            ZendeskSupportViewController(isPresented: $showSupport, name: PersistenceManager.shared.loggedUser?.firstName ?? "ios", email: PersistenceManager.shared.loggedUser?.email ?? "ios@cashgatetech.com")
        }
        NavigationLink("", destination: MainView(),
                       isActive: $isOpenHome)
        NavigationLink("", destination: MyProfileView(),
                       isActive: $isOpenMyProfile)
        NavigationLink("", destination: MyAdsView(),
                       isActive: $isOpenMyAds)
        NavigationLink("", destination: ContactUsView(),
                       isActive: $isOpenContactUs)
        NavigationLink("", destination: ProfileEditView( dataHandler: dataHandler),
                       isActive: $isEditProfileOpen)
        NavigationLink("", destination: TermsAndConditionView(title: "Terms & Conditions", url: Config.termsAndConditionUrl),
                       isActive: $isOpenTerms)
        .navigationBarBackButtonHidden(true)
        
    }
    
    @ViewBuilder private var TopProfileSection: some View {
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
                //                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                
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
        .padding(.top, 100)
    }
    
    @ViewBuilder private var MyProfileSection: some View {
        //        HStack {
        //            Spacer()
        //            Button(action: {
        //                isEditProfileOpen = true
        //            }) {
        //                Image("pencil")
        //
        //            }
        //        }
        //        .padding(.all, 10)
        ScrollView {
            VStack(spacing: 25) {
                
                //                TextWithImageAndPlaceholderView(image: "icn_@",
                //                                                placeholder: "Email",
                //                                                value: ($dataHandler.userObject.email))
                //
                //                TextWithImageAndPlaceholderView(image: "icn_phone",
                //                                                placeholder: "Mobile",
                //                                                value: $dataHandler.userObject.phone)
                Button( action: {
                    isOpenMyProfile = true
                }) {
                    
                    Image("my_profile")
                        .foregroundColor(Color.gray)
                    Text(LocalizedStringKey("My Profile"))
                        .foregroundColor(Color.black)
                        .font(.roboto_16())
                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    Spacer()
                    Image("next_btn")
                }
                Button( action: {
                    isOpenMyAds = true
                }) {
                    
                    Image("my_ads")
                        .foregroundColor(Color.gray)
                    Text(LocalizedStringKey("My Ads"))
                        .foregroundColor(Color.black)
                        .font(.roboto_16())
                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                        .padding(.trailing, 15)
                    HStack(spacing: 5) {
                        Text(LocalizedStringKey("Total"))
                            .foregroundColor(Color.black)
                            .font(.roboto_16())
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                        Text(String(dataHandler.totalAdvCount))
                            .foregroundColor(Color.black)
                            .font(.roboto_16())
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    .overlay(RoundedRectangle(cornerRadius: 5.0).strokeBorder(.black.opacity(0.1), style: StrokeStyle(lineWidth: 1.0)))
                    Spacer()
                    Image("next_btn")
                }
                
                Button( action: {
                    isOpenTerms = true
                }) {
                    
                    Image("terms")
                        .foregroundColor(Color.gray)
                    Text(LocalizedStringKey("Terms & Conditions"))
                        .foregroundColor(Color.black)
                        .font(.roboto_16())
                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                        .padding(.trailing, 15)
                    Spacer()
                    Image("next_btn")
                }
                
                Button( action: {
                    showSupport = true
                }) {
                    
                    Image("icn_support")
                        .foregroundColor(Color.gray)
                    Text(LocalizedStringKey("Support"))
                        .foregroundColor(Color.black)
                        .font(.roboto_16())
                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                        .padding(.trailing, 15)
                    Spacer()
                    Image("next_btn")
                }
                
                Button( action: {
                    isOpenContactUs = true
                }) {
                    
                    Image("icn_call")
                        .foregroundColor(Color.gray)
                    Text(LocalizedStringKey("Contact Us"))
                        .foregroundColor(Color.black)
                        .font(.roboto_16())
                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                        .padding(.trailing, 15)
                    Spacer()
                    Image("next_btn")
                }
                
                
                HStack {
                    Image("logout")
                        .foregroundColor(Color.gray)
                    Text(LocalizedStringKey("Sign out"))
                        .foregroundColor(Color.black)
                        .font(.roboto_16())
                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    Spacer()
                    
                }
                .padding(.vertical, 25)
                .onTapGesture {
                    logOut()
                }
                
                HStack {
                    Image("delete")
                        .resizable()
                        .frame(width: 20, height: 23)
                        .foregroundColor(.gray)
                    Text(LocalizedStringKey("Delete Account"))
                        .foregroundColor(Color.black)
                        .font(.roboto_16())
                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                        .onTapGesture {
                            DispatchQueue.main.async {
                                showAlertDelete = true
                            }
                        }
                    Spacer()
                    
                }
                .padding(.top, 10)
                .onTapGesture {
                    DispatchQueue.main.async {
                        showAlertDelete = true
                    }
                }
                
            }
        }
        .padding(.bottom, -75)
    }
    
    func logOut() {
        dataHandler.isLoading = true
        PersistenceManager.shared.logout()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            dataHandler.isLoading = false
            isOpenHome = true
        }
    }
    
    func DeleteAccount() {
        dataHandler.isLoading = true
        dataHandler.deleteUser()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            dataHandler.isLoading = false
            isOpenHome = true
            showAlertDelete = false
            PersistenceManager.shared.logout()
        }
    }
}

#Preview {
    ProfileView()
}
