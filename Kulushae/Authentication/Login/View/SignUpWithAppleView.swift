//
//  SignUpWithAppleView.swift
//  Kulushae
//
//  Created by ios on 25/04/2024.
//

import AuthenticationServices
import SwiftUI

struct SignUpWithAppleView: UIViewRepresentable {
    
    @Binding var name: String
    
    func makeCoordinator() -> AppleSignUpCoordinator {
        return AppleSignUpCoordinator(self)
    }
    
    func makeUIView(context: Context) -> UIView {
        // Create the custom button view
        let customButton = UIView()
        customButton.backgroundColor = .white
        customButton.layer.cornerRadius = 10
        customButton.layer.borderWidth = 1
        customButton.layer.borderColor = UIColor.black.cgColor
        
        // Create the Apple icon image view
        let appleIconImageView = UIImageView(image: UIImage(systemName: "applelogo")?.withRenderingMode(.alwaysTemplate))
        appleIconImageView.tintColor = .black
        appleIconImageView.contentMode = .scaleAspectFit
        
        // Create the Apple text label
        let appleTextLabel = UILabel()
        appleTextLabel.text = "Continue with Apple"
        appleTextLabel.textColor = .black
        appleTextLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        // Add subviews
        customButton.addSubview(appleIconImageView)
        customButton.addSubview(appleTextLabel)
        
        // Layout constraints
        appleIconImageView.translatesAutoresizingMaskIntoConstraints = false
        appleTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            appleIconImageView.leadingAnchor.constraint(equalTo: customButton.leadingAnchor, constant: 16),
            appleIconImageView.centerYAnchor.constraint(equalTo: customButton.centerYAnchor),
            appleIconImageView.widthAnchor.constraint(equalToConstant: 24),
            appleIconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            appleTextLabel.leadingAnchor.constraint(equalTo: appleIconImageView.trailingAnchor, constant: 16),
            appleTextLabel.trailingAnchor.constraint(equalTo: customButton.trailingAnchor, constant: -16),
            appleTextLabel.centerYAnchor.constraint(equalTo: customButton.centerYAnchor)
        ])
        
        // Create tap gesture
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(AppleSignUpCoordinator.didTapButton))
        customButton.addGestureRecognizer(tapGesture)
        
        return customButton
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
