//
//  ImageSliderView.swift
//  Kulushae
//
//  Created by ios on 18/11/2023.
//

import SwiftUI
import Kingfisher

struct ImageSlider: View {
    
    @Binding var isFullscreen: Bool
    @Binding var images: [ImageModel]?
    @State private var currentTab = 0
    
    @GestureState private var scale: CGFloat = 1.0
    
    var body: some View {
        VStack {
            //            if(isFullscreen) {
            //                NavigationTopBarView(titleVal: "" )
            //                    .padding(.top, 30)
            //            }
            GeometryReader { geometry in
                ZStack(alignment: .bottomTrailing) {
                    TabView(selection: $currentTab) {
                        if let imageArray = images {
                            ForEach(Array(imageArray.enumerated()), id: \.offset) { index, image in
                                ZStack {
                                    KFImage(URL(string: (Config.imageBaseUrl) + (image.image ?? "")))
                                        .placeholder {
                                            Image("default_property")
                                                .resizable()
                                                .frame(width: geometry.size.width, height: 250)
                                                .scaledToFill()
//                                                .cornerRadius(15)
                                                .clipped()
                                        }
                                        .resizable()
                                        .frame(width: geometry.size.width, height: 250)
                                        .scaledToFill()
                                        .clipped()
                                        .blur(radius: 10)
                                    
                                    
                                    ZoomableScrollView {
                                        KFImage(URL(string: (Config.imageBaseUrl) + (image.image ?? "")))
                                            .placeholder {
                                                Image("default_property")
                                                    .resizable()
                                                    .frame(width: geometry.size.width, height: 250)
                                                    .scaledToFill()
    //                                                .cornerRadius(15)
                                                    .clipped()
                                            }
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: geometry.size.width, height: 250)
                                            
                                            .scaledToFill()
    //                                        .cornerRadius(15)
                                            .clipped()
                                            .id(UUID())
                                            .onTapGesture {
                                                isFullscreen = true
                                            }
                                    }
                                }
                                .frame(width: geometry.size.width, height: 250)
                            }
                        }
                        
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .onAppear {
                        setupAppearance()
                    }
                    
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
                            .onTapGesture {
                                isFullscreen = true
                            }
                    }
                    .padding(.bottom, 10)
                }
            }
            Spacer()
            
        }
        
        //        .navigationBarBackButtonHidden(true)
    }
    
    private func isVisibleInScrollView(geometry: GeometryProxy) -> Bool {
        let frame = geometry.frame(in: .global)
        let visibleRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        return frame.intersects(visibleRect)
    }
    
    func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .white
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.2)
    }
}

//struct ImageSlider_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageSlider()
//            .previewLayout(.fixed(width: .screenWidth, height: 300))
//    }
//}
