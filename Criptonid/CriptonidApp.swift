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
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(vm)
        }
    }
}
