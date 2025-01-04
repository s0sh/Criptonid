//
//  DetailView.swift
//  Criptonid
//
//  Created by Roman Bigun on 04.01.2025.
//

import SwiftUI

struct DetailLoadingView: View {
    
    @Binding var coin: CoinModel?
    
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    
   @StateObject var vm: DetailViewModel
    
   var coin: CoinModel?
    
    init(coin: CoinModel) {
        self.coin = coin
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ZStack {
            if let coin = coin {
                Text(coin.name)
            }
        }
    }
}

#Preview {
    DetailView(coin: DeveloperPreview.instance.coin)
}
