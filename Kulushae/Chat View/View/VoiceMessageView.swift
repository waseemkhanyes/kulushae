import SwiftUI
import AVFoundation

struct VoiceMessageView: View {
    let audioURL: URL
    @State private var isPlaying = false
    @State private var player: AVPlayer?
    @State private var currentTime: Double = 0.0
    @State private var duration: Double = 0.0
    @State private var totalDuration: Double = 0.0
    @State private var isSeeking = false
    @State private var timeObserverToken: Any?
    var isSender: Bool = false

    var body: some View {
        HStack {
            Button(action: {
                if isPlaying {
                    player?.pause()
                } else {
                    playAudio()
                }
                isPlaying.toggle()
            }) {
                Image(systemName: isPlaying ? "pause.circle" : "play.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .foregroundColor(isSender ? .black : .white)
            }
            .padding(.vertical, 15)
            .padding(.leading, 10)

            Slider(value: $currentTime, in: 0...duration, onEditingChanged: { editing in
                if editing {
                    isSeeking = true
                } else {
                    isSeeking = false
                    seek(to: currentTime)
                }
            })
            .accentColor(isSender ? .black : .white)

            Text(timeString(time: isPlaying ? currentTime : totalDuration))
                .font(.system(size: 10))
                .padding(.trailing, 10)
                .foregroundColor(isSender ? .black : .white)
        }
        .background(RoundedRectangle(cornerRadius: 15)
            .fill(isSender ? Color.white : Color.blue))
        .shadow(color: .black.opacity(0.08), radius: 8, x: 8, y: 4)
        .frame(width: UIScreen.main.bounds.width - 180)
        .onAppear {
            print("** wk onAppear preparePlayer")
            preparePlayer()
        }
        .onDisappear {
            print("** wk onDisappear player pause")
            player?.pause()
        }
    }

    private func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try audioSession.setActive(true)
        } catch {
            print("Failed to set audio session category: \(error)")
        }
    }

    private func preparePlayer() {
        configureAudioSession() // Configure audio session

        // Remove previous observer if exists
        if let token = timeObserverToken {
            player?.removeTimeObserver(token)
            timeObserverToken = nil
        }

        // Check if file exists
        if !FileManager.default.fileExists(atPath: audioURL.path) {
            print("File does not exist at: \(audioURL.path)")
            return
        }

        let asset = AVAsset(url: audioURL)
        asset.loadValuesAsynchronously(forKeys: ["duration"]) {
            var error: NSError?
            let status = asset.statusOfValue(forKey: "duration", error: &error)
            DispatchQueue.main.async {
                if status == .loaded {
                    self.duration = asset.duration.seconds
                    self.totalDuration = self.duration
                    print("Audio duration: \(self.duration) seconds")
                } else {
                    print("Failed to load duration: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }

        let playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        player?.volume = 1.0

        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 100), queue: .main) { time in
            if !isSeeking {
                currentTime = time.seconds
            }

            if time.seconds >= duration - 0.5 {
                player?.pause()
                player?.seek(to: .zero)
                isPlaying = false
                print("** Audio stopped automatically")
            }
        }
    }

    private func playAudio() {
        print("Audio URL:", audioURL)
        player?.play()
    }

    private func seek(to time: Double) {
        player?.seek(to: CMTime(seconds: time, preferredTimescale: 100))
    }

    private func timeString(time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
}
