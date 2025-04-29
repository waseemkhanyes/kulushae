//
//  BottomSheetView.swift
//  Kulushae
//
//  Created by ios on 12/10/2023.
//

import SwiftUI

private enum BSVConstants {
    static let radius: CGFloat = 16
    static let indicatorHeight: CGFloat = 6
    static let indicatorWidth: CGFloat = 60
    static let snapRatio: CGFloat = 0.15
    static let minHeightRatio: CGFloat = 0.3
}

struct BottomSheetView<Content: View>: View {
    @Binding var isOpen: Bool
    
    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: Content
    
    @GestureState private var translation: CGFloat = 0
    
    private var offset: CGFloat {
        isOpen ? minHeight : maxHeight - minHeight
    }
    
    private var indicator: some View {
        RoundedRectangle(cornerRadius: BSVConstants.radius)
            .fill(Color.secondary)
            .frame(
                width: BSVConstants.indicatorWidth,
                height: BSVConstants.indicatorHeight
            ).onTapGesture {
                self.isOpen.toggle()
            }
    }
    
    init(isOpen: Binding<Bool>,
         maxHeight: CGFloat,
         @ViewBuilder content: () -> Content) {
        self.minHeight = 15
        self.maxHeight = maxHeight
        self.content = content()
        self._isOpen = isOpen
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(self.isOpen ? 0.2 : 0) // Adjust opacity as needed
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        // Dismiss the bottom sheet when tapping on the background
                        self.isOpen = false
                    }
//                    .blur(radius: self.isOpen ? 5 : 0) // Apply blur effect conditionally

                VStack(spacing: 0) {
                    self.content
                }
                .frame(width: geometry.size.width,
                       height: self.maxHeight,
                       alignment: .top)
                .background(Color.clear)
                .cornerRadius(40, corners: [.topLeft, .topRight])
                .clipped()
                .frame(height: geometry.size.height, alignment: .bottom)
                .offset(y: max(self.offset + self.translation, 0))
                .animation(.interactiveSpring())
                .gesture(
                    DragGesture().updating(self.$translation) { value, state, _ in
                        state = value.translation.height
                    }.onEnded { value in
                        let snapDistance = 120.0
                        guard abs(value.translation.height) > snapDistance else {
                            return
                        }
                        self.isOpen = value.translation.height < 0
                    }
                )
            }
        }
    }
}

//struct BottomSheetView_Previews: PreviewProvider {
//    @State static var isOpen: Bool = false
//    @State static var wayPointData: [WayPointData] = []
//
//    static var previews: some View {
//        BottomSheetView(isOpen: $isOpen,
//                        maxHeight: 1000) {
//            CorridorBottomView(wayPointData: $wayPointData, selectedWayPointIndex: .constant(0))
//        }.edgesIgnoringSafeArea(.all)
//    }
//}
