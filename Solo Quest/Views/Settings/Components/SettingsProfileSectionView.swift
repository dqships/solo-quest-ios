//
//  SettingsProfileSectionView.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import SwiftUI
import Clerk

struct SettingsProfileSectionView: View {
    @Environment(\.clerk) private var clerk
    let showUserProfile: () -> Void
    let showAuth: () -> Void
    let showStore: () -> Void
    let showMyGoals: () -> Void
    let showAdventurerProfile: () -> Void
    let canTakeAdventurerProfileAssessment: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Profile")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.brandDarkText)
                .padding(.horizontal)
            
            VStack(spacing: 16) {
                if let user = clerk.user {
                    Button(action: showUserProfile) {
                        HStack(spacing: 16) {
                            AsyncImage(url: URL(string: user.imageUrl)) { image in
                                image.resizable().scaledToFill()
                            } placeholder: {
                                Color.brandNeutral
                            }
                            .frame(width: 56, height: 56)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.brandBrownRich, lineWidth: 2))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.firstName ?? "User")
                                    .font(.headline)
                                    .foregroundColor(.brandDarkText)
                                
                                if let email = user.primaryEmailAddress?.emailAddress {
                                    Text(email)
                                        .font(.caption)
                                        .foregroundColor(.brandTextSecondary)
                                }
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.brandBrownMid)
                        }
                        .padding()
                        .background(Color.brandCardSurface)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)
                    }
                    .buttonStyle(PlainButtonStyle())
                } else if ClerkConfiguration.isEnabled {
                    Button(action: showAuth) {
                        HStack(spacing: 16) {
                            Image(systemName: "person.crop.circle.fill.badge.plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.brandBrownRich)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Sign In")
                                    .font(.headline)
                                    .foregroundColor(.brandDarkText)
                                Text("Save your progress & stats")
                                    .font(.caption)
                                    .foregroundColor(.brandTextSecondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.brandBrownMid)
                        }
                        .padding()
                        .background(Color.brandCardSurface)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Button(action: openStore) {
                    HStack {
                        Image(systemName: "cart.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.brandAccentOrange)
                            .frame(width: 32)
                        
                        Text("Store / Marketplace")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.brandDarkText)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.brandTextSecondary)
                    }
                    .padding()
                    .background(Color.brandCardSurface)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: showMyGoals) {
                    HStack {
                        Image(systemName: "target")
                            .font(.system(size: 20))
                            .foregroundColor(.brandAccentOrange)
                            .frame(width: 32)
                        
                        Text("My Goals")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.brandDarkText)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.brandTextSecondary)
                    }
                    .padding()
                    .background(Color.brandCardSurface)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)
                }
                .buttonStyle(PlainButtonStyle())

                if canTakeAdventurerProfileAssessment {
                    Button(action: showAdventurerProfile) {
                        HStack {
                            Image(systemName: "person.text.rectangle")
                                .font(.system(size: 20))
                                .foregroundColor(.brandAccentOrange)
                                .frame(width: 32)
                            Text("Discover Your Adventurer Profile")
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.brandDarkText)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.brandTextSecondary)
                        }
                        .padding()
                        .background(Color.brandCardSurface)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func openStore() {
        if ClerkConfiguration.requiresSignIn(user: clerk.user) {
            showAuth()
        } else {
            showStore()
        }
    }
}
