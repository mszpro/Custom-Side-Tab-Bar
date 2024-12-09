//
//  ContentView.swift
//  TabBarSideBarDemo
//
//  Created by msz on 2024/12/09.
//

import SwiftUI

enum CurrentTab {
    case home
    case settings
    case profile
}

struct ContentView: View {
    @StateObject private var navigationState = NavigationState()
    @GestureState private var gestureOffset: CGFloat = 0
    @State private var currentTab: CurrentTab = .home
    
    var body: some View {
        GeometryReader { geometry in
            let sideBarWidth = geometry.size.width - 100
            
            HStack(spacing: 0) {
                // Side Menu
                SideMenuView()
                    .frame(width: sideBarWidth)
                
                // Main Content, which is the TabView from the above section
                ZStack(alignment: .bottom) {
                    TabView(selection: $currentTab) {
                        
                        Text("Home page")
                            .tag(CurrentTab.home)
                        
                        Text("Settings page")
                            .tag(CurrentTab.settings)
                        
                        Text("Profile page")
                            .tag(CurrentTab.profile)
                        
                    }
                    
                    floatingToolBar
                }
                .frame(width: geometry.size.width)
            }
            .offset(x: -sideBarWidth + navigationState.offset)
            .gesture(
                DragGesture()
                    .updating($gestureOffset) { value, state, _ in  // Use the local gestureOffset
                        state = value.translation.width
                    }
                    .onEnded { value in
                        navigationState.handleGestureEnd(value: value, sideBarWidth: sideBarWidth)
                    }
            )
            .animation(.linear(duration: 0.15), value: navigationState.offset == 0)
            .onChange(of: navigationState.showMenu) { newValue in
                handleMenuVisibilityChange(sideBarWidth: sideBarWidth)
            }
            .onChange(of: gestureOffset) { newValue in  // Use the local gestureOffset
                handleGestureOffsetChange(sideBarWidth: sideBarWidth, gestureOffset: newValue)
            }
        }
    }
    
    // MARK: Custom side menu
    
    private func handleMenuVisibilityChange(sideBarWidth: CGFloat) {
        if navigationState.showMenu && navigationState.offset == 0 {
            navigationState.offset = sideBarWidth
            navigationState.lastStoredOffset = navigationState.offset
        }
        
        if !navigationState.showMenu && navigationState.offset == sideBarWidth {
            navigationState.offset = 0
            navigationState.lastStoredOffset = 0
        }
    }
    
    private func handleGestureOffsetChange(sideBarWidth: CGFloat, gestureOffset: CGFloat) {
        if gestureOffset != 0 {
            let potentialOffset = navigationState.lastStoredOffset + gestureOffset
            if potentialOffset < sideBarWidth && potentialOffset > 0 {
                navigationState.offset = potentialOffset
            } else if potentialOffset < 0 {
                navigationState.offset = 0
            }
        }
    }
    
    // MARK: Custom tab bar
    
    var floatingToolBar: some View {
        HStack {
            
            Spacer()
            
            Button {
                self.currentTab = .home
            } label: {
                CustomTabItem(
                    symbolName: "house",
                    isActive: self.currentTab == .home)
            }
            
            Spacer()
            
            Button {
                self.currentTab = .settings
            } label: {
                CustomTabItem(
                    symbolName: "gear",
                    isActive: self.currentTab == .settings)
            }
            
            Spacer()
            
            Button {
                self.currentTab = .profile
            } label: {
                AsyncImage(url: URL(string: "https://cdn.pixabay.com/photo/2024/03/07/10/38/simba-8618301_640.jpg")!) { loadedImage in
                    loadedImage
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(maxWidth: .infinity)
                        .frame(height: 30)
                        .padding(2)
                        .background {
                            if self.currentTab == .profile {
                                Circle()
                                    .stroke(.teal, lineWidth: 1)
                            }
                        }
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 30)
            }
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 5)
        .padding(.horizontal, 20)
        .background(Color(uiColor: .systemGroupedBackground))
    }
    
    func CustomTabItem(symbolName: String, isActive: Bool) -> some View{
        HStack {
            Image(systemName: symbolName)
                .resizable()
                .foregroundColor(isActive ? .teal : .gray)
                .opacity(isActive ? 1 : 0.6)
                .frame(width: 22, height: 22)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 38)
    }
}

// MARK: - Navigation State
class NavigationState: ObservableObject {
    @Published var showMenu: Bool = false
    @Published var offset: CGFloat = 0
    @Published var lastStoredOffset: CGFloat = 0
    
    func handleGestureEnd(value: DragGesture.Value, sideBarWidth: CGFloat) {
        withAnimation(.spring(duration: 0.15)) {
            if value.translation.width > 0 {
                // Handle opening gesture
                if value.translation.width > sideBarWidth / 2 {
                    openMenu(sideBarWidth: sideBarWidth)
                } else if value.velocity.width > 800 {
                    openMenu(sideBarWidth: sideBarWidth)
                } else if !showMenu {
                    closeMenu()
                }
            } else {
                // Handle closing gesture
                if -value.translation.width > sideBarWidth / 2 {
                    closeMenu()
                } else {
                    guard showMenu else { return }
                    
                    if -value.velocity.width > 800 {
                        closeMenu()
                    } else {
                        openMenu(sideBarWidth: sideBarWidth)
                    }
                }
            }
        }
        lastStoredOffset = offset
    }
    
    private func openMenu(sideBarWidth: CGFloat) {
        offset = sideBarWidth
        lastStoredOffset = sideBarWidth
        showMenu = true
    }
    
    private func closeMenu() {
        offset = 0
        showMenu = false
    }
    
}

// MARK: - Preview
#Preview {
    ContentView()
        .environmentObject(NavigationState())
}
