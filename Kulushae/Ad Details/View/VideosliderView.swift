//
//  VideosliderView.swift
//  Kulushae
//
//  Created by ios on 22/11/2023.
//

import SwiftUI
import AVKit

struct VideoSlider: View {
     let videoURLs: [URL] // Provide an array of video URLs
    @State private var currentTab = 0
    @State private var isPlaying = false
    @State private var player = AVPlayer()

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            TabView(selection: $currentTab) {
                ForEach(0..<videoURLs.count) { index in
                    let videoURL = videoURLs[index]

                    VideoPlayer(player: player)
                        .onAppear {
                            playVideo(url: videoURL)
                        }
                        .onDisappear {
                            player.pause()
                        }
                        .onReceive(NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)) { _ in
                            playVideo(url: getNextVideo())
                        }
                        .frame(width: UIScreen.main.bounds.width, height: 250)
                        .cornerRadius(15)
                        .overlay(
                            VStack {
                                Spacer()
                                Button(action: {
                                    isPlaying.toggle()
                                    if isPlaying {
                                        player.play()
                                    } else {
                                        player.pause()
                                    }
                                }) {
                                    Image(systemName: isPlaying ? "pause" : "play")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 26, height: 26)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.black.opacity(0.5))
                                        .cornerRadius(13)
                                }
                                Spacer()
                            }
                            .padding(.bottom, 30)
                            , alignment: .center
                        )
                        .clipped()
                }
            }
            .tabViewStyle(PageTabViewStyle())

            HStack {
                Text(String(currentTab + 1) +  "/"  + String(videoURLs.count))
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(8)
                    .padding(.trailing, 10)
            }
            .padding(.bottom, 10)
        }
    }

    private func playVideo(url: URL) {
        player.replaceCurrentItem(with: AVPlayerItem(url: url))
        player.play()
        isPlaying = true
    }

    private func getNextVideo() -> URL {
        let nextIndex = (currentTab + 1) % videoURLs.count
        currentTab = nextIndex
        return videoURLs[nextIndex]
    }
}
