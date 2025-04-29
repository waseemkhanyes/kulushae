//
//  LoginEmailPhoneView.swift
//  Kulushae
//
//  Created by ios on 12/10/2023.
//

import SwiftUI
import CountryPicker

struct LoginEmailPhoneView: View {
    
    @StateObject var locationViewModel: LocationViewModel =  LocationViewModel()
    @StateObject var dataHandler = LoginUserViewModel.ViewModel()
    @EnvironmentObject var languageManager: LanguageManager
    @State var type: String = "email"
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var password: String = ""
    @State var isOpenForgetPassword: Bool = false
    @Binding var isPresentedFromRegister: Bool
    @State var isSignupOpen: Bool = false
    @State private var showCountryPicker = false
    @State private var country: Country?
    
    var strTitle: String {
        var text = ""
        if type == "phone" {
            text = "Login with Mobile"
        } else if type == "email" {
            text = "Login with Email"
        }
        return text
    }
    
    var body: some View {
        UILoader(isShowing: dataHandler.isLoading) {
            
            VStack(spacing: 0) {
                if ["phone", "email"].contains(type) {
                    NavigationTopBarView(titleVal: strTitle)
                }
                
                ScrollView {
                    //MARK: Email Mobile choose
                    HStack {
                        Button(action: {
                            type = "email"
                        }) {
                            Text(LocalizedStringKey("Email"))
                                .font(.roboto_14())
                                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                .foregroundColor( type == "email" ? Color.white : Color.black)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 58, maxHeight: 58)
                                .background(type == "email" ? Color.iconSelectionColor : .clear)
                                .cornerRadius(15)
                                .clipped()
                        }
                        
                        Button(action: {
                            type = "phone"
                        }) {
                            Text(LocalizedStringKey("phone"))
                                .font(.roboto_14())
                                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                .foregroundColor(type == "phone" ? Color.white : Color.black)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 58, maxHeight: 58)
                                .background(type == "phone" ? Color.iconSelectionColor : .clear)
                                .cornerRadius(15)
                                .clipped()
                        }
                        
                    }
                    .frame(maxWidth: .infinity)
                    .overlay(RoundedRectangle(cornerRadius: 15)
                        .inset(by: 0.5)
                        .stroke(Color.selectedTextBackgroundColor, lineWidth: 1))
                    .padding(.horizontal, 15)
                    
                    //MARK: Email  Selected
                    
                    VStack(spacing: -16) {
                        if(type == "email") {
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
                        if(type == "phone") {
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
                        CustomTextField(
                            text: $password,
                            placeholder: "Password",
                            keyboardType: .default,
                            isSecure: true,
                            leadingImage: Image("ic_password"),
                            trailingImage: Image("eye_closed")
                        )
                        .padding()
                    }
                    AppButton(titleVal: "Sign in", isSelected: .constant(!password.isEmpty))
                        .padding(.top, 45)
                        .onTapGesture {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            dataHandler.loginEmail(request: LoginUserViewModel.MakeLoginUserRequest.Request(
                                email: email, password: password, phone: (type == "phone") ? ("+"  + (country?.phoneCode ?? "971") +  phone) : "", type: type )
                            )
                        }
                        .padding(.top, 25)
                        .disabled(password.isEmpty)
                    HStack(spacing: 3) {
                        Spacer()
                        Text(LocalizedStringKey("Forgot the password?"))
                            .font(.roboto_14_thin())
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .foregroundColor( Color.black)
                        Text(LocalizedStringKey("click here"))
                            .font(.roboto_16_bold())
                            .fontWeight(.heavy)
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .foregroundColor( Color.black)
                        
                        Spacer()
                    }
                    .onTapGesture {
                        isOpenForgetPassword = true
                    }
                    .padding(.top, 16)
                    
                    HStack(spacing: 3) {
                        Spacer()
                        Text(LocalizedStringKey("Don't have an account?"))
                            .font(.roboto_14_thin())
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .foregroundColor( Color.black)
                        Text(LocalizedStringKey("Sign up"))
                            .font(.roboto_16_bold())
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .foregroundColor( Color.black)
                        
                        Spacer()
                    }
                    .onTapGesture {
                        isSignupOpen = true
                    }
                    
                    .padding(.top, 16)
                }
                .padding(.top, 50)
                .padding(.horizontal, 20)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(Color.appBackgroundColor)
            
            if(dataHandler.errorString != "") {
                TopStatusToastView(message: dataHandler.errorString,
                                   type: .error) {
                    dataHandler.errorString = ""
                }
            }
            
            NavigationLink("", destination: MainView(),
                           isActive: $dataHandler.isSigningIn)
            
            NavigationLink("", destination: ForgotPasswordView(isEmailEnabled: (type == "email"), isMobileEnabled: (type == "phone")),
                           isActive: $isOpenForgetPassword)
            
            NavigationLink("", destination: RegisterParentView(),
                           isActive: $isSignupOpen)
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    LoginEmailPhoneView( isPresentedFromRegister: .constant(true))
}
