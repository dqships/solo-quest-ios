//
//  SettingsClearDataRow.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-23-2026
//

import SwiftUI

struct SettingsClearDataRow: View {
    let isClearingData: Bool
    let requestClearData: () -> Void

    var body: some View {
        Button(action: requestClearData) {
            HStack {
                Image(systemName: "trash.fill")
                    .foregroundColor(.red.opacity(0.8))
                    .frame(width: 24)

                Text("Clear All Data")
                    .fontWeight(.semibold)
                    .foregroundColor(.red.opacity(0.8))

                Spacer()

                if isClearingData {
                    ProgressView()
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.red.opacity(0.45))
                }
            }
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isClearingData)
    }
}
