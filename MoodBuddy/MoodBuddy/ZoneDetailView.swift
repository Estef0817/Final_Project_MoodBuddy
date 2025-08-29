//
//  ZoneDetailView.swift
//  MoodBuddy
//
//  Created by Estefany Mendez on 8/16/25.
//

import SwiftUI
import AVFoundation

struct ZoneDetailView: View {
    let zone: Zone
    var info: ZoneInfo { zoneInfo[zone] ?? ZoneInfo(actsLike: [], strategies: []) }

    @Environment(\.dismiss) private var dismiss

    // FIX: switch on `zone` (the enum), not on `self` (the view)
    var symbolName: String {
        switch zone {
        case .red:    return "cloud.bolt.rain.fill"            // big feelings
        case .yellow: return "exclamationmark.triangle.fill"   // wiggly/worried
        case .green:  return "leaf.fill"                       // calm/ready
        case .blue:   return "cloud.rain.fill"                 // sad/tired
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    // Header with color dot + symbol + title + emoji
                    HStack(spacing: 12) {
                        Circle().fill(zone.color).frame(width: 20, height: 20)

                        Image(systemName: symbolName)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, zone.color)
                            .font(.title2)

                        Text(zone.title)
                            .font(.title2).bold()
                            .fontDesign(.rounded)

                        Text(zone.emoji)
                            .font(.title2)
                    }
                    .padding(.top, 4)

                    // How you act
                    Text("How do you act in this zone?")
                        .font(.headline)
                        .fontDesign(.rounded)

                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(info.actsLike, id: \.self) { item in
                            HStack(alignment: .top, spacing: 10) {
                                Label(item, systemImage: "person.fill")
                                    .labelStyle(.titleAndIcon)
                                    .fontDesign(.rounded)
                                    .lineSpacing(2)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Button {
                                    Speech.speak(item)
                                } label: {
                                    Image(systemName: "speaker.wave.2.fill")
                                        .imageScale(.large)
                                }
                                .buttonStyle(.plain)
                                .accessibilityLabel("Read aloud")
                            }
                            .padding(12)
                            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 14))
                        }
                    }

                    // What you can do
                    Text("What can you do about it?")
                        .font(.headline)
                        .padding(.top, 8)
                        .fontDesign(.rounded)

                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(info.strategies, id: \.self) { item in
                            HStack(alignment: .top, spacing: 10) {
                                Label(item, systemImage: "lightbulb.fill")
                                    .labelStyle(.titleAndIcon)
                                    .fontDesign(.rounded)
                                    .lineSpacing(2)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Button {
                                    Speech.speak(item)
                                } label: {
                                    Image(systemName: "speaker.wave.2.fill")
                                        .imageScale(.large)
                                }
                                .buttonStyle(.plain)
                                .accessibilityLabel("Read aloud")
                            }
                            .padding(12)
                            .background(
                                zone.color.opacity(0.18),
                                in: RoundedRectangle(cornerRadius: 14)
                            )
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Tips")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .presentationDetents([.medium, .large])
        }
    }
}

#Preview {
    ZoneDetailView(zone: .red)
}
