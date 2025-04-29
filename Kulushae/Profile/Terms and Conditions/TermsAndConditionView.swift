//
//  TermsAndConditionView\.swift
//  Kulushae
//
//  Created by ios on 22/12/2023.
//

import SwiftUI

struct TermsAndConditionView: View {
    var title = ""
    var url = ""
    var body: some View {
        VStack(alignment: .leading) {
            NavigationTopBarView(titleVal: title )
            
            WebView(url: URL(string: url)!)
                .edgesIgnoringSafeArea(.all)
        }
        .cleanNavigationAndSafeArea()
        .onAppear(){
            print("url si",url )
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct LoginTermsAndConditionView: View {
    var title = ""
    var url = ""
    @EnvironmentObject var languageManager: LanguageManager
    @State var isOpenHome = false
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ZStack {
                    Image("back" )
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 15, alignment: .center)
                        .clipped()
                        .scaleEffect(languageManager.currentLanguage == "ar" ? CGSize(width: -1, height: 1) : CGSize(width: 1, height: 1))
                }
                .frame(width: 35, height: 35)
                .onTapGesture {
                    isOpenHome = true
                }
                Text(LocalizedStringKey(title))
                    .font(.roboto_22_semi())
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .foregroundColor(Color.black)
                Spacer()
            }
            .padding(.top, 30)
            
            WebView(url: URL(string: url)!)
                .edgesIgnoringSafeArea(.all)
        }
        NavigationLink("", destination: MainView(isLoginOpen: true),
                       isActive: $isOpenHome)
        .navigationBarBackButtonHidden(true)
    }
}
