//
//  SwitchOptionForCreateAdsFormView.swift
//  Kulushae
//
//  Created by Waseem  on 29/01/2025.
//

import SwiftUI

struct SwitchOptionForCreateAdsFormView: View {
    var title: String
    @State var isOn = false
    var handler: ((Bool)->())? = nil
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.black)
            
            Spacer()
            
            Toggle("" , isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: Color.iconSelectionColor))
                .onChange(of: isOn) { newValue in
                    handler?(newValue)
                }
        }
    }
}

#Preview {
    SwitchOptionForCreateAdsFormView(title: "")
}
