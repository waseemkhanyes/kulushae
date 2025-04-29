//
//  ForgotPasswordView.swift
//  Kulushae
//
//  Created by ios on 14/10/2023.
//

import SwiftUI
import CountryPicker

struct ForgotPasswordView: View {
    @StateObject var dataHandler = RegisterViewModel.ViewModel()
    @EnvironmentObject var languageManager: LanguageManager
    @State var isEmailEnabled: Bool = true
    @State var isMobileEnabled: Bool = false
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var isOpenHome: Bool = false
    @State private var showCountryPicker = false
    @State private var country: Country?
    
    var body: some View {
        UILoader(isShowing: dataHandler.isLoading) {
            ZStack {
                VStack {
                    if(isMobileEnabled) {
                        NavigationTopBarView(titleVal: "Forgot password with Mobile"  )
                            .padding(.top, 70)
                    }
                    if(isEmailEnabled) {
                        NavigationTopBarView(titleVal: "Forgot password with Email" )
                            .padding(.top, 70)
                    }
                    
                    ScrollView {
                        //MARK: Email Mobile choose
                        HStack {
                            Button(action: {
                                isMobileEnabled = false
                                isEmailEnabled = true
                            }) {
                                Text(LocalizedStringKey("Email"))
                                    .font(.roboto_14())
                                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                    .foregroundColor(isEmailEnabled ? Color.white : Color.black)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 58, maxHeight: 58)
                                    .background(isEmailEnabled ? Color.iconSelectionColor : .clear)
                                    .cornerRadius(15)
                                    .clipped()
                            }
                            
                            Button(action: {
                                isEmailEnabled = false
                                isMobileEnabled = true
                            }) {
                                Text(LocalizedStringKey("Mobile"))
                                    .font(.roboto_14())
                                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                    .foregroundColor(isMobileEnabled ? Color.white : Color.black)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 58, maxHeight: 58)
                                    .background(isMobileEnabled ? Color.iconSelectionColor : .clear)
                                    .cornerRadius(15)
                                    .clipped()
                            }
                            
                        }
                        .frame(maxWidth: .infinity)
                        .overlay(RoundedRectangle(cornerRadius: 15)
                            .inset(by: 0.5)
                            .stroke(Color.unselectedBorderColor, lineWidth: 1))
                        .padding(.horizontal, 15)
                        
                        VStack(spacing: -16) {
                            
                            if(isEmailEnabled) {
                                CustomTextField(
                                    text: $email,
                                    placeholder: "Email",
                                    keyboardType: .emailAddress,
                                    isSecure: false,
                                    leadingImage: Image("icn_mail_opened"),
                                    trailingImage: nil
                                )
                                .padding()
                            }
                            if(isMobileEnabled) {
                                HStack {
                                    Button(action: {
                                        showCountryPicker = true
                                    }) {
                                        HStack {
                                            Text( country?.isoCode.getFlag() ?? "🇦🇪" )
                                                .frame(height: 50)
                                                .padding(.leading, 5)
                                            Text("+"  + (country?.phoneCode ?? "971"))
                                                .font(.roboto_14())
                                                .foregroundColor(.black)
                                                .frame(height: 50)
                                                .padding(.trailing, 5)
                                        }
                                        .background(Color.unselectedTextBackgroundColor)
                                        .frame(height: 50)
                                        .cornerRadius(10, corners: .allCorners)
                                        .clipped()
                                    }
                                    .sheet(isPresented: $showCountryPicker) {
                                        CountryPicker(country: $country)
                                    }
                                    CustomTextField(
                                        text: $phone,
                                        placeholder: "Phone",
                                        keyboardType: .phonePad,
                                        isSecure: false,
                                        leadingImage: Image(""),
                                        trailingImage: nil
                                    )
                                }
                                
                                .padding()
                            }
                            AppButton(titleVal: "Continue", isSelected: .constant(!((isEmailEnabled && email == "") || (isMobileEnabled && phone == "")) ))
                                .padding(.top, 60)
                                .onTapGesture {
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                    if(isEmailEnabled && email == "") {
                                        dataHandler.errorString = "Please enter email address"
                                        return
                                    }
                                    let request = RegisterViewModel.MakeForgotPasswordRequest.Request(
                                        value: isMobileEnabled ? ("+"  + (country?.phoneCode ?? "971") +  phone) : email.lowercased(),
                                        type: isEmailEnabled ? "email" : "phone", requestFrom: "forgotPassword")
                                    dataHandler.checkUserAvailability(request:request)
                                }
                                .padding(.top, 25)
                                .disabled((isEmailEnabled && email == "") || (isMobileEnabled && phone == "")) 
                        }
                        .padding(.top, 25)
                        .padding(.horizontal , 10)
                    }
                    .padding(.top, 50)
                    .padding(.horizontal, 20)
                    Spacer()
                }
                if(dataHandler.errorString != "") {
                    TopStatusToastView(message: dataHandler.errorString,
                                       type: .error) {
                        dataHandler.errorString = ""
                    }
                }
                
                if(dataHandler.successString != "") {
                    TopStatusToastView(message: dataHandler.successString,
                                       type: .success) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            dataHandler.successString = ""
                            isOpenHome = true
                        }
                    }
                }
            }
           
            
            NavigationLink("", destination: OTPView(fromView: "forgot_password", phone: ("+"  + (country?.phoneCode ?? "971") +  phone), verificationCode: dataHandler.verificationCode),
                           isActive: $dataHandler.isOTPViewOpen)
            
            NavigationLink("", destination: MainView(),
                           isActive: $isOpenHome)
            
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ForgotPasswordView()
}
