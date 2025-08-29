//
//  WordsView.swift
//  MoodBuddy
//
//  Created by Estefany Mendez on 8/19/25.
//

import SwiftUI
import AVFoundation

// Uses your existing Speech helper if you already have one.
// If not, this tiny helper will work here too:
enum SpeechWord {
    static let synth = AVSpeechSynthesizer()
    static func speak(_ text: String, lang: String = "en-US") {
        let u = AVSpeechUtterance(string: text)
        u.voice = AVSpeechSynthesisVoice(language: lang)
        u.rate  = AVSpeechUtteranceDefaultSpeechRate * 0.9
        synth.speak(u)
    }
}

struct WordEntry: Identifiable {
    let id = UUID()
    let emoji: String
    let term: String           // the “big” word
    let simple: String         // kid-friendly meaning
    let example: String        // simple example sentence
}

// Add more as you notice needs:
let kidWords: [WordEntry] = [
    WordEntry(
        emoji: "💚",
        term: "Gratitude",
        simple: "Being thankful for good things in your life.",
        example: "I show gratitude by saying ‘thank you’ and noticing 3 good things today."
    ),
    WordEntry(
        emoji: "😌",
        term: "Calm",
        simple: "Your body and mind feel relaxed and safe.",
        example: "When I am calm, I breathe slowly and my shoulders feel loose."
    ),
    WordEntry(
        emoji: "🧘🏽",
        term: "Grounding",
        simple: "A trick to feel steady: notice 5 things you can see, 4 you can touch, 3 you can hear, 2 you can smell, 1 you can taste.",
        example: "Grounding is my tool when I feel nervous or sad."
    )
]

struct WordsView: View {
    var body: some View {
        NavigationStack {
            List(kidWords) { w in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(w.emoji).font(.title3)
                        Text(w.term)
                            .font(.headline)
                            .fontDesign(.rounded)
                        Spacer()
                        Button {
                            SpeechWord.speak("\(w.term). \(w.simple) Example: \(w.example)")
                        } label: {
                            Image(systemName: "speaker.wave.2.fill")
                                .imageScale(.large)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Read aloud")
                    }

                    Text(w.simple)
                        .font(.subheadline)
                        .fontDesign(.rounded)

                    Text("Example: \(w.example)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 6)
            }
            .navigationTitle("Words Helper")
        }
    }
}

#Preview { WordsView() }
