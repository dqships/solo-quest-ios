//
//  CompletionRewardSummaryView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 08-21-2026
//

import Factory
import SwiftUI

struct CompletionRewardSummaryView: View {
    @Injected(\.analyticsManager) private var analytics
    let reward: QuestCompletionReward
    let hasMoreAvailableQuests: Bool
    let dismiss: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text(
                    reward.isFirstCompletion
                        ? String(localized: "Your first quest is complete")
                        : String(localized: "Quest complete")
                )
                    .font(.title.bold())
                    .multilineTextAlignment(.center)

                Text(reward.questTitle)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.brandTextSecondary)

                Text("+\(reward.xpEarned) \(LocalizationService.localizedStatName(reward.primaryStat)) XP")
                    .font(.title2.bold())
                    .foregroundStyle(Color.brandAccentOrange)

                if reward.isFirstCompletion {
                    Text("1 real-world quest completed. Your character is officially growing.")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.brandDarkText)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(LocalizationService.localizedStatName(reward.primaryStat))
                        .font(.headline)
                    Text("\(reward.statXPBefore) → \(reward.statXPAfter) XP")
                    ProgressView(value: min(1, max(0, reward.levelProgressAfter)))
                        .tint(.brandAccentOrange)
                        .accessibilityLabel("Level progress")
                        .accessibilityValue("\(Int(reward.levelProgressAfter * 100)) percent")
                    Text(levelProgressCopy)
                        .font(.subheadline)
                        .foregroundStyle(Color.brandTextSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.brandCardSurface)
                .clipShape(RoundedRectangle(cornerRadius: 18))

                Text(
                    hasMoreAvailableQuests
                        ? String(localized: "Another quest is waiting whenever you are.")
                        : String(localized: "Fresh opportunities arrive after 4 AM tomorrow.")
                )
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.brandTextSecondary)

                Button("Keep exploring", action: dismiss)
                    .buttonStyle(.borderedProminent)
                    .tint(.brandBrownRich)
            }
            .padding(28)
        }
        .onAppear {
            analytics.track(event: "completion_reward_viewed", properties: [
                "quest_id": reward.id.uuidString,
                "quest_template_id": reward.questTemplateID,
                "quest_category": reward.questCategory,
                "quest_difficulty": reward.questDifficulty,
                "quest_xp_reward": reward.xpEarned,
                "xp_earned": reward.xpEarned,
                "stat": reward.primaryStat,
                "is_first_quest": reward.isFirstCompletion,
                "user_level": reward.level,
                "user_rank": reward.rank,
                "user_total_xp": reward.userTotalXP,
                "user_current_streak": reward.userCurrentStreak,
                "active_days_lifetime": reward.activeDaysLifetime,
                "days_since_install": reward.daysSinceInstall,
                "new_user_protection_active": reward.newUserProtectionActive,
                "source": "quest_completion"
            ])
        }
    }

    private var levelProgressCopy: String {
        if reward.rankBefore != reward.rank {
            return String(
                format: String(localized: "Rank %@ → %@ · Level %lld"),
                reward.rankBefore,
                reward.rank,
                reward.level
            )
        }
        if reward.levelBefore != reward.level {
            return String(
                format: String(localized: "Level %lld → %lld · Rank %@"),
                reward.levelBefore,
                reward.level,
                reward.rank
            )
        }
        let before = Int(reward.levelProgressBefore * 100)
        let after = Int(reward.levelProgressAfter * 100)
        return String(
            format: String(localized: "Level progress %lld%% → %lld%% · Rank %@"),
            before,
            after,
            reward.rank
        )
    }
}
