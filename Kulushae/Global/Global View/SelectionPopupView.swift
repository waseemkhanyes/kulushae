//
//  SelectionPopupView.swift
//  Kulushae
//
//  Created by ios on 07/11/2023.
//

import Foundation
import SwiftUI

struct SelectionPopupView: View {
    @StateObject var locationViewModel: LocationViewModel =  LocationViewModel()
    @Binding var isOpen: Bool
    @EnvironmentObject var languageManager: LanguageManager
    @Binding var popupData: [AmenityList]
    @State var selectedItem: String = ""
    @Binding var selectedArray : [String]
    @Binding var selectedAmenityId : [String]
    @Binding var valueAmenity: String
    var body: some View {
        VStack {
            HStack {
                Text(LocalizedStringKey("Reset"))
                    .font(.roboto_14())
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .onTapGesture {
                        selectedArray = []
                    }
                Spacer()
                Image("tick")
                    .resizable()
                    .foregroundColor(.black)
                    .frame(width: 35, height: 35)
                    .onTapGesture() {
                        isOpen.toggle()
                    }
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 20)
            .padding(.top, 15)
            ScrollView {
                ForEach(popupData.chunked(into: 3), id: \.self) { chunk in
                    HStack(spacing: 10) {
                        ForEach(chunk, id: \.self) { item in
                            HStack {
                                MultiSelectionButton(titleVal: item.title , isSelected: .constant(selectedItem == item.title), selectedArray: $selectedArray)
                                    .onTapGesture {
                                        selectedAmenityId.append(item.id)
                                        valueAmenity = selectedAmenityId.joined(separator: ",")
                                        self.selectedItem = item.title
                                        selectedArray.append(item.title)
                                        print("** wk valueAmenity: \(valueAmenity), selectedAmenityId: \(selectedAmenityId), self.selectedItem: \(self.selectedItem), selectedArray: \(selectedArray)")
                                    }
                            }
                               
                        }
                    }
                    .padding(.horizontal, 15)
                }
                Spacer()
                    .frame(height: 150)
            }
            Spacer()
        }
        
        .background(Color.white)
        .onAppear() {
//            print("adefr", popupData.count, popupData)
        }

    }
    
}
