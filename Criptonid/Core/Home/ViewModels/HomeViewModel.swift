//
//  HomeViewModel.swift
//  Criptonid
//
//  Created by Roman Bigun on 01.01.2025.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
   
    @Published var statistics: [StatisticModel] = []
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    
    private let coinDataService = CoinDataService()
    private let portfolioDataService = PortfolioDataService()
    private let marketDataService = MarketDataService()
    private var cancelabels = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func refreshData() {
        coinDataService.refreshData()
        marketDataService.refreshData()
        HapticManager.notification(type: .success)
    }
    
    func addSubscribers() {
        
        // Update coins
        $searchText.combineLatest(coinDataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] (returnedCoins) in
                guard let self = self else { return }
                self.allCoins = returnedCoins
            }
            .store(in: &cancelabels)
        
        // map All Cooins To Portfolio Coins
        $allCoins.combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCooinsToPortfolioCoins)
            .sink{ [weak self] (returnedCoins) in
                self?.portfolioCoins = returnedCoins
            }
            .store(in: &cancelabels)
       
        // Update portfolio coins data
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnedStatus) in
                self?.statistics = returnedStatus
            }
            .store(in: &cancelabels)
        
        
    }
    private func mapAllCooinsToPortfolioCoins(coinModels: [CoinModel], portfolioEntities: [PortfolioEntity]) -> [CoinModel] {
        coinModels.compactMap { (coin) -> CoinModel? in
            guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id } ) else {
                return nil
            }
            return coin.updateHoldings(amount: entity.amount)
        }
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    private func mapGlobalMarketData(dataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        
        guard let data = dataModel else {
            return stats
        }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24H Volume", value: data.volume)
        let btcDominants = StatisticModel(title: "BTC Dominants", value: data.btcDominance)
        
        let portfolioValue = portfolioCoins
            .map ({ $0.currentHoldingsValue })
            .reduce(0, +)
        let prevValue =
        portfolioCoins
            .map { (coin) -> Double in
                let currentValue = coin.currentHoldingsValue
                let persentChange = (coin.priceChangePercentage24H ?? 0.0) / 100
                let previousValue = currentValue / ( 1 + persentChange)
                return previousValue
            }
            .reduce(0, +)
        
        let percentageChange = ((portfolioValue - prevValue) / prevValue) * 100
        
        let portfolio = StatisticModel(title: "Portfolio value",
                                       value: portfolioValue.asCurrencyWith2Decimals(),
                                       percentageChange: percentageChange)
        stats.append(contentsOf: [marketCap, volume, btcDominants, portfolio])
        
        return stats
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coins
        }
        let lowercasedText = text.lowercased()
        let filteredCoins = coins.filter { (coin) in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }
        return filteredCoins
    }
    
}
