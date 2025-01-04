//
//  CoinDetailDataService.swift
//  Criptonid
//
//  Created by Roman Bigun on 04.01.2025.
//

import Foundation
import SwiftUI
import Combine

final class CoinDetailDataService {
    
    @Published var coinDetail: CoinDetailModel? = nil
    
    let coin: CoinModel
    
    var coinDetailsSubscription: AnyCancellable?
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoinDetails()
    }
    
    private func getCoinDetails() {
        let urlString = "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false"
        guard let url = URL(string: urlString) else { return }
        
        coinDetailsSubscription = NetworkManager.download(url: url)
            .receive(on: DispatchQueue.main)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] (receivedDetails) in
                self?.coinDetail = receivedDetails
                self?.coinDetailsSubscription?.cancel()
            })
            
    }
    
}
