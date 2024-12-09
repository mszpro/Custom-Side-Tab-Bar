//
//  SideMenuView.swift
//  TabBarSideBarDemo
//
//  Created by msz on 2024/12/09.
//

import SwiftUI

struct SideMenuView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                // User Profile Section
                VStack(alignment: .leading, spacing: 16) {
                    // Avatar
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 48, height: 48)
                        .foregroundColor(.gray)
                        .background(Color.white)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                    
                    // User Info
                    VStack(alignment: .leading, spacing: 4) {
                        Text("John Appleseed")
                            .font(.headline)
                        
                        Text("@johnappleseed")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    // Following/Followers
                    HStack(spacing: 20) {
                        HStack(spacing: 4) {
                            Text("420")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text("Following")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        HStack(spacing: 4) {
                            Text("69K")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text("Followers")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal)
                
                // Menu Options
                VStack(spacing: 0) {
                    MenuButton(icon: "person", title: "Profile")
                    MenuButton(icon: "text.bubble", title: "Topics")
                    MenuButton(icon: "bookmark", title: "Bookmarks")
                    MenuButton(icon: "list.bullet", title: "Lists")
                    MenuButton(icon: "person.2", title: "Circle")
                }
                
                Divider()
                    .padding(.vertical)
                
                // Professional Tools Section
                VStack(alignment: .leading, spacing: 5) {
                    Text("Professional Tools")
                        .foregroundColor(.gray)
                        .font(.footnote)
                        .padding(.horizontal)
                    
                    VStack(spacing: 0) {
                        MenuButton(icon: "chart.line.uptrend.xyaxis", title: "Analytics")
                        MenuButton(icon: "megaphone", title: "Ads")
                    }
                }
                
                // Settings Section
                VStack(alignment: .leading, spacing: 5) {
                    Text("Settings & Support")
                        .foregroundColor(.gray)
                        .font(.footnote)
                        .padding(.horizontal)
                    
                    VStack(spacing: 0) {
                        MenuButton(icon: "gear", title: "Settings and privacy")
                        MenuButton(icon: "questionmark.circle", title: "Help Center")
                    }
                }
                
                Spacer()
            }
            .padding(.vertical)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(uiColor: .tertiarySystemGroupedBackground))
    }
}

struct MenuButton: View {
    let icon: String
    let title: String
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .frame(width: 24)
                Text(title)
                    .font(.body)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .foregroundColor(.primary)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Preview
struct TwitterSideMenu_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView()
            .frame(width: UIScreen.main.bounds.width - 85)
    }
}
