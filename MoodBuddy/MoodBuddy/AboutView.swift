//
//  AboutView.swift
//  MoodBuddy
//
//  Created by Estefany Mendez on 8/21/25.
//

import SwiftUI
import AVFoundation

// Optional: reuse your Speech helper if you already have it elsewhere.
enum AboutSpeech {
    static let synth = AVSpeechSynthesizer()
    static func speak(_ text: String, lang: String = "en-US") {
        let u = AVSpeechUtterance(string: text)
        u.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Samantha-compact") // pick any
        u.rate  = 0.45
        u.pitchMultiplier = 1.15
        synth.speak(u)
    }
}

struct AboutView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    // Header
                    HStack(spacing: 12) {
                        Image(systemName: "face.smiling.fill")
                            .imageScale(.large)
                        Text("MoodBuddy")
                            .font(.title2).bold()
                            .fontDesign(.rounded)
                    }

                    Group {
                        Text("What is this app?")
                            .font(.headline).fontDesign(.rounded)
                        Text("MoodBuddy helps kids pick how they feel (Red, Yellow, Green, Blue) and shows easy ideas to feel better. Tap a color, read the tips, or press the speaker to hear them read aloud.")
                            .font(.body)
                            .fontDesign(.rounded)
                            .lineSpacing(2)
                    }

                    Group {
                        Text("How to use it")
                            .font(.headline).fontDesign(.rounded)
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Tap your color zone", systemImage: "hand.tap.fill")
                            Label("Read or listen to the tips", systemImage: "speaker.wave.2.fill")
                            Label("Try a strategy that feels right", systemImage: "lightbulb.fill")
                        }
                        .font(.body)
                        .fontDesign(.rounded)
                    }

                    Group {
                        Text("Kid-friendly words")
                            .font(.headline).fontDesign(.rounded)
                        Text("If a word is tricky, press the book button on the main page to see kid-friendly meanings with examples.")
                            .font(.body)
                            .fontDesign(.rounded)
                    }

                    Group {
                        Text("Privacy & notes")
                            .font(.headline).fontDesign(.rounded)
                        Text("MoodBuddy doesn’t collect personal data. It’s a learning tool to practice naming feelings and choosing healthy strategies.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .fontDesign(.rounded)
                    }

                    // Read entire description aloud
                    Button {
                        AboutSpeech.speak("""
                        MoodBuddy helps kids pick how they feel and shows easy ideas to feel better.
                        Tap a color, listen to the tips, and try a strategy that feels right.
                        If a word is tricky, press the book button to learn what it means.
                        """)
                    } label: {
                        Label("Read this page", systemImage: "speaker.2.circle.fill")
                            .font(.headline)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 8)
                }
                .padding()
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview { AboutView() }
