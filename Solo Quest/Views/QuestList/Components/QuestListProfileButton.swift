//
//  QuestListProfileButton.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI
import Clerk

struct QuestListProfileButton: View {
    @Environment(\.clerk) private var clerk
    let showSettings: () -> Void
    
    var body: some View {
        Button(action: showSettings) {
            Group {
                if let user = clerk.user, !user.imageUrl.isEmpty {
                    AsyncImage(url: URL(string: user.imageUrl)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .foregroundColor(.brandBrownRich)
                    }
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(.brandBrownRich)
                }
            }
            .frame(width: 32, height: 32)
            .clipShape(Circle())
            .frame(width: 44, height: 44)
            .contentShape(Circle())
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(Text("Settings"))
    }
}
