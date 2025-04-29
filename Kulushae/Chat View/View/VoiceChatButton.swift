//
//  VoiceChatButton.swift
//  Kulushae
//
//  Created by ios on 07/02/2024.
//

import SwiftUI
import AVFoundation

struct VoiceChatButton: View {
    @State private var isRecording = false
    @State private var audioRecorder: AVAudioRecorder?
    @State private var fileName: String?

    var body: some View {
        Button(action: {
            // Cancel recording on release if already recording
            if isRecording {
                endRecording()
            }
        }) {
            Text(isRecording ? "Recording..." : "Hold to Talk")
        }
        .foregroundColor(.white)
        .padding()
        .background(isRecording ? Color.red : Color.blue)
        .cornerRadius(10)
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.location.x < -50 {
                        cancelRecording()
                    }
                }
        )
        .simultaneousGesture( // Gesture to start recording on hold
            LongPressGesture(minimumDuration: 0.1)
                .onEnded { _ in
                    startRecording()
                }
        )
    }

    private func startRecording() {
        print("Recording started")
        isRecording = true

        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.record, mode: .default)
            try session.setActive(true)
        } catch {
            print("Error setting up recording session:", error)
            return
        }

        let settings = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderBitRateKey: 128000
        ]

        fileName = "\(UUID().uuidString).m4a"
        audioRecorder = try? AVAudioRecorder(url: URL(fileURLWithPath: fileName!), settings: settings)
        audioRecorder?.record()
    }

    private func endRecording() {
        print("Recording ended")
        isRecording = false

        audioRecorder?.stop()
        audioRecorder = nil

        print("Sent: \(fileName!)")
    }

    private func cancelRecording() {
        print("Recording cancelled")
        isRecording = false

        audioRecorder?.stop()
        audioRecorder = nil

        if let fileName = fileName {
            do {
                try FileManager.default.removeItem(at: URL(fileURLWithPath: fileName))
            } catch {
                print("Error removing cancelled recording:", error)
            }
        }
    }
}
