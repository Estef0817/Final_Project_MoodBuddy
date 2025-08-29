//
//  MainView.swift
//  MoodBuddy
//
//  Created by Estefany Mendez on 8/14/25.
//

import SwiftUI
import AVFoundation   // for speech

// MARK: Shared models
enum Zone: String, CaseIterable, Identifiable {
    case red, yellow, green, blue
    var id: String { rawValue }
    var title: String {
        switch self {
        case .red: "Red Zone"; case .yellow: "Yellow Zone"
        case .green: "Green Zone"; case .blue: "Blue Zone"
        }
    }
    var color: Color {
        switch self {
        case .red:    Color(red: 0.94, green: 0.31, blue: 0.27)
        case .yellow: Color(red: 0.99, green: 0.84, blue: 0.23)
        case .green:  Color(red: 0.28, green: 0.70, blue: 0.42)
        case .blue:   Color(red: 0.23, green: 0.49, blue: 0.86)
        }
    }
    var textColor: Color { self == .yellow ? .black : .white }
    var emoji: String {
        switch self {
        case .red: "😠"; case .yellow: "😟"; case .green: "😊"; case .blue: "😢"
        }
    }
    var shortDescription: String {
        switch self {
        case .red: "Strong feelings like anger"
        case .yellow: "Wiggly or worried feelings"
        case .green: "Calm and ready to learn"
        case .blue: "Sad or tired feelings"
        }
    }
}

struct ZoneInfo {
    let actsLike: [String]
    let strategies: [String]
}

let zoneInfo: [Zone: ZoneInfo] = [
    .red: ZoneInfo(
        actsLike: ["🗣️ Arguing, yelling, stomping", "🙅🏻‍♀️ Refusing or shutting down"],
        strategies: ["🧘 Take 3 deep breaths", "🚶 Stop and walk away", "🧑🏽‍🏫 Tell a trusted adult"]
    ),
    .yellow: ZoneInfo(
        actsLike: ["🚶 Pacing or fidgety", "😬 Irritated or nervous"],
        strategies: ["🫁 Deep breaths + water", "🙂 Positive self-talk", "💪 Tense & relax muscles"]
    ),
    .green: ZoneInfo(
        actsLike: ["😊 Smiling and relaxed", "🎯 Focused and engaged"],
        strategies: ["💚 Practice gratitude", "🫶 Help someone", "🏃 Move your body"]
    ),
    .blue: ZoneInfo(
        actsLike: ["🐢 Slow or tired", "😔 Lonely or sad"],
        strategies: ["🤗 Get or give a hug", "🗣️ Talk to a friend", "🎧 Listen to music"]
    )
]

// MARK: Remove emojis when reading
extension String {
    var withoutEmojis: String {
        self.unicodeScalars.filter {
            !$0.properties.isEmoji && !$0.properties.isEmojiPresentation
        }.map { String($0) }.joined()
    }
}

// MARK: Speech helper
enum Speech {
    static let synth = AVSpeechSynthesizer()
    static func speak(_ text: String, lang: String = "en-US") {
        let u = AVSpeechUtterance(string: text.withoutEmojis) // 👈 now skips emojis
        u.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Samantha-compact")
        u.rate  = 0.40
        u.pitchMultiplier = 1.2
        synth.speak(u)
    }
    static func stop() { synth.stopSpeaking(at: .immediate) }
}

// MARK: Main page
struct MainView: View {
    @State private var selectedZone: Zone? = nil
    @State private var showWords = false
    @State private var showAbout = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [
                    Color(red: 0.84, green: 0.95, blue: 0.98),
                    Color(red: 0.82, green: 0.94, blue: 0.88)
                ], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

                VStack(spacing: 12) {
                    Text("MoodBuddy")
                        .font(.custom("Waltograph", size: 42, relativeTo: .largeTitle))
                        .minimumScaleFactor(0.8)
                    Text("Tap your zone. Find your calm.")
                        .foregroundStyle(.secondary).fontDesign(.rounded)

                    Spacer()

                    VStack(spacing: 10) {
                        ForEach(Zone.allCases) { zone in
                            Button {
                                selectedZone = zone
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                                        .fill(zone.color.opacity(0.92))
                                        .frame(height: 110)
                                    VStack {
                                        HStack(spacing: 12) {
                                            Text(zone.emoji).font(.system(size: 36))
                                            Text(zone.title)
                                                .font(.title2).bold()
                                                .foregroundStyle(zone.textColor)
                                                .fontDesign(.rounded)
                                        }
                                        Text(zone.shortDescription) // 👈 explanation for kids
                                            .font(.caption)
                                            .foregroundStyle(zone.textColor.opacity(0.9))
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)

                    Spacer(minLength: 8)
                }
                .padding()
            }
            // Sheets
            .sheet(item: $selectedZone) { zone in
                ZoneDetailView(zone: zone)
            }
            .sheet(isPresented: $showWords) {
                WordsView()
                    .presentationDetents([.medium, .large])
            }
            .sheet(isPresented: $showAbout) {
                AboutView()
                    .presentationDetents([.medium, .large])
            }
            // Top-right buttons
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showWords = true } label: {
                        Image(systemName: "book.fill")
                    }
                    .accessibilityLabel("Words helper")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showAbout = true } label: {
                        Image(systemName: "info.circle.fill")
                    }
                    .accessibilityLabel("About MoodBuddy")
                }
            }
        }
    }
}

#Preview { MainView() }
