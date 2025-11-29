//
//  ToggleRow.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct ToggleRow: View {
    let icon: String
    let title: LocalizedStringKey
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.brandTextSecondary)
                .frame(width: 24)
            
            Text(title)
                .foregroundColor(.brandDarkText)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(.brandAccentOrange)
        }
    }
}
