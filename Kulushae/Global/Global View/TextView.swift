//
//  TextView.swift
//  Kulushae
//
//  Created by ios on 30/10/2023.
//

import SwiftUI

struct TextView: UIViewRepresentable {
    @Binding var text: String
 
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        return textView
    }
 
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}
