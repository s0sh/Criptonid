//
//  MarketDataService.swift
//  Criptonid
//
//  Created by Roman Bigun on 02.01.2025.
//

import Foundation
import SwiftUI
import Combine

final class MarketDataService: ObservableObject {
    private let urlString = "https://api.coingecko.com/api/v3/global"
    
    @Published var marketData: MarketDataModel? = nil
    
    var marketDataSubscription: AnyCancellable?
    
    init() {
        getData()
    }
    
    private func getData() {
        guard let url = URL(string: urlString) else { return }
        
        marketDataSubscription = NetworkManager.download(url: url)
            .receive(on: DispatchQueue.main)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] (returnedGlobalData) in
                self?.marketData = returnedGlobalData.data
                self?.marketDataSubscription?.cancel()
            })
    }
    
    func refreshData() {
        getData()
    }
}
