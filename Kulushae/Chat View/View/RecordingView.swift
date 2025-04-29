//
//  RecordingView.swift
//  Kulushae
//
//  Created by ios on 06/02/2024.
//

import SwiftUI
struct RecordingView: View {
    @State private var isRecording = false
       @State private var isSwiping = false

    // Replace with your recording functions
    private func startRecording() {
        print("start voice")
    }

    private func stopRecording() {
        print("stop voice")
    }
    var body: some View {
        
         
        ZStack {
            VStack {
                Button(action: {
                    isRecording.toggle()
                    isSwiping = false // Reset swipe state on button press
                    if isRecording {
                        startRecording()
                    } else {
                        stopRecording()
                    }
                }) {
                    Text(isRecording ? "Release to Send" : "Hold to Record")
                        .padding()
                        .background(
                            // Use appropriate colors and visual style
                            isRecording ? Color.red : Color.blue
                        )
                        .foregroundColor(.white)
                        .disabled(!isRecording) // Disable when recording
                }
            }
            .gesture(DragGesture()
                .onEnded { gesture in
                    if gesture.location.x < gesture.startLocation.x {
                        // Left swipe detected
                        print("Swiping")
                        // Implement your left swipe action here
                    }
                }
            )
        }
    }
}
