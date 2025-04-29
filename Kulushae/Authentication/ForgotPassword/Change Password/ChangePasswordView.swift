//
//  ChangePasswordView.swift
//  Kulushae
//
//  Created by ios on 19/10/2023.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @StateObject var dataHandler = ChangePasswordViewModel.ViewModel()
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isOpenHome: Bool = false
    
    var body: some View {
        UILoader(isShowing: dataHandler.isLoading) {
            ZStack {
                VStack {
                    NavigationTopBarView(titleVal: "Create New Password" )
                        .padding(.top, 70)
                    
                    ScrollView {
                        //MARK: Email  Selected
                        
                        VStack(spacing: -16) {
                            
                            CustomTextField(
                                text: $password,
                                placeholder: "New Password",
                                keyboardType: .default,
                                isSecure: true,
                                leadingImage: Image("ic_password"),
                                trailingImage: Image("eye_closed")
                            )
                            .padding()
                            
                            CustomTextField(
                                text: $confirmPassword,
                                placeholder: "Confirm Password",
                                keyboardType: .default,
                                isSecure: true,
                                leadingImage: Image("ic_password"),
                                trailingImage: Image("eye_closed")
                            )
                            .padding()
                        }
                        AppButton(titleVal: "Done", isSelected: .constant((password == confirmPassword) && (password != "")))
                            .padding(.top, 45)
                            .onTapGesture {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                dataHandler.changePassword(request: ChangePasswordViewModel.MakeChangePasswordRequest.Request(
                                    password: password)
                                )
                            }
                            .padding(.top, 25)
                            .disabled((password != confirmPassword) && (password != ""))
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
            
            
            NavigationLink("", destination: MainView(),
                           isActive: $isOpenHome)
            
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ChangePasswordView()
}
