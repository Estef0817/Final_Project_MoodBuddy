//
//  MainView.swift
//  MoodBuddy
//
//  Created by Estefany Mendez on 8/14/25.
//

import SwiftUI

// MARK: - Zones
enum Zone: String, CaseIterable, Identifiable {
    case red, yellow, green, blue
    var id: String { rawValue }

    var title: String {
        switch self {
        case .red:    return "Red Zone"
        case .yellow: return "Yellow Zone"
        case .green:  return "Green Zone"
        case .blue:   return "Blue Zone"
        }
    } // End of Var string
    var color: Color {
        switch self {
        case .red:    return Color(red: 0.94, green: 0.31, blue: 0.27)
        case .yellow: return Color(red: 0.99, green: 0.84, blue: 0.23)
        case .green:  return Color(red: 0.28, green: 0.70, blue: 0.42)
        case .blue:   return Color(red: 0.23, green: 0.49, blue: 0.86)
        }
    } // End of Var Color
    var textColor: Color { self == .yellow ? .black : .white } //End of Var Yellow 
    var emoji: String {
        switch self {
        case .red: "😠"
        case .yellow: "😟"
        case .green: "😊"
        case .blue: "😢"
        }
    }
}

// MARK: - Zone content
struct ZoneInfo {
    let actsLike: [String]
    let strategies: [String]
}

let zoneInfo: [Zone: ZoneInfo] = [
    .red: ZoneInfo(
        actsLike: [
            "Arguing, yelling, stomping",
            "Refusing or shutting down"
        ],
        strategies: [
            "Count to 10 / take 3 deep breaths",
            "Stop and walk away",
            "Tell a trusted adult"
        ]
    ),
    .yellow: ZoneInfo(
        actsLike: [
            "Pacing or fidgety",
            "Irritated or nervous"
        ],
        strategies: [
            "Short break + water",
            "Positive self-talk",
            "Tense & relax muscles"
        ]
    ),
    .green: ZoneInfo(
        actsLike: [
            "Smiling and relaxed",
            "Focused and engaged"
        ],
        strategies: [
            "Practice gratitude",
            "Help someone",
            "Move your body"
        ]
    ),
    .blue: ZoneInfo(
        actsLike: [
            "Withdrawn or tired",
            "Lonely or sad"
        ],
        strategies: [
            "Get or give a hug",
            "Talk to a friend",
            "Listen to music"
        ]
    )
]

// MARK: - Main page
struct MainView: View {
    @State private var selectedZone: Zone? = nil   // which zone was tapped

    var body: some View {
        ZStack {
            LinearGradient(colors: [
                Color(red: 0.84, green: 0.95, blue: 0.98),
                Color(red: 0.82, green: 0.94, blue: 0.88)
            ], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()

            VStack(spacing: 12) {
                Text("MoodBuddy")
                    .font(.largeTitle).bold()
                    .fontDesign(.rounded)

                Text("Tap your zone. Find your calm.")
                    .foregroundStyle(.secondary)
                    .fontDesign(.rounded)

                Spacer()

                VStack(spacing: 10) {
                    ForEach(Zone.allCases) { zone in
                        Button {
                            // This is the key line: set selectedZone
                            selectedZone = zone
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 22, style: .continuous)
                                    .fill(zone.color.opacity(0.92))
                                    .frame(height: 110)

                                HStack(spacing: 12) {
                                    Text(zone.emoji).font(.system(size: 36))
                                    Text(zone.title)
                                        .font(.title2).bold()
                                        .foregroundStyle(zone.textColor)
                                        .fontDesign(.rounded)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel(Text(zone.title))
                    }
                }
                .padding(.horizontal)

                Spacer(minLength: 8)
            }
            .padding()
        }
        // This presents the sheet when selectedZone is not nil
        .sheet(item: $selectedZone) { zone in
            ZoneDetailView(zone: zone)
        }
    }
}

// MARK: - Detail sheet
struct ZoneDetailView: View {
    let zone: Zone
    var info: ZoneInfo { zoneInfo[zone]! }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Header
                    HStack(spacing: 12) {
                        Circle().fill(zone.color).frame(width: 20, height: 20)
                        Text(zone.title).font(.title2).bold().fontDesign(.rounded)
                        Text(zone.emoji).font(.title2)
                    }
                    .padding(.top, 4)

                    // How you act
                    Text("How do you act in this zone?")
                        .font(.headline).fontDesign(.rounded)

                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(info.actsLike, id: \.self) { item in
                            Label(item, systemImage: "person.fill")
                                .padding(12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 14))
                        }
                    }

                    // What you can do
                    Text("What can you do about it?")
                        .font(.headline).padding(.top, 8).fontDesign(.rounded)

                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(info.strategies, id: \.self) { item in
                            Label(item, systemImage: "lightbulb.fill")
                                .padding(12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(zone.color.opacity(0.18),
                                            in: RoundedRectangle(cornerRadius: 14))
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Tips")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview { MainView() }
