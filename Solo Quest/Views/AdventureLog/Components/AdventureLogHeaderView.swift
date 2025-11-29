//
//  AdventureLogHeaderView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI

struct AdventureLogHeaderView: View {
    var body: some View {
        HStack {
            Text("Adventure Log")
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundColor(.brandDarkText)
            Spacer()
        }
        .padding(.horizontal)
    }
}
