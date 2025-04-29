//
//  FullScreenImageView.swift
//  Kulushae
//
//  Created by ios on 18/10/2024.
//

import SwiftUI
import Kingfisher

struct FullScreenImageView: View {
    let imageURL: URL
    @Environment(\.dismiss) var dismiss 
    var body: some View {
        ZStack {
//            Color.black.edgesIgnoringSafeArea(.all) // Black background for better contrast
            ZoomableScrollView {
                
                KFImage(imageURL)
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .padding(.top, 150)
                    .id(UUID())
            }
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(Color.black.opacity(0.7))
                    .padding()
//                    .background(Color.black.opacity(0.7))
                    .clipShape(Circle())
            }
            .position(x: UIScreen.main.bounds.width - 40, y: 40) // Positioning close button
        }
    }
}
