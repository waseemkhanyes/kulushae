//
//  ExtensionScrollView.swift
//  Kulushae
//
//  Created by Waseem  on 07/11/2024.
//

import SwiftUI

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    static var defaultValue = CGFloat.zero
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

// A ScrollView wrapper that tracks scroll offset changes.
struct ObservableScrollView<Content>: View where Content : View {
    @Namespace var scrollSpace
    var axis: Axis.Set
    var showsIndicators: Bool
    @Binding var scrollOffset: CGFloat
    let content: (ScrollViewProxy) -> Content
    
    init(axis: Axis.Set = .vertical, showsIndicators :Bool = false, scrollOffset: Binding<CGFloat>, @ViewBuilder content: @escaping (ScrollViewProxy) -> Content) {
        _scrollOffset = scrollOffset
        self.axis = axis
        self.showsIndicators = showsIndicators
        self.content = content
    }
    
    var body: some View {
        ScrollView(axis, showsIndicators: showsIndicators) {
            ScrollViewReader { proxy in
                content(proxy).background(GeometryReader { geometryReader in
                    let offset = axis == .vertical ? -geometryReader.frame(in: .named(scrollSpace)).minY : -geometryReader.frame(in: .named(scrollSpace)).minX
                    Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self, value: offset)
                })
            }
        }
        .coordinateSpace(name: scrollSpace)
        .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
            scrollOffset = value
        }
    }
}

