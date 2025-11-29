//
//  RankProgressView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI
import Factory

struct RankProgressView: View {
    @Injected(\.questEngine) private var questEngine
    let currentRank: String
    let currentLevel: Int
    
    // Fetched from QuestEngine (GameData)
    private var ranks: [RankConfig] {
        return questEngine.getRanks()
    }
    
    var body: some View {
        ZStack {
            Color.brandBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    
                    // Header
                    VStack(spacing: 8) {
                        Text("Rank Progress")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundColor(.brandDarkText)
                        
                        Text("Climb the ranks by leveling up.")
                            .font(.subheadline)
                            .foregroundColor(.brandTextSecondary)
                    }
                    .padding(.top)
                    
                    // Current Status Card
                    VStack(spacing: 16) {
                        Image("RankBadge\(currentRank)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 4)
                        
                        VStack(spacing: 4) {
                            Text("Current Rank: \(currentRank)")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.brandDarkText)
                            
                            Text("Level \(currentLevel)")
                                .font(.headline)
                                .foregroundColor(.brandTextSecondary)
                        }
                        
                        if let nextRank = getNextRank() {
                            Text("Reach Level \(nextRank.minLevel) to achieve Rank \(nextRank.id)")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.brandAccentOrange)
                                .padding(.top, 4)
                        } else {
                             Text("Max Rank Achieved!")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.brandAccentOrange)
                                .padding(.top, 4)
                        }
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity)
                    .background(Color.brandCardSurface)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, y: 4)
                    .padding(.horizontal)
                    
                    // Rank Ladder
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Rank Ladder")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.brandDarkText)
                            .padding(.bottom, 16)
                            .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            ForEach(ranks.reversed(), id: \.id) { rank in
                                RankProgressRowView(
                                    rank: rank,
                                    isActive: rank.id == currentRank,
                                    isPast: isRankPast(rank.id)
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 40)
                .frame(maxWidth: 640) // Limit width on iPad
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        // Standard Navigation Bar styling
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Helpers
    
    private func getNextRank() -> RankConfig? {
        guard let currentIndex = ranks.firstIndex(where: { $0.id == currentRank }) else { return nil }
        let nextIndex = currentIndex + 1
        return nextIndex < ranks.count ? ranks[nextIndex] : nil
    }
    
    // Simple logic: if current rank is 'B', then 'C', 'D', 'E' are past.
    // Array is E, D, C, B, A, S.
    private func isRankPast(_ rankId: String) -> Bool {
        guard let currentIndex = ranks.firstIndex(where: { $0.id == currentRank }),
              let checkIndex = ranks.firstIndex(where: { $0.id == rankId }) else { return false }
        return checkIndex < currentIndex
    }
}

#Preview {
    RankProgressView(currentRank: "B", currentLevel: 52)
}
