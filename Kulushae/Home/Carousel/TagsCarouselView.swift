//
//  TagsCarouselView.swift
//  Kulushae
//
//  Created by Imran-Dev on 31/10/2024.
//

import SwiftUI
import SwiftUI

struct TagsCarouselView: View {
    let items: [String] // Array of items to display in the carousel
    
    @State private var selectedItem: String? = nil // Track the selected item
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .padding(.horizontal, 15) // Adjust width dynamically based on text length
                        .padding(.vertical, 8)
                        .background(selectedItem == item ? Color.blue : Color.gray.opacity(0.3))
                        .foregroundColor(selectedItem == item ? .white : .black)
                        .font(selectedItem == item ? .headline : .body)
                        .cornerRadius(8)
                        .onTapGesture {
                            selectedItem = item // Update selected item
                        }
                }
            }
            .padding(.horizontal, 10)
            .frame(height: 50)
        }
    }
}
