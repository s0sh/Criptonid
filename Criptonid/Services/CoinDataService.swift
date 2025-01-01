//
//  CoinDataService.swift
//  Criptonid
//
//  Created by Roman Bigun on 01.01.2025.
//

import Foundation
import SwiftUI
import Combine

class CoinDataService {
    private let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
    
    @Published var allCoins: [CoinModel] = []
    
    var coinSubscription: AnyCancellable?
    
    init() {
        getCoins()
    }
    
    private func getCoins() {
        
        guard let url = URL(string: urlString) else { return }
        
        coinSubscription = NetworkManager.download(url: url)
            .receive(on: DispatchQueue.main)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] (receivedCoins) in
                self?.allCoins = receivedCoins
                self?.coinSubscription?.cancel()
            })
            
    }
}
