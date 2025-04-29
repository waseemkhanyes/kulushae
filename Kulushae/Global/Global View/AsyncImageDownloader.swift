//
//  AsyncImageDownloader.swift
//  Kulushae
//
//  Created by ios on 30/11/2023.
//

import SwiftUI

struct AsyncImageWithLoader: View {
    @State private var isLoading = true
    var imageUrl: String

    var body: some View {
        ZStack {
            if isLoading {
                ProgressView()
            }

            AsyncImage(url: URL(string: imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Image("default_property")
                    .resizable()
            }
            .onChange(of: imageUrl) { _ in
                isLoading = false
            }
        }
    }
}
