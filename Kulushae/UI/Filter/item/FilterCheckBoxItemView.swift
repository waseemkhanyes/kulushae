//
//  FilterCheckBoxItemView.swift
//  Kulushae
//
//  Created by Waseem  on 02/01/2025.
//

import SwiftUI

struct FilterCheckBoxItemView: View {
    @Binding var data: JSON
    
    var isSelected: Bool {
        data["selection"].boolValue
    }
    var body: some View {
        checkBoxView
    }
    
    var checkBoxView: some View {
        Button(action: {
            data["selection"] = isSelected ? "0" : "1"
        }) {
            HStack(spacing: 0) {
                Text(data["title"].stringValue)
                    .padding(.horizontal, 8)
                    .font(.Roboto.Medium(of: 16))
                    .foregroundColor(Color.black)
                
                Spacer()
                
                Image(isSelected ? "check_box" : "rectangle_white")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
        }
    }
}

#Preview {
    FilterCheckBoxItemView(data: .constant(JSON([:])))
}
