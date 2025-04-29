//
//  UILoader.swift
//  Kulushae
//
//  Created by ios on 13/10/2023.
//

import SwiftUI

public struct UILoader<Content> : View where Content : View {
    
    public init(isShowing: Bool,
                enableThirdQuarterMode: Bool = false,
                @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.isShowing = isShowing
        self.animate = isShowing
        self.animate = isShowing
        self.enableThirdQuarterMode = enableThirdQuarterMode
    }
    
    var enableThirdQuarterMode: Bool = false
    var isShowing: Bool = false
    
    @State private var animate = false
    
    @Environment(\.colorScheme) private var colorScheme
    @ViewBuilder private var content: () -> Content
    
    public var body: some View {
        ZStack(alignment: .center) {
            content()
                .overlay(Rectangle()
//                    .foregroundColor(self.isShowing ? Color.black.opacity(0.5) : .clear))
                    .foregroundColor( .clear))
            
            VStack {
                ZStack {
                    Circle()
                        .fill(Color.appPrimaryColor)
                        .frame(width: 60, height: 60)
                        .scaleEffect(self.animate ? 0.25 : 1)
                    
                    Circle()
                        .fill(Color.unselectedBorderColor)
                        .frame(width: 40, height: 40)
                        .scaleEffect(self.animate ? 0.375 : 1)
                    
                    Circle()
                        .fill(Color.selectedTextBackgroundColor)
                        .frame(width: 20, height: 20)
                        .scaleEffect(self.animate ? 0.75 : 1)
                    
                    Circle()
                        .fill(Color.unselectedTextBackgroundColor)
                        .frame(width: 15, height: 15)
                    
                }
                .onAppear { self.animate = true }
                .animation(animate ? Animation
                    .easeInOut(duration: 1)
                    .repeatForever(autoreverses: true) : .default,
                           value: animate
                )
            }
            .opacity(isShowing ? 1.0 : 0.0)
            
        }
        .ignoresSafeArea()
    }
    
}

struct UILoader_Previews: PreviewProvider {
    static var previews: some View {
        UILoader(isShowing: true, enableThirdQuarterMode: true) {
            VStack {
                Spacer()
                Text("Hi").frame(width: .screenWidth)
                    .ignoresSafeArea()
            }.background(Color.appPrimaryColor)
        }
    }
}
