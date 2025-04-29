//
//  RegisterParentView.swift
//  Kulushae
//
//  Created by ios on 13/10/2023.
//

import SwiftUI
import Firebase
import FirebaseAuth
import CountryPicker

struct RegisterParentView: View {
    @StateObject var locationViewModel: LocationViewModel =  LocationViewModel()
    @Environment(\.dismiss) var dismiss
    @StateObject var dataHandler = RegisterViewModel.ViewModel()
    @EnvironmentObject var languageManager: LanguageManager
    @State var isEmailEnabled: Bool = true
    @State var isMobileEnabled: Bool = false
    @State private var lastName: String = ""
    @State private var firstName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var phone: String = ""
    @State var isOTPViewOpen: Bool = false
    @State private var showCountryPicker = false
    @State private var country: Country?
    
    var body: some View {
        
        UILoader(isShowing: dataHandler.isLoading) {
            VStack {
                if(isMobileEnabled) {
                    NavigationTopBarView(titleVal: "Create Account with Mobile" , isShowBAckButton :  false)
                        .padding(.top, 70)
                }
                if(isEmailEnabled) {
                    NavigationTopBarView(titleVal: "Create Account with Email", isShowBAckButton: false )
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
                    
                    //MARK: Email UI
                    
                    VStack(spacing: -16) {
                        CustomTextField(
                            text: $firstName,
                            placeholder: "First Name",
                            keyboardType: .default,
                            isSecure: false,
                            leadingImage: Image("icn_name"),
                            trailingImage: nil
                        )
                        .padding()
                        
                        CustomTextField(
                            text: $lastName,
                            placeholder: "Last Name",
                            keyboardType: .default,
                            isSecure: false,
                            leadingImage: Image("icn_name"),
                            trailingImage: nil
                        )
                        .padding()
                        if(isEmailEnabled) {
                            CustomTextField(
                                text: $email,
                                placeholder: "Email",
                                keyboardType: .emailAddress,
                                isSecure: false,
                                leadingImage: Image("icn_mail_closed"),
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
                    
                    
                    AppButton(titleVal: "Sign up", isSelected: .constant(!password.isEmpty))
                        .padding(.top, 60)
                        .onTapGesture {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            if(isEmailEnabled) {
                                if(isValidEmail(email)){
                                    dataHandler.registerEmailORMobile(request: RegisterViewModel.MakeRegistrationRequest.Request(
                                        lastName: lastName, firstName: firstName, email: email, password: password, phone: "", type: "email")
                                    )
                                } else {
                                    dataHandler.errorString = "Please enter valid Email ID"
                                }
                                
                            }
                            if(isMobileEnabled) {
                                dataHandler.isLoading = true
                                if(firstName == "") {
                                    dataHandler.errorString = "First Name Field is Required"
                                    return
                                }
                                if(firstName == "") {
                                    dataHandler.errorString = "Password Field is Required"
                                    return
                                }
                                dataHandler.checkUserAvailability(request: RegisterViewModel.MakeForgotPasswordRequest.Request(value: ("+"  + (country?.phoneCode ?? "971") +  phone), type: "phone", requestFrom: "register"))
                            }
                        }
                        .padding(.top, 35)
                        .disabled(password.isEmpty)
                    HStack(spacing: 3) {
                        Spacer()
                        Text(LocalizedStringKey("Already have an account?"))
                            .font(.roboto_14_thin())
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .foregroundColor( Color.black)
                        Text(LocalizedStringKey("Sign in"))
                            .font(.roboto_16_bold())
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .foregroundColor( Color.black)
                        
                        Spacer()
                    }
                    .onTapGesture {
                        dismiss()
                    }
                    
                    .padding(.top, 16)
                }
                
                .padding(.top, 25)
                .padding(.horizontal , 10)
                Spacer()
                
            }
            if(dataHandler.errorString != "") {
                TopStatusToastView(message: dataHandler.errorString,
                                   type: .error) {
                    dataHandler.errorString = ""
                }
            }
            if let isProfileComplete =  UserDefaults.standard.value(forKey: Keys.Persistance.isUserInfoFilled.rawValue) as? Bool  {
                if(isProfileComplete) {
                    NavigationLink("", destination: MainView(), isActive: $dataHandler.isSigningIn)
                } else {
                    NavigationLink("", destination: MissingProfileInfoView(), isActive: $dataHandler.isSigningIn)
                }
            } else {
                NavigationLink("", destination: MainView(), isActive: $dataHandler.isSigningIn)
            }
            
            NavigationLink("", destination: OTPView(password: password, fname: firstName, lName: lastName, phone:  ("+"  + (country?.phoneCode ?? "971") +  phone), verificationCode: dataHandler.verificationCode),
                           isActive: $dataHandler.isOTPViewOpen)
            .navigationBarBackButtonHidden(true)
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPred.evaluate(with: email)
    }
}

#Preview {
    RegisterParentView()
}
