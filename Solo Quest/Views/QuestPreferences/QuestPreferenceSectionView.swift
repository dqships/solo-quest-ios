//
//  QuestPreferenceSectionView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct QuestPreferenceSectionView<T: Identifiable & Hashable>: View where T: RawRepresentable, T.RawValue == String {
    let title: String
    let subtitle: String
    let items: [T]
    @Binding var selectedItems: [T]
    let onChange: () -> Void
    
    private let columns = [
        GridItem(.adaptive(minimum: 110, maximum: 180), spacing: 8)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.brandDarkText)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.brandDarkText.opacity(0.5))
            }
            .padding(.horizontal)
            
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(items) { item in
                    FilterChipView(
                        item: item,
                        isSelected: selectedItems.contains(item),
                        onTap: { toggle(item) }
                    )
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func toggle(_ item: T) {
        withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
            if let index = selectedItems.firstIndex(of: item) {
                selectedItems.remove(at: index)
            } else {
                selectedItems.append(item)
            }
            onChange()
        }
    }
}
