//
//  ZoomableScrollView.swift
//  Kulushae
//
//  Created by ios on 18/12/2023.
//

import SwiftUI

struct ZoomableScrollView<Content: View>: UIViewRepresentable {
 private var content: Content

 init(@ViewBuilder content: () -> Content) {
   self.content = content()
 }

 func makeUIView(context: Context) -> UIScrollView {
   let scrollView = UIScrollView()
    scrollView.backgroundColor = .clear
   scrollView.delegate = context.coordinator
   scrollView.maximumZoomScale = 20
   scrollView.minimumZoomScale = 1
   scrollView.bouncesZoom = true

   let hostedView = context.coordinator.hostingController.view!
   hostedView.translatesAutoresizingMaskIntoConstraints = true
   hostedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
   hostedView.frame = scrollView.bounds
   scrollView.addSubview(hostedView)

   return scrollView
 }

 func makeCoordinator() -> Coordinator {
   return Coordinator(hostingController: UIHostingController(rootView: self.content))
 }

 func updateUIView(_ uiView: UIScrollView, context: Context) {
   context.coordinator.hostingController.rootView = self.content
   assert(context.coordinator.hostingController.view.superview == uiView)
 }

 class Coordinator: NSObject, UIScrollViewDelegate {
   var hostingController: UIHostingController<Content>

   init(hostingController: UIHostingController<Content>) {
     self.hostingController = hostingController
       self.hostingController.view.backgroundColor = .clear
   }

   func viewForZooming(in scrollView: UIScrollView) -> UIView? {
       hostingController.view.backgroundColor = .clear
     return hostingController.view
   }
 }
}
