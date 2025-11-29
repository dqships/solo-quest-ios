//
//  LegalContentView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct LegalContentView: View {
    let text: String
    
    var body: some View {
        ZStack {
            Color.brandBackground.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(parseMarkdown(text), id: \.self) { component in
                        component.view
                    }
                }
                .padding()
            }
        }
    }
    
    private func parseMarkdown(_ text: String) -> [MarkdownComponent] {
        var components: [MarkdownComponent] = []
        let lines = text.components(separatedBy: .newlines)
        
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if trimmed.isEmpty { continue }
            
            if trimmed.hasPrefix("# ") {
                components.append(.header1(String(trimmed.dropFirst(2))))
            } else if trimmed.hasPrefix("## ") {
                components.append(.header2(String(trimmed.dropFirst(3))))
            } else if trimmed.hasPrefix("* ") {
                components.append(.bullet(String(trimmed.dropFirst(2))))
            } else {
                components.append(.paragraph(trimmed))
            }
        }
        
        return components
    }
    
    enum MarkdownComponent: Hashable {
        case header1(String)
        case header2(String)
        case bullet(String)
        case paragraph(String)
        
        @ViewBuilder
        var view: some View {
            switch self {
            case .header1(let text):
                Text(LocalizedStringKey(text))
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundColor(.brandDarkText)
                    .padding(.top, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
            case .header2(let text):
                Text(LocalizedStringKey(text))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.brandDarkText)
                    .padding(.top, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
            case .bullet(let text):
                HStack(alignment: .top, spacing: 8) {
                    Text("•")
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(.brandDarkText)
                    Text(LocalizedStringKey(text))
                        .font(.body)
                        .foregroundColor(.brandDarkText)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.leading, 8)
            case .paragraph(let text):
                Text(LocalizedStringKey(text))
                    .font(.body)
                    .foregroundColor(.brandDarkText)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
