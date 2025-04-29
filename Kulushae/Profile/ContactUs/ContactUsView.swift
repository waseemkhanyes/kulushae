//
//  ContactUsView.swift
//  Kulushae
//
//  Created by ios on 21/12/2023.
//

import SwiftUI

struct ContactUsView: View {
    
    @EnvironmentObject var languageManager: LanguageManager
    @State var isMessageEnabled: Bool = false
    @State var isInfoEnabled: Bool = true
    @State var firstName = ""
    @State var lastName = ""
    @State var emil = ""
    @State var phone = ""
    @State var message = ""
    @State private var showAlert = false
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                NavigationTopBarView(titleVal: "Contact Us")
                    
                SelectionSection
                    .padding(.horizontal, 15)
                
                ScrollView {
                    if(isInfoEnabled) {
                        InfoSection
                            .padding(.top, 30)
                    }
                    if(isMessageEnabled) {
                        MessageSection
                            .padding(.vertical, 20)
                    }
                }
                Spacer()
            }
            .cleanNavigationAndSafeArea()
            .alert(isPresented: $showAlert) {
                Alert(title:
                        Text(LocalizedStringKey("Message Sent")),
                      message: Text(LocalizedStringKey("We will contact you soon. Thank you")))
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    @ViewBuilder private var SelectionSection: some View {
        
        HStack {
            Button(action: {
                isMessageEnabled = false
                isInfoEnabled = true
            }) {
                Text(LocalizedStringKey("Company Info"))
                    .font(.roboto_14())
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .foregroundColor(isInfoEnabled ? Color.white : Color.black)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                    .background(isInfoEnabled ? Color.iconSelectionColor : .clear)
                    .cornerRadius(15)
                    .clipped()
            }
            
            Button(action: {
                isInfoEnabled = false
                isMessageEnabled = true
            }) {
                Text(LocalizedStringKey("Send us Message"))
                    .font(.roboto_14())
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .foregroundColor(isMessageEnabled ? Color.white : Color.black)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                    .background(isMessageEnabled ? Color.iconSelectionColor : .clear)
                    .cornerRadius(15)
                    .clipped()
            }
            
        }
        .frame(maxWidth: .infinity)
        .overlay(RoundedRectangle(cornerRadius: 15)
            .inset(by: 0.5)
            .stroke(Color.unselectedBorderColor, lineWidth: 1))
        .padding(.top, 15)
    }
    
    @ViewBuilder private var InfoSection: some View {
        VStack(alignment: .leading, spacing: 15 ) {
            Text(LocalizedStringKey("Phone"))
                .font(.roboto_14())
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                .foregroundColor(.gray)
            Button(action: {
                if let phoneURL = URL(string: "tel://\(00971523484323)") {
                    UIApplication.shared.open(phoneURL)
                } else {
                    // Handle the case where the URL cannot be created
                    print("Unable to create phone call URL.")
                }
            }) {
                Text("+971-523484323")
                    .font(.roboto_14())
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .foregroundColor(Color.black)
            }
            Text(LocalizedStringKey("Email"))
                .font(.roboto_14())
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                .foregroundColor(.gray)
                .padding(.top, 25)
            Button(action: {
                if let url = URL(string: "mailto:info@cashgatetech.com") {
                    UIApplication.shared.open(url)
                } else {
                    // Handle the case where the URL cannot be created
                    print("Unable to create mail URL.")
                }
            }) {
                Text("info@cashgatetech.com")
                    .font(.roboto_14())
                    .foregroundColor(Color.black)
            }
            Text(LocalizedStringKey("Address"))
                .font(.roboto_14())
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                .foregroundColor(.gray)
                .padding(.top, 25)
            Text("1001, U-bora Office Tower, \nMarasi Drive, Business Bay, Dubai")
                .font(.roboto_14())
                .foregroundColor(Color.black)
        }
        .padding(.leading, 30)
    }
    
    @ViewBuilder private var MessageSection: some View {
        ScrollView {
            VStack() {
                KulushaeActionFields(placeholder: "First Name" ,
                                     fieldType: .textVal,
                                     imageName: "icn_name",
                                     selectedDate: .constant(""),
                                     items: [],
                                     textValue: firstName ,
                                     textViewTitle: "",
                                     isEnableExtraTitle:  false ,
                                     isDatePickerShowing: .constant(false),
                                     index: 0,
                                     didGetValue: { index, actionValue, _ , _ in
                    firstName = actionValue
                    
                })
                .keyboardType(.default)
                
                KulushaeActionFields(placeholder: "Last Name" ,
                                     fieldType: .textVal,
                                     imageName: "icn_name",
                                     selectedDate: .constant(""),
                                     items: [],
                                     textValue: lastName,
                                     textViewTitle: "",
                                     isEnableExtraTitle:  false ,
                                     isDatePickerShowing: .constant(false),
                                     index: 0,
                                     didGetValue: { index, actionValue, _ , _ in
                    lastName = actionValue
                    
                })
                
                KulushaeActionFields(placeholder: "Email" ,
                                     fieldType: .textVal,
                                     imageName: "icn_mail_opened",
                                     selectedDate: .constant(""),
                                     items: [],
                                     textValue: emil,
                                     textViewTitle: "",
                                     isEnableExtraTitle:  false ,
                                     isDatePickerShowing: .constant(false),
                                     index: 0,
                                     didGetValue: { index, actionValue, _ , _ in
                    emil = actionValue
                    
                })
                KulushaeActionFields(placeholder: "Mobile",
                                     fieldType: .textVal,
                                     imageName: "icn_phone",
                                     selectedDate: .constant(""),
                                     items: [],
                                     textValue: "",
                                     textViewTitle: "",
                                     isEnableExtraTitle:  false,
                                     isDatePickerShowing: .constant(false),
                                     index: 0,
                                     didGetValue: { index, actionValue, _ , _ in
                    phone = actionValue
                })
                .keyboardType(.phonePad)
                
                KulushaeActionFields(placeholder: "Message",
                                     fieldType: .textVal,
                                     imageName: "",
                                     selectedDate: .constant(""),
                                     items: [],
                                     textValue: "",
                                     textViewTitle: message,
                                     isEnableExtraTitle:  true,
                                     isDatePickerShowing: .constant(false),
                                     index: 0,
                                     didGetValue: { index, actionValue, _ , _ in
                    
                    message = actionValue
                })
                
                AppButton(titleVal: "Submit", isSelected: .constant(true))
                    .onTapGesture {
                        showAlert = true
                    }
                    .padding(.all, 30)
            }
            .padding(.all, 15)
        }
    }
}


//#Preview {
//    ContactUsView()
//}
