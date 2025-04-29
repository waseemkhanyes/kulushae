//
//  VideoPlayer.swift
//  Kulushae
//
//  Created by ios on 24/04/2024.
//

import Foundation
import SwiftUI
import AVKit

struct VideoPlayerContainer: UIViewControllerRepresentable {
    @Binding var isFirstLaunch: Bool
    
    class Coordinator: NSObject, AVPlayerViewControllerDelegate {
        var parent: VideoPlayerContainer
        var player: AVPlayer? // Store the player as a property
        
        init(parent: VideoPlayerContainer) {
            self.parent = parent
        }
        
        func playerViewControllerDidDismiss(_ playerViewController: AVPlayerViewController) {
            // Set isFirstLaunch to false only if it was true (first launch)
            if parent.isFirstLaunch {
                parent.isFirstLaunch = false
                //                UserDefaults.standard.set(true, forKey: "isFirstLaunch")
                UserDefaults.standard.set(false, forKey: "isFirstLaunch")
            }
        }
        
        @objc func playerDidFinishPlaying() {
            // Set isFirstLaunch to false only if it was true (first launch)
            if parent.isFirstLaunch {
                parent.isFirstLaunch = false
                //                UserDefaults.standard.set(true, forKey: "isFirstLaunch")
                UserDefaults.standard.set(false, forKey: "isFirstLaunch")
            }
            player?.pause()
            player?.currentItem?.seek(to: .zero, completionHandler: nil)
            player?.volume = 0.0
        }
    }
    
    var coordinator: Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let player = AVPlayer(url: Bundle.main.url(forResource: "splash", withExtension: "mp4")!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.delegate = coordinator
        context.coordinator.player = player
        playerViewController.showsPlaybackControls = false
        
        // Add an observer for when the video finishes playing
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: nil) { _ in
            player.seek(to: CMTime.zero) // Rewind the video to the beginning
            playerViewController.player?.pause()
            playerViewController.player?.volume = 0.0
            playerViewController.dismiss(animated: true)
            context.coordinator.playerDidFinishPlaying()
        }
        
        // Configure the AVPlayerLayer to fill the entire screen
        let viewController = UIViewController()
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = viewController.view.layer.bounds
        viewController.view.layer.addSublayer(playerLayer)
        
        // Add a "Skip" button
        let skipButtonTitle = LocalizedStringKey("Skip")
        let skipButton = UIButton(type: .custom)
        skipButton.setTitle(String(localized: "Skip"), for: .normal)
        skipButton.setTitleColor(.black, for: .normal)
        skipButton.addTarget(context.coordinator, action: #selector(Coordinator.playerDidFinishPlaying), for: .touchUpInside)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(skipButton)
        
        NSLayoutConstraint.activate([
            skipButton.topAnchor.constraint(equalTo: viewController.view.topAnchor, constant: 16),
            skipButton.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: -16)
        ])
        
        player.play() // Start playing the video
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
}
