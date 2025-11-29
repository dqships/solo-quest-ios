//
//  ActivityDetailUnavailableSection.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct ActivityDetailUnavailableSection: View {
    var body: some View {
        Text(String(localized: "Quest details are no longer available."))
            .font(.subheadline)
            .foregroundColor(.brandTextSecondary)
            .padding()
            .frame(maxWidth: .infinity, alignment: .center)
            .background(Color.brandNeutral.opacity(0.1))
            .cornerRadius(12)
    }
}
