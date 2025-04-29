//
//  ExtensionView.swift
//  Kulushae
//
//  Created by Waseem  on 12/11/2024.
//

import SwiftUI

struct TitleStyle: ViewModifier {

    var font: Font?
    var color: Color
    var alignment: TextAlignment
    var lineSpacing: CGFloat? = nil

    func body(content: Content) -> some View {
        if let lineSpacing = lineSpacing {
            content
                .foregroundStyle(color)
                .font(font)
                .lineSpacing(lineSpacing)
                .multilineTextAlignment(alignment)
        } else {
            content
                .foregroundStyle(color)
                .font(font)
                .multilineTextAlignment(alignment)
        }
        
    }
}

struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: Value = .zero

    static func reduce(value _: inout Value, nextValue: () -> Value) {
        _ = nextValue()
    }
}

extension View {
    
    func clearBackground() -> some View {
        self.modifier(ClearBackgroundViewModifier())
    }
    
    func cleanNavigation() -> some View {
        return self
            .navigationBarTitle("")
            .navigationTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
    }
    
    func cleanNavigationAndSafeArea() -> some View {
        return self
            .ignoresSafeArea()
            .cleanNavigation()
    }
    
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
          GeometryReader { geometryProxy in
            Color.clear
              .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
          }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
    
    func shadowColor(show: Bool = false) -> some View {
        background(
            Color.white
                .shadow(color: Color(hex: 0x494B4D, alpha: show ? 0.16 : 0), radius: 8, x: 0, y: 4)
                .ignoresSafeArea()
        )
    }
    
    func border(_ color: Color, width: CGFloat, cornerRadius radius: CGFloat, corners: UIRectCorner = .allCorners) -> some View {
        overlay(RoundedCorner(radius: radius, corners: corners).stroke(color, lineWidth: width))
    }
}

struct ClearBackgroundView: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

struct ClearBackgroundViewModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .background(ClearBackgroundView())
    }
}

extension View {
    
    func textStyle(font:Font? = Font.Roboto.Bold(of: 20), color: Color = Color(hex: 0x000000), alignments: TextAlignment = .leading, lineSpacings: CGFloat? = nil) -> some View {
        modifier(TitleStyle(font: font, color: color, alignment: alignments, lineSpacing: lineSpacings))
    }
}
