//
//  DropdownMenuView.swift
//  Kulushae
//
//  Created by ios on 21/12/2023.
//

import SwiftUI

struct DropdownMenuView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @State private var isMenuVisible = false
    let menuItems = ["Newest Ads", "Oldest Ads"]

    var body: some View {
        VStack {
            Image("filter_list")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(.black)
                .onTapGesture {
                        self.isMenuVisible.toggle()
                }

            if isMenuVisible {
                VStack {
                    ForEach(menuItems, id: \.self) { item in
                        Button(action: {
                            // Handle the action for the menu item
//                            print("Selected: \(item)")
                            self.isMenuVisible.toggle()
                        }) {
                            Text(LocalizedStringKey(item))
                                .font(.roboto_16_bold())
                                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                .foregroundColor(Color.black)
                                .padding()
                        }
                    }
                }
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 5)
                .padding()
            }
        }
    }
}

#Preview {
    DropdownMenuView()
}
