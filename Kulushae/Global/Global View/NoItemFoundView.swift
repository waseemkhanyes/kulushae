//
//  NoItemFoundView.swift
//  Kulushae
//
//  Created by ios on 03/06/2024.
//

import SwiftUI

struct NoItemFoundView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @Environment(\.dismiss) var dismiss
    @State var isShowBackButton = false
    
    var body: some View {
        VStack(alignment: .center) {
           Spacer()
            Image("icn_no_data")
            Text(LocalizedStringKey("No Data Available"))
                .font(.roboto_16_bold())
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                .foregroundColor(Color.black)
                .padding(.bottom)
            Text(LocalizedStringKey("There is no data to show you right now."))
                .font(.roboto_14())
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                .foregroundColor(Color.black)
                .padding(.bottom)
            if(isShowBackButton) {
                AppButton(titleVal: "Go Back", isSelected: .constant(true))
                    .onTapGesture {
                        dismiss()
                    }
                    .frame(width: 163,height: 50)
                    .padding()
            }
            
            Spacer()
        }
    }
}

#Preview {
    NoItemFoundView()
}
