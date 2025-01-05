//
//  SettingsView.swift
//  Criptonid
//
//  Created by Roman Bigun on 05.01.2025.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var vm = SettingsViewModel()

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading) {
                        Image("coingecko")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        Text("The criptocurrency data that is used in this app xomes from a free API provided by CoinGecko. Prices may slightly delayed.")
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundColor(Color.theme.accent)
                    }
                    .padding(.vertical)
                    Link("CoinGecko website", destination: vm.coinGeckoUrl)
                        .foregroundColor(.pink)
                    
                } header: {
                    Text("CoinGecko")
                }
                
            }
            .listStyle(.grouped)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton()
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
