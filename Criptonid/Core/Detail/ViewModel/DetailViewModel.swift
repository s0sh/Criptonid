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
    
    @Published var overviewStatistics: [StatisticModel] = []
    @Published var additionalStatistics: [StatisticModel] = []
    @Published var coin: CoinModel
    
    private let coinDetailDataService: CoinDetailDataService
    private var cancelables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        coinDetailDataService = CoinDetailDataService(coin: coin)
        addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailDataService.$coinDetail
            .combineLatest($coin)
            .map({ (coinDetailModel, coinModel) -> (overview: [StatisticModel], additional: [StatisticModel]) in
                var overviewArray: [StatisticModel] = []
                var additionalArray: [StatisticModel] = []
               
                // MARK: - Overview data set
                let price = coinModel.currentPrice.asCurrencyWith6Decimals()
                let priceChange = coinModel.priceChangePercentage24H
                let priceStats = StatisticModel(title: "Current price",
                                                value: price,
                                                percentageChange: priceChange)
                let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
                let marketCapChange = coinModel.marketCapChangePercentage24H
                let marketCapStat = StatisticModel(title: "Market capitalization",
                                                   value: marketCap,
                                                   percentageChange: marketCapChange)
                let rank = "\(coinModel.rank)"
                let rankStat = StatisticModel(title: "Rank", value: rank)
                let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
                
                let volumeStat = StatisticModel(title: "Volume",
                                                value: volume)
                
                overviewArray.append(contentsOf: [priceStats, marketCapStat, rankStat, volumeStat])
                
                // MARK: - Additional data set
                
                return (overviewArray,overviewArray)
            })
            .sink { (returnedArrays) in
                self.overviewStatistics = returnedArrays.overview
                self.additionalStatistics = returnedArrays.additional
        }
        .store(in: &cancelables)
    }
    
    private func mapStatistics(coinDetail: CoinDetailModel, coin: CoinModel) -> (overview: [StatisticModel], additional: [StatisticModel]) {
        return ([],[])
    }
}
