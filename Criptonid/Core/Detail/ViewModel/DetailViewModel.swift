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
            .map(mapStatistics)
            .sink { (returnedArrays) in
                self.overviewStatistics = returnedArrays.overview
                self.additionalStatistics = returnedArrays.additional
        }
        .store(in: &cancelables)
    }
    
    private func mapStatistics(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> (overview: [StatisticModel], additional: [StatisticModel]) {
        
        return (createOverviewArray(coinModel: coinModel),
                createAdditionalArray(coinDetailModel: coinDetailModel, coinModel: coinModel))
    }
    
    private func createOverviewArray(coinModel: CoinModel) -> [StatisticModel] {
        
        var overviewArray: [StatisticModel] = []
        
        let price = coinModel.currentPrice.asCurrencyWith6Decimals()
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceStats = StatisticModel(title: "Current price",
                                        value: price,
                                        percentageChange: pricePercentChange)
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
        
        overviewArray.append(contentsOf:
                                [priceStats,
                                 marketCapStat,
                                 rankStat,
                                 volumeStat])
        return overviewArray
    }
    
    private func createAdditionalArray(coinDetailModel: CoinDetailModel?, coinModel: CoinModel)  -> [StatisticModel] {
        var additionalArray: [StatisticModel] = []
       
        
        // MARK: - Additional data set
        let high = coinModel.high24H?.formattedWithAbbreviations() ?? "n/a"
        let highStat = StatisticModel(title: "24h High", value: high)
        
        let low = coinModel.low24H?.formattedWithAbbreviations() ?? "n/a"
        let lowStat = StatisticModel(title: "24h Low", value: low)
        
        let priceChange = coinModel.priceChange24H?.asCurrencyWith2Decimals() ?? "n/a"
        let pricePercentChange2 = coinModel.priceChangePercentage24H
        let priceStats2 = StatisticModel(title: "24H Price change",
                                        value: priceChange,
                                        percentageChange: pricePercentChange2)
        
        let marketCap2 = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapStat2 = StatisticModel(title: "24h Market Cap change",
                                           value: marketCap2,
                                           percentageChange: marketCapPercentChange)
        
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockTimeStat = StatisticModel(title: "Block Time", value: blockTimeString)

        let hash = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashStat = StatisticModel(title: "Hashing Algorithm", value: hash)
        
        additionalArray.append(contentsOf:
                                [highStat,
                                 lowStat,
                                 priceStats2,
                                 marketCapStat2,
                                 blockTimeStat,
                                 hashStat])
        return additionalArray
    }
    
    
}
