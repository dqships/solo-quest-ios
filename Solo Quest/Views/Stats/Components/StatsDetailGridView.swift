//
//  StatsDetailGridView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct StatsDetailGridView: View {
    @ObservedObject var viewModel: StatsViewModel

    private let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 16)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Details")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.brandDarkText)
                .padding(.horizontal)
                .padding(.top, 72)

            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.statTaglines.keys.sorted(), id: \.self) { key in
                    let xp = viewModel.getStatValue(key)
                    let tagline = viewModel.statTaglines[key] ?? ""

                    NavigationLink(value: AppRoute.statDetail(
                        statName: key,
                        currentXP: xp,
                        tagline: tagline
                    )) {
                        StatTileView(
                            statName: key,
                            xp: xp,
                            level: viewModel.getAttributeLevel(xp: xp),
                            rank: viewModel.getRank(from: xp),
                            progress: viewModel.getProgress(currentXP: xp),
                            tagline: tagline
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }
}
