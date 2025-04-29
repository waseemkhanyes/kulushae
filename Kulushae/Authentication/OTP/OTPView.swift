//
//  OTPView.swift
//  Kulushae
//
//  Created by ios on 16/10/2023.
//

import SwiftUI
import AEOTPTextField
import Firebase
import FirebaseAuth

struct OTPView: View {
    @StateObject var locationViewModel: LocationViewModel =  LocationViewModel()
    @Environment(\.dismiss) var dismiss
    @State var fromView = ""
    @State var password = ""
    @State var fname = ""
    @State var lName = ""
    @State var phone = "+971"
    @State private var otp = ""
    @State var verificationCode = ""
    @State private var isButtonEnabled = false
    @EnvironmentObject var languageManager: LanguageManager
    @State private var timer: Timer?
    @State private var remainingTime = 60 // Initial time in seconds
    @State private var isTimerRunning = false
    @StateObject var dataHandler = RegisterViewModel.ViewModel()
    @State var isChangePassword: Bool = false
    
    var body: some View {
        UILoader(isShowing: dataHandler.isLoading) {
            ZStack {
                VStack {
                    HStack {
                        ZStack {
                            Image( "back" )
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 17, height: 12, alignment: .center)
                                .clipped()
                                .padding(.leading, 15)
                        }
                        .frame(width: 35, height: 35)
                        .onTapGesture {
                            dismiss()
                            stopTimer()
                        }
                        Text(LocalizedStringKey("Validate OTP"))
                            .font(.roboto_22_semi())
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .foregroundColor(Color.black)
                            .padding(.leading, 10)
                        Spacer()
                    }
                    .padding(.top, 70)
                    
                    HStack {
                        Spacer()
                        Text(LocalizedStringKey("Code has been send to"))
                            .font(.roboto_14_thin())
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .foregroundColor( Color.black)
                        Text(maskPhoneNumber(phoneNumber: phone))
                            .font(.roboto_14())
                            .padding(.leading, 3)
                        Spacer()
                    }
                    .padding(.top , 50)
                    
                    AEOTPView(text: $otp) {
                        isButtonEnabled = true
                    }
                    .padding(.top , 52)
                    
                    if(isTimerRunning)  {
                        HStack {
                            Spacer()
                            Text(LocalizedStringKey("Resend code in"))
                                .font(.roboto_14_thin())
                                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                .foregroundColor( Color.black)
                            Text(String(remainingTime))
                                .font(.roboto_14())
                            Text(LocalizedStringKey("s"))
                                .font(.roboto_14_thin())
                                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                .foregroundColor( Color.black)
                                .padding(.leading, -3)
                            Spacer()
                        }
                        .padding(.top , 50)
                    } else {
                        Text(LocalizedStringKey("Resend code"))
                            .font(.roboto_16_bold())
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .foregroundColor( Color.black)
                            .onTapGesture {
                                DispatchQueue.main.async {
                                    PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { verificationID, error in
                                        if let error = error {
                                            dataHandler.errorString = error.localizedDescription
                                            dataHandler.isLoading = false
                                        } else if let verificationID = verificationID {
                                            self.verificationCode = verificationID
                                            dataHandler.errorString = "OTP has been sent to your phone number"
                                            startTimer()
                                        }
                                    }
                                }
                            }
                            .padding(.top , 50)
                    }
                    
                    AppButton(titleVal: "Verify", isSelected: $isButtonEnabled)
                    
                        .onTapGesture {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            if isButtonEnabled {
                                stopTimer()
                                // Perform your action, e.g., verifying the OTP.
                                let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationCode, verificationCode: otp)
                                //                            print("verificationCode in otp ", verificationCode , "\n", otp)
                                dataHandler.isLoading = true
                                Auth.auth().signIn(with: credential) { (authResult, error) in
                                    if let error = error {
                                        let authError = error as NSError
                                        dataHandler.errorString = authError.localizedDescription
                                        dataHandler.isLoading = false
                                        return
                                    }
                                    
                                    // User has signed in successfully and currentUser object is valid
                                    
                                    if(fromView == "forgot_password")  {
                                        isChangePassword = true
                                    } else {
                                        let currentUserInstance = Auth.auth().currentUser
                                        dataHandler.registerEmailORMobile(request: RegisterViewModel.MakeRegistrationRequest.Request(
                                            lastName: lName, firstName: fname, email: "", password: password, phone: phone, type: "phone")
                                        )
                                    }
                                }
                            }
                        }
                        .disabled(!isButtonEnabled)
                        .padding(.top, 50)
                        .padding(.horizontal, 48)
                    Spacer()
                    
                }
                .onAppear() {
                    startTimer()
                    dataHandler.isLoading = false
                }
                if(dataHandler.errorString != "") {
                    TopStatusToastView(message: dataHandler.errorString,
                                       type: .error) {
                        dataHandler.errorString = ""
                    }
                }
                NavigationLink("", destination: MainView(),
                               isActive: $dataHandler.isSigningIn)
                .navigationBarBackButtonHidden(true)
                
                NavigationLink("", destination: ChangePasswordView(),
                               isActive: $isChangePassword)
                
            }
            
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func startTimer() {
        isTimerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                stopTimer()
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        remainingTime = 60 // Reset the timer
        isTimerRunning = false
    }
    
    func maskPhoneNumber(phoneNumber: String) -> String {
        if phoneNumber.count <= 4 {
            return phoneNumber
        }
        
        let startIndex = phoneNumber.index(phoneNumber.startIndex, offsetBy: 3)
        let endIndex = phoneNumber.index(phoneNumber.endIndex, offsetBy: -2)
        let maskedPart = String(repeating: "*", count: phoneNumber.count - 5)
        let result = phoneNumber.replacingCharacters(in: startIndex..<endIndex, with: maskedPart)
        
        return result
    }
}

#Preview {
    OTPView()
}
