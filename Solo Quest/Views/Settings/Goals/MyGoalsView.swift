//
//  MyGoalsView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI
import Factory

struct MyGoalsView: View {
    @Environment(\.dismiss) var dismiss
    @Injected(\.userStatsManager) private var userStatsManager
    
    @State private var selectedGoals: Set<String> = []
    @State private var hasChanges = false
    
    private let availableGoals = PlayerGoalOptions.all
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.brandBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Text("Select the goals you're working towards. Your daily quests will help you achieve these.")
                                .font(.body)
                                .foregroundColor(.brandTextSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 12) {
                            ForEach(availableGoals, id: \.self) { goal in
                                MyGoalRow(
                                    goal: goal,
                                    isSelected: selectedGoals.contains(goal),
                                    toggle: { toggleGoal(goal) }
                                )
                            }
                        }
                        .padding(.horizontal)
                        
                        if selectedGoals.isEmpty {
                            VStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.title2)
                                    .foregroundColor(.brandAccentOrange)
                                
                                Text("Select at least one goal")
                                    .font(.subheadline)
                                    .foregroundColor(.brandTextSecondary)
                            }
                            .padding()
                        }
                        
                        Spacer(minLength: 40)
                    }
                    .frame(maxWidth: 640) // Limit width on iPad
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("My Goals")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.brandBackground, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.brandBrownRich)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveGoals()
                        dismiss()
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.brandBrownRich)
                    .disabled(selectedGoals.isEmpty)
                }
            }
            .onAppear {
                loadGoals()
            }
        }
    }
    
    private func loadGoals() {
        selectedGoals = userStatsManager.getGoals()
    }
    
    private func saveGoals() {
        userStatsManager.updateGoals(selectedGoals)
    }
    
    private func toggleGoal(_ goal: String) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            if selectedGoals.contains(goal) {
                selectedGoals.remove(goal)
            } else {
                selectedGoals.insert(goal)
            }
            hasChanges = true
        }
    }
}

#Preview {
    MyGoalsView()
}
