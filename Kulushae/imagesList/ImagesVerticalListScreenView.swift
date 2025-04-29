//
//  ImagesVerticalListScreenView.swift
//  Kulushae
//
//  Created by Waseem  on 23/11/2024.
//

import SwiftUI
import Kingfisher

struct ImagesVerticalListScreenView: View {
    
//    @Binding var isFullscreen: Bool
    @Binding var images: [ImageModel]?
    
    @GestureState private var scale: CGFloat = 1.0
    
    @State private var currentTab = 0
    @State private var isFullScreenImagePresented: Bool = false
    
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    if let images = images {
                        ForEach(Array(images.enumerated()), id: \.element.id) { itemIndex, data in
                            KFImage(URL(string: (Config.imageBaseUrl) + (data.image ?? "")))
                                .placeholder {
                                    Image("default_property")
                                        .resizable()
                                        .frame(width: 100,  height: 100)
                                        .cornerRadius(25)
                                }
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity)
//                                .frame(height: 250)
                                .padding(.bottom, 10)
                                .onTapGesture {
                                    currentTab = itemIndex
                                    isFullScreenImagePresented = true
                                }
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $isFullScreenImagePresented) {
                NewFullScreenImageView(images: images, currentTab: currentTab)
            }
        }
    }
    
    private func isVisibleInScrollView(geometry: GeometryProxy) -> Bool {
        let frame = geometry.frame(in: .global)
        let visibleRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        return frame.intersects(visibleRect)
    }
}

//#Preview {
//    ImagesListView()
//}


//fileprivate struct NewFullScreenImageView: View {
//    let imageURL: URL
//    @Environment(\.dismiss) var dismiss
//    
//    var body: some View {
//        ZStack {
//            ZoomableScrollView {
//                KFImage(imageURL)
//                    .resizable()
//                    .scaledToFit()
//                    .id(UUID())
//            }
//            Button(action: {
//                dismiss()
//            }) {
//                Image(systemName: "xmark.circle.fill")
//                    .font(.largeTitle)
//                    .foregroundColor(Color.black.opacity(0.7))
//                    .padding()
//                    .clipShape(Circle())
//            }
//            .position(x: UIScreen.main.bounds.width - 40, y: 40) // Positioning close button
//        }
//    }
//}


fileprivate struct NewFullScreenImageView: View {
    
    var images: [ImageModel]?
    @State var currentTab = 0
    
    @GestureState private var scale: CGFloat = 1.0
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            VStack {
                GeometryReader { geometry in
                    ZStack(alignment: .bottomTrailing) {
                        TabView(selection: $currentTab) {
                            if let imageArray = images {
                                ForEach(Array(imageArray.enumerated()), id: \.offset) { index, image in
                                    ZoomableScrollView {
                                        
                                        KFImage(URL(string: (Config.imageBaseUrl) + (image.image ?? "")))
                                            .placeholder {
                                                Image("default_property")
                                                    .resizable()
                                                    .frame(width: geometry.size.width, height: 250)
                                                    .scaledToFill()
                                                    .clipped()
                                            }
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: geometry.size.width)
//                                            .scaledToFill()
                                            .clipped()
                                            .id(UUID())
                                    }
                                }
                            }
                        }
                        .tabViewStyle(PageTabViewStyle())
                        
                        HStack{
                            Text(String(currentTab + 1) + " / " + String(images?.count ?? 1))
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.black.opacity(0.5))
                                .cornerRadius(8)
                            
                            Image("icn_gallary")
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.black.opacity(0.5))
                                .cornerRadius(8)
                        }
                        .padding(.bottom, 10)
                    }
                }
                .onAppear {
                    setupAppearance()
                }
                Spacer()
                
            }
            
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(Color.black.opacity(0.7))
                    .padding()
                    .clipShape(Circle())
            }
            .position(x: UIScreen.main.bounds.width - 40, y: 40) // Positioning close button
        }
    }
    
    private func isVisibleInScrollView(geometry: GeometryProxy) -> Bool {
        let frame = geometry.frame(in: .global)
        let visibleRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        return frame.intersects(visibleRect)
    }
    
    func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .black
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
    }
}
