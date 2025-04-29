//
//  ProfileEditView.swift
//  Kulushae
//
//  Created by ios on 07/12/2023.
//

import SwiftUI
import AVFoundation
import _AVKit_SwiftUI
import CountryPicker
import Combine

struct ProfileEditView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var languageManager: LanguageManager
    @StateObject var dataHandler: ProfileViewModel.ViewModel
    @State private var showingImagePicker = false
    @State var firstName = ""
    @State var lastName = ""
    @State var phone = ""
    @State var email = ""
    @State var isOpenImageChooseView: Bool = false
    @State private var uploadedMedia: [MediaModel] = []
    @State private var isUploading = false
    @State private var imageSource: ImageSource = .notSelected
    @State var fromView: String = ""
    @State var openHome: Bool = false
    @State var errorMessage: String = ""
    @State private var showCountryPicker = false
    @State private var country: Country?
    @State var isKeyboardPresented: Bool = false
    
    var body: some View {
        UILoader(isShowing: dataHandler.isLoading) {
            ZStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 16) {
                    NavigationTopBarView(titleVal: "Edit Personal Details")
                    
                    VStack(spacing: 0) {
                        ScrollView {
                            
                            HStack {
                                Spacer()
                                ZStack(alignment: .bottomTrailing) {
                                    if($uploadedMedia.isEmpty) {
                                        AsyncImage(url: URL(string: (Config.imageBaseUrl) + (dataHandler.userObject.image ?? ""))) { image in
                                            image
                                                .resizable()
                                                .frame(width: 100,  height: 100)
                                                .cornerRadius(30)
                                                .padding(.trailing, 15)
                                            
                                        } placeholder: {
                                            Image("default_property")
                                                .resizable()
                                                .frame(width: 100,  height: 100)
                                                .cornerRadius(30)
                                                .padding(.trailing, 15)
                                        }
                                        
                                        Button(action: {
                                            isOpenImageChooseView = true
                                        }) {
                                            Image("camera")
                                                .resizable()
                                                .foregroundColor(.white)
                                                .frame(width: 25, height: 25)
                                                .foregroundColor(.blue)
                                                .padding(8)
                                        }
                                        .background(Color.iconSelectionColor)
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: 15)
                                        )
                                    }
                                    else {
                                        if let firstMedia = uploadedMedia.first {
                                            switch firstMedia.media {
                                            case .image(let image):
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .frame(width: 125, height: 125)
                                                    .cornerRadius(15)
                                                    .padding(.trailing, 15)
                                            case .video(let videoURL):
                                                VideoPlayer(player: AVPlayer(url: videoURL))
                                                    .frame(width: 125, height: 125)
                                                    .cornerRadius(15)
                                                    .padding(.trailing, 15)
                                            }
                                        } else {
                                            Image("default_property")
                                                .resizable()
                                                .frame(width: 125, height: 125)
                                                .cornerRadius(15)
                                                .padding(.trailing, 15)
                                        }
                                        
                                        Button(action: {
                                            isOpenImageChooseView = true
                                        }) {
                                            Image("camera")
                                                .resizable()
                                                .foregroundColor(.white)
                                                .frame(width: 25, height: 25)
                                                .foregroundColor(.blue)
                                                .padding(8)
                                        }
                                        .background(Color.black)
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: 15)
                                        )
                                    }
                                    
                                }
                                Spacer()
                            }
                            .padding(.all, 35)
                            
                            KulushaeActionFields(placeholder: "First Name" ,
                                                 fieldType: .textVal,
                                                 imageName: "icn_name",
                                                 selectedDate: .constant(""),
                                                 items: [],
                                                 textValue: dataHandler.userObject.firstName ?? "" ,
                                                 textViewTitle: "",
                                                 isEnableExtraTitle:  false ,
                                                 isDatePickerShowing: .constant(false),
                                                 index: 0,
                                                 didGetValue: { index, actionValue, _ , _ in
                                firstName = actionValue
                                
                            })
                            .keyboardType(.default)
                            .padding(.bottom, 15)
                            
                            KulushaeActionFields(placeholder: "Last Name" ,
                                                 fieldType: .textVal,
                                                 imageName: "icn_name",
                                                 selectedDate: .constant(""),
                                                 items: [],
                                                 textValue: dataHandler.userObject.lastName ?? "",
                                                 textViewTitle: "",
                                                 isEnableExtraTitle:  false ,
                                                 isDatePickerShowing: .constant(false),
                                                 index: 0,
                                                 didGetValue: { index, actionValue, _ , _ in
                                lastName = actionValue
                                
                            })
                            .padding(.bottom, 15)
                            KulushaeActionFields(placeholder: "Email" ,
                                                 fieldType: .textVal,
                                                 imageName: "icn_mail_opened",
                                                 selectedDate: .constant(""),
                                                 items: [],
                                                 textValue: dataHandler.userObject.email ?? "",
                                                 textViewTitle: "",
                                                 isEnableExtraTitle:  false ,
                                                 isDatePickerShowing: .constant(false),
                                                 index: 0,
                                                 didGetValue: { index, actionValue, _ , _ in
                                email = actionValue
                                
                            })
                            .disabled(!((dataHandler.userObject.email ?? "").isEmpty))
                            .padding(.bottom, 15)
                            
                            HStack(spacing:  10) {
                                ZStack(alignment: .leading) {
                                    HStack {
                                        Image("icn_phone")
                                            .fixedSize()
                                            .foregroundColor(Color.gray)
                                            .scaledToFit()
                                            .frame(width: 18,
                                                   alignment: .center)
                                        
                                        Button(action: {
                                            showCountryPicker = true
                                        }) {
                                            HStack {
                                                //                                            Text( country?.isoCode.getFlag() ?? "🇦🇪" )
                                                //                                                .frame(height: 50)
                                                //                                                .padding(.leading, 5)
                                                Text("+"  + (country?.phoneCode ?? "971"))
                                                    .font(.roboto_14())
                                                    .foregroundColor(.black)
                                                    .frame(height: 50)
                                                    .padding(.trailing, 5)
                                            }
                                            //                                        .background(Color.unselectedTextBackgroundColor)
                                            .frame(height: 50)
                                            .cornerRadius(10, corners: .allCorners)
                                            .clipped()
                                        }
                                        .sheet(isPresented: $showCountryPicker) {
                                            CountryPicker(country: $country)
                                        }
                                        VStack(alignment: .leading, spacing: 1) {
                                            Text(LocalizedStringKey("Mobile"))
                                                .foregroundColor(Color.gray)
                                                .font(.roboto_14())
                                                .scaleEffect(0.9, anchor: .leading)
                                                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                                .padding(.horizontal, -50)
                                                .background(.white)
                                                .offset(y:  -25)
                                            TextField(phone, text: $phone)
                                                .font(.roboto_14())
                                                .foregroundColor(.black)
                                            //                                            .frame(height: textValue.isEmpty ? 0.0 : nil)
                                                .offset(y: -10)
                                        }
                                    }
                                    
                                    
                                }
                            }
                            .padding(.all, 10)
                            .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .overlay(RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.unselectedBorderColor,
                                            lineWidth: 1))
                            )
                            
                            //                        HStack {
                            //
                            //                            KulushaeActionFields(placeholder: "Mobile",
                            //                                                 fieldType: .textVal,
                            //                                                 imageName: "icn_phone",
                            //                                                 selectedDate: .constant(""),
                            //                                                 items: [],
                            //                                                 textValue: "",
                            //                                                 textViewTitle: "",
                            //                                                 isEnableExtraTitle:  false,
                            //                                                 isDatePickerShowing: .constant(false),
                            //                                                 index: 0,
                            //                                                 didGetValue: { index, actionValue, _ , _ in
                            //                                phone = actionValue
                            //                            })
                            //                            .keyboardType(.phonePad)
                            //                        }
                            
                            
                            
                            
                            Spacer()
                                .frame(height: isKeyboardPresented ? 400 : 0)
                        }
                        AppButton(titleVal: "Save Changes", isSelected: .constant(true))
                            .onTapGesture {
                                if let userId = PersistenceManager.shared.loggedUser?.id {
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                    
                                    var newPhone = "\(country?.phoneCode ?? "971")\(phone)".replacingOccurrences(of: "+", with: "")
                                    
                                    dataHandler.updateUser(request: ProfileViewModel.UpdateUserDetailsRequest.Request(
                                        userId: Int(userId) ?? -1,
                                        image: uploadedMedia.first?.fileName ?? "",
                                        fName: firstName,
                                        lName: lastName,
                                        phone: newPhone,
                                        email: email
                                    ))
                                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                                        if(fromView == "MissingView") {
                                            openHome = true
                                        } else {
                                            dismiss()
                                        }
                                    }
                                }
                            }
                            .padding(.bottom, 50)
                    }
                    .padding(.horizontal, 15)
                    
                }
                .onChange(of: dataHandler.userObject) { newVal in
                    firstName = newVal.firstName ?? ""
                    lastName = newVal.lastName ?? ""
                    phone = newVal.phone ?? ""
                }
                .onChange(of: uploadedMedia) { image in
                    //                                    dataHandler.isLoading = true
                    //                                    if let userId = PersistenceManager.shared.loggedUser?.id {
                    //                                        dataHandler.updateUser(request: ProfileViewModel.UpdateUserDetailsRequest.Request(userId: Int(userId) ?? -1, image: image.first?.fileName ?? ""))
                    //                                    }
                    imageSource = .notSelected
                }
                .onAppear(){
                    if let userId = PersistenceManager.shared.loggedUser?.id {
                        dataHandler.getProfileDetails(request:
                                                        ProfileViewModel.GetProfileDetailsRequest.Request(
                                                            userId:  Int(userId) ?? -1))
                        firstName = dataHandler.userObject.firstName ?? ""
                        lastName = dataHandler.userObject.lastName ?? ""
                        phone = dataHandler.userObject.phone ?? ""
                    }
                }
                .sheet(isPresented: .constant(imageSource != .notSelected )) {
                    ImagePickerView( numOfSelectedPictures: uploadedMedia.count, images: $uploadedMedia, isUploading: $isUploading, fromView: "profile", typeKey: "CHAT_IMAGES_URL", sourceType: imageSource, chatId: nil, pickerType: .constant("image"))
                        .onAppear() {
                            dataHandler.isLoading = isUploading
                        }
                }
                .background( Color.appBackgroundColor )
                .blur(radius: isOpenImageChooseView ? 2 : 0)
                NavigationLink("", destination: MainView(),
                               isActive: $openHome)
                
                BottomSheetView(isOpen: $isOpenImageChooseView,
                                maxHeight: 250) {
                    ImageChooseView(selectedPicType: $imageSource, isOpen: $isOpenImageChooseView, title: "Edit Profile Photo")
                    
                }.edgesIgnoringSafeArea(.all)
                    .frame(width: .screenWidth,
                           height: isOpenImageChooseView ? .screenHeight  : 0.0,
                           alignment: .bottom)
                    .opacity(isOpenImageChooseView ? 1.0 : 0.0)
            }
            .onReceive(keyboardPublisher) { value in
                if isKeyboardPresented != value {
                    isKeyboardPresented = value
                }
            }
            //            .background(isOpenImageChooseView ? Color.unselectedBorderColor : Color.white)
            
            .navigationBarBackButtonHidden(true)
            if(errorMessage != "") {
                TopStatusToastView(message: errorMessage,
                                   type: .error) {
                    errorMessage = ""
                }
            }
        }
        
    }
    
    func isValidated() -> Bool {
        if(firstName == "") {
            errorMessage = "Enter first name"
            return false
        }
        if(email == "" && ((dataHandler.userObject.email ?? "").isEmpty)) {
            errorMessage = "Enter email"
            return false
        }
        return true
    }
}

extension View {
    
    var keyboardPublisher: AnyPublisher<Bool, Never> {
        Publishers
            .Merge(
                NotificationCenter
                    .default
                    .publisher(for: UIResponder.keyboardWillShowNotification)
                    .map { _ in true },
                NotificationCenter
                    .default
                    .publisher(for: UIResponder.keyboardDidHideNotification)
                    .map { _ in false })
            .debounce(for: .seconds(0.1), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}



