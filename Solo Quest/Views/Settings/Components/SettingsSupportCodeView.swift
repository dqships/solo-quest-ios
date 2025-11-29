//
//  SettingsSupportCodeView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-24-2026
//

import SwiftUI
import UIKit

struct SettingsSupportCodeView: View {
    let supportCode: String
    @State private var didCopy = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Your help code")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.brandDarkText)

                Text("Share this when you reach out so we can find your account faster.")
                    .font(.footnote)
                    .foregroundColor(.brandTextSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            HStack(alignment: .center, spacing: 10) {
                Text(verbatim: supportCode)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.brandDarkText)
                    .lineLimit(3)
                    .textSelection(.enabled)

                Spacer(minLength: 8)

                Button(action: copySupportCode) {
                    HStack(spacing: 6) {
                        Image(systemName: didCopy ? "checkmark" : "doc.on.doc")
                            .font(.caption)

                        Text(didCopy ? String(localized: "Copied") : String(localized: "Copy"))
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(Color.brandBrownRich)
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(supportCode.isEmpty)
            }
            .padding(10)
            .background(Color.brandCardSurface)
            .cornerRadius(8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func copySupportCode() {
        guard !supportCode.isEmpty else { return }

        UIPasteboard.general.string = supportCode
        didCopy = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            didCopy = false
        }
    }
}
