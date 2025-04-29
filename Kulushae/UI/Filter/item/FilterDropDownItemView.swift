//
//  FilterDropDownItemView.swift
//  Kulushae
//
//  Created by Waseem  on 02/01/2025.
//

import SwiftUI

struct FilterDropDownItemView: View {
//    var selectedOption: String = ""
    var data: JSON
    var handler: (()->())? = nil
    
    var title: String {
        data["title"].stringValue
    }
    var selectedOption: String {
        data["selection"]["name"].stringValue
    }
    var isSelected: Bool {
        !selectedOption.isEmpty
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            titleView
            
            dropDownView
        }
        .frame(maxWidth: .infinity)
    }
    
    var titleView: some View {
        Text(title)
            .font(.Roboto.Bold(of: 18))
            .foregroundStyle(.black)
            .padding(.bottom, 10)
    }
    
    var dropDownView: some View {
        Button(action: {
            handler?()
        }) {
            HStack(spacing: 10) {
                if isSelected {
                    Text(selectedOption)
                        .font(.Roboto.Medium(of: 16))
                        .foregroundStyle(.black.opacity(isSelected ? 1.0 : 0.54))
                        .padding(.leading, 10)
                } else {
                    Text(LocalizedStringKey("Select Option"))
                        .font(.Roboto.Medium(of: 16))
                        .foregroundStyle(.black.opacity(isSelected ? 1.0 : 0.54))
                        .padding(.leading, 10)
                }
                
//                Text(isSelected ? selectedOption : value)
//                    .font(.Roboto.Medium(of: 16))
//                    .foregroundStyle(.black.opacity(isSelected ? 1.0 : 0.54))
//                    .padding(.leading, 10)
                
                Spacer()
                
                Image(.downArrowIc)
                    .padding(.trailing, 10)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.black.opacity(0.54), lineWidth: 1)
            }
            
        }
    }
}

#Preview {
    FilterDropDownItemView(data: JSON([:]))
}
