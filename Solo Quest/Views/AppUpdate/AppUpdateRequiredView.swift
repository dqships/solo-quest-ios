//
//  AppUpdateRequiredView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-28-2026
//

import SwiftUI

struct AppUpdateRequiredView: View {
    let updateInfo: AppUpdateInfo
    let updateAction: () -> Void

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.brandBackground
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        Image("SoloMascot")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 160)
                            .shadow(color: .white, radius: 0, x: 2, y: 0)
                            .shadow(color: .white, radius: 0, x: -2, y: 0)
                            .shadow(color: .white, radius: 0, x: 0, y: 2)
                            .shadow(color: .white, radius: 0, x: 0, y: -2)

                        VStack(spacing: 12) {
                            Text(String(localized: "Update Required"))
                                .font(.system(size: 34, weight: .black, design: .rounded))
                                .foregroundColor(.brandDarkText)
                                .multilineTextAlignment(.center)

                            Text(String(localized: "Version \(updateInfo.latestVersion) is available. Update Solo Quest XP to continue your quests."))
                                .font(.headline)
                                .foregroundColor(.brandTextSecondary)
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            Text(String(localized: "What's New"))
                                .font(.headline)
                                .foregroundColor(.brandDarkText)

                            Text(updateInfo.releaseNotes ?? String(localized: "Apple did not provide release notes for this version."))
                                .font(.body)
                                .foregroundColor(.brandTextSecondary)
                                .lineSpacing(4)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.brandCardSurface)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .stroke(Color.brandNeutral.opacity(0.22), lineWidth: 1)
                        )

                        Button(action: updateAction) {
                            HStack(spacing: 10) {
                                Image(systemName: "arrow.down.circle.fill")
                                    .font(.title3)

                                Text(String(localized: "Update in the App Store"))
                                    .font(.headline)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.brandAccentOrange)
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 40)
                    .frame(maxWidth: 560)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: geometry.size.height)
                }
            }
        }
    }
}
