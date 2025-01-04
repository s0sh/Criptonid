//
//  DetailViewModel.swift
//  Criptonid
//
//  Created by Roman Bigun on 04.01.2025.
//

import Foundation
import SwiftUI
import Combine

final class DetailViewModel: ObservableObject {
    
   // @Published var coinDetails: CoinDetailModel
    
    private let coinDetailDataService: CoinDetailDataService
    private var cancelables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        coinDetailDataService = CoinDetailDataService(coin: coin)
        addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailDataService.$coinDetail.sink { recievedDetail in
            //self.coinDetails = recievedDetail
            print(recievedDetail)
        }
        .store(in: &cancelables)
    }
}
