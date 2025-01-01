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
                ContentView()
                    .navigationBarHidden(true)
            }
            .environmentObject(vm)
        }
    }
}
