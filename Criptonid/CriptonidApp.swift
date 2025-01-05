//
//  CriptonidApp.swift
//  Criptonid
//
//  Created by Roman Bigun on 31.12.2024.
//

import SwiftUI

@main
struct CriptonidApp: App {
    
    @StateObject private var vm = HomeViewModel()
    @State private var showLaunchingView: Bool = true
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationStack {
                    HomeView()
                        .navigationBarHidden(true)
                }
                .environmentObject(vm)
                ZStack {
                    if showLaunchingView {
                        LaunchView(showLaunchingView: $showLaunchingView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
            }
        }
    }
}
