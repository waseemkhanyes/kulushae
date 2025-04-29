//
//  LoginUserView.swift
//  Kulushae
//
//  Created by ios on 10/10/2023.
//
import SwiftUI
import AuthenticationServices
import FirebaseAuth
import FBSDKLoginKit

struct LoginUserView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @Binding var isOpen: Bool
    @State var isLoginOpen: Bool = false
    @State var isRegisterOpen: Bool = false
    @State var isOpenTerms: Bool = false
    @State var isOpenPrivacy: Bool = false
    @StateObject var registerDataHandler = RegisterViewModel.ViewModel()
    @StateObject var loginDataHandler = LoginUserViewModel.ViewModel()
    @StateObject var authentication = Authentication()
    @State var type = "email"
    
    var body: some View {
        VStack() {
            Spacer()
            HStack {
                Spacer()
                
                Text(LocalizedStringKey("Login"))
                    .font(.roboto_24_bold())
                    .fontWeight(.bold)
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .foregroundColor(Color.black)
                Spacer()
            }
            .frame( height: 100)
            .overlay(){
                HStack{
                    Spacer()
                    Button(action: {
                        isOpen = false
                    }) {
                        Image(uiImage: UIImage(named: "close") ?? UIImage())
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.black)
                    }
                    .frame(width: 35 , height: 35)
                    .padding(.trailing, 15)
                }
                .frame( height: 100)
            }
           
            .cornerRadius(30, corners: [.topLeft, .topRight])
            .clipped()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    LoginSelectionButtons(titleVal: "Continue with Email", imageName: "mail_closed")
                        .onTapGesture {
                            isLoginOpen = true
                            type = "email"
                        }
                    LoginSelectionButtons(titleVal: "Continue with Phone Number", imageName: "phone")
                        .onTapGesture {
                            isLoginOpen = true
                            type = "phone"
                        }
                    //                    LoginSelectionButtons(titleVal: "Continue with Facebook", imageName: "facebook")
                    //
                    //                        .onTapGesture {
                    //                            self.signInWithFacebook()
                    //
                    //                        }
                    
                    
                    LoginSelectionButtons(titleVal: "Continue with Google", imageName: "google")
                        .onTapGesture {
                            Task {
                                do {
                                    try await authentication.googleOauth { idToken, email, displayName, lname in
                                        registerOrSignInUserWithServer(userIdentifier: idToken, email: email, fName: displayName, lName: lname, type: "google")
                                    }
                                } catch {
                                    print("Google login failed:", error)
                                }
                            }
                        }
                    
                    // need to update waseem
                    
//                    SignInWithAppleButton(.signIn) { request in // No arguments here
//                        request.requestedScopes = [.email, .fullName]
//                    } onCompletion: { result in  // Explicit onCompletion closure
//                        switch result {
//                        case .success(let authorization):
//                            print("success login")
//                            guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
//                                print("Invalid authorization credential")
//                                return
//                            }
//                            let userIdentifier = appleIDCredential.user
//                            let fName = appleIDCredential.fullName?.givenName
//                            let lName = appleIDCredential.fullName?.familyName
//                            let email  = appleIDCredential.email
//                            print("** wk apple userIdentifier: \(userIdentifier), fName: \(fName), lName: \(lName), email: \(email)")
//                            self.registerOrSignInUserWithServer(userIdentifier: userIdentifier, email: email, fName: fName, lName: lName, type: "apple")
//                        case .failure(let error):
//                            // Handle Apple sign-in error
//                            print("failure login")
//                            print("Apple sign-in failed: \(error)")
//                        }
//                    }
                    SignInWithAppleButton(.signIn) { request in
                                // Request full name and email
                                request.requestedScopes = [.fullName, .email]
                            } onCompletion: { result in
                                switch result {
                                case .success(let authorization):
                                    // Handle success: Extract user information
                                    handleAppleSignInSuccess(authorization: authorization)
                                    
                                case .failure(let error):
                                    // Handle error
                                    print("Apple Sign-In failed: \(error.localizedDescription)")
                                }
                            }
                    .signInWithAppleButtonStyle(.white) // Use plain white style
                    .frame(height: 40)
                    .accessibilityLabel("Sign In with Apple")
                    .overlay( // Apply custom button style (optional)
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.unselectedBorderColor, lineWidth: 1)
                    )
                    VStack(spacing: 3) {
                        HStack {
                            Text(LocalizedStringKey("By continuing, you agree to our"))
                                .font(.roboto_10())
                                .foregroundColor(.gray)
                                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            Button(action: {
                                isOpenTerms = true
                            }) {
                                Text(LocalizedStringKey("Terms of Service"))
                                    .font(.roboto_10())
                                    .bold()
                                    .foregroundColor(.black)
                                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            }
                            
                            Text(LocalizedStringKey("and"))
                                .font(.roboto_10())
                                .foregroundColor(.gray)
                                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                        }
                        HStack {
                            Text(LocalizedStringKey("acknowledge that you have read our"))
                                .font(.roboto_10())
                                .foregroundColor(.gray)
                                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            Button(action: {
                                isOpenPrivacy = true
                            }) {
                                Text(LocalizedStringKey("Privacy Policy"))
                                    .font(.roboto_10())
                                    .bold()
                                    .foregroundColor(.black)
                                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            }
                            
                            Text(LocalizedStringKey("to learn"))
                                .font(.roboto_10())
                                .foregroundColor(.gray)
                                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                        }
                        
                        Text(LocalizedStringKey("how we collect, use, and share your data."))
                            .font(.roboto_10())
                            .foregroundColor(.gray)
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                        
                    }
                    .padding(.top, 45)
                    
                    AppButton(titleVal: "New here? Sign Up", isSelected: .constant(true))
                        .padding(.top, 60)
                        .onTapGesture {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            isRegisterOpen = true
                        }
                }
                
            }
            .frame(width: .screenWidth * 0.85)
            .onAppear() {
                if(registerDataHandler.isSigningIn || loginDataHandler.isSigningIn ) {
                    isOpen = false
                }
            }
        }
        .background(Color.appBackgroundColor)
        .cornerRadius(40, corners: [.topLeft, .topRight])
        .clipped()
        .ignoresSafeArea()
        
        NavigationLink(destination: RegisterParentView(), isActive: $isRegisterOpen) {
            
        }
        NavigationLink(destination: LoginEmailPhoneView(type: type, isPresentedFromRegister: .constant(false)), isActive: $isLoginOpen) {
            
        }
        NavigationLink("", destination: LoginTermsAndConditionView(title: "Terms & Conditions", url: Config.termsAndConditionUrl),
                       isActive: $isOpenTerms)
        NavigationLink("", destination: LoginTermsAndConditionView(title: "Privacy Policy", url: Config.privacyURL),
                       isActive: $isOpenPrivacy)
        if let isProfileComplete =  UserDefaults.standard.value(forKey: Keys.Persistance.isUserInfoFilled.rawValue) as? Bool  {
//            if(isProfileComplete) {
                NavigationLink("", destination: MainView(),
                               isActive: .constant(registerDataHandler.isSigningIn || loginDataHandler.isSigningIn))
//            } else {
//                NavigationLink("", destination: MissingProfileInfoView(),
//                               isActive: .constant(registerDataHandler.isSigningIn || loginDataHandler.isSigningIn))
//            }
        } else {
            NavigationLink("", destination: MainView(),
                           isActive: .constant(registerDataHandler.isSigningIn || loginDataHandler.isSigningIn))
        }
        
    }
    
    func handleAppleSignInSuccess(authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            print("Invalid authorization credential")
            return
        }
        
        // Extract user details
        let userIdentifier = appleIDCredential.user
        let firstName = appleIDCredential.fullName?.givenName
        let lastName = appleIDCredential.fullName?.familyName
        var email = appleIDCredential.email ?? ""
        
        // Check if the email is from Apple's private relay service
        if email.contains("@privaterelay.appleid.com") {
            print("User is using Hide My Email: \(email)")
        } else {
            print("User's real email: \(email)")
        }
        
        // If email is empty, fallback to a default value (this usually won't happen unless the user chooses "Hide My Email" or there's some issue)
        if email.isEmpty {
            email = "\(userIdentifier)@apple.com"
        }
        
        print("User ID: \(userIdentifier)")
        print("Full Name: \(firstName ?? "No First Name") \(lastName ?? "No Last Name")")
        print("Email: \(email)")

        // Call a function to handle the server-side login or registration logic
//            self.registerOrSignInUserWithServer(userIdentifier: userIdentifier, email: email, firstName: firstName, lastName: lastName)
        self.registerOrSignInUserWithServer(userIdentifier: userIdentifier, email: email, fName: firstName, lName: lastName, type: "apple")
    }
    
    
    private func registerOrSignInUserWithServer(userIdentifier: String, email: String?, fName: String?, lName: String?, type: String) {
        registerDataHandler.checkUserAvailability(request: RegisterViewModel.MakeForgotPasswordRequest.Request(value: userIdentifier, type: type, requestFrom: "social media"))
        print("** wk error: \(registerDataHandler.errorString)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if self.registerDataHandler.errorString.isEmpty {
                print("** wk try to login")
                self.loginDataHandler.loginEmail(request: LoginUserViewModel.MakeLoginUserRequest.Request(
                    type: type,
                    id: userIdentifier
                ))
            } else {
                print("** wk try to register")
                self.registerDataHandler.registerEmailORMobile(request: RegisterViewModel.MakeRegistrationRequest.Request(lastName: lName, firstName: fName, email: email, type: type, id: userIdentifier))
                
            }
        }
    }
    
    func signInWithFacebook() {
        let premission = ["public_profile", "email"]
        let fbLoginManager = LoginManager()
        fbLoginManager.logIn(permissions: premission, from: UIHostingController(rootView: LoginUserView( isOpen: .constant(true)))) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                return
            }
            
            guard let _ = AccessToken.current else {
                print("Failed to get access token")
                return
            }
            
            if result?.isCancelled == true {
                print("User canceled")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
            
            
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    print("asd")
                    return
                }
                let nameComponents = user?.user.displayName?.components(separatedBy: " ")
                let fname = nameComponents?.first
                let lname = nameComponents?.last
                registerOrSignInUserWithServer(userIdentifier: user?.user.providerID ?? "", email: user?.user.email, fName: fname, lName: lname, type: "facebook")
                return
                
            })
        }
    }
}


struct LoginUserView_Previews: PreviewProvider {
    static var previews: some View {
        LoginUserView(isOpen: .constant(true))
    }
}
