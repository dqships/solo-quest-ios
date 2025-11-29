//
//  QuestNotesCard.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-06-2026
//

import SwiftUI

struct QuestNotesCard: View {
    let notes: String?
    let editNotes: () -> Void
    
    var body: some View {
        Button(action: editNotes) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Notes")
                        .font(.headline)
                        .foregroundColor(.brandDarkText)
                    Spacer()
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.brandTextSecondary)
                }
                
                Text(displayText)
                    .font(.body)
                    .foregroundColor(.brandTextSecondary)
                    .lineSpacing(4)
                    .multilineTextAlignment(.leading)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.brandCardSurface)
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }

    private var displayText: String {
        guard let notes,
              !notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return String(localized: "Tap to add notes...")
        }

        return notes
    }
}
