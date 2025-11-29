//
//  QuestListRecentActivitySectionView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct QuestListRecentActivitySectionView: View {
    @ObservedObject var viewModel: QuestListViewModel
    let activityLog: [ActivityLogItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Activity")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.brandDarkText)
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                if activityLog.isEmpty {
                    Text("No recent activity.")
                        .font(.caption)
                        .foregroundColor(.brandTextSecondary)
                        .padding()
                } else {
                    ForEach(activityLog) { item in
                        NavigationLink(value: AppRoute.activityDetail(item: item)) {
                            QuestListActivityRowView(item: item)
                                .background(Color.brandCardSurface)
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.05), radius: 2, y: 1)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    if activityLog.count >= viewModel.activityFetchLimit {
                        Button(action: {
                            viewModel.loadMoreActivity()
                        }) {
                            Text("See More")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.brandBrownRich)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                                .background(Color.brandNeutral.opacity(0.1))
                                .cornerRadius(12)
                        }
                        .padding(.top, 8)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
