//
//  HomeView.swift
//  Criptonid
//
//  Created by Roman Bigun on 31.12.2024.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    
    @State private var showPortfolio = false // Animate right
    @State private var showPortfolioView = false // Show new sheet
    @State private var selectedCoin: CoinModel?
    @State private var showDetailsView = false
    
    var body: some View {
        
        ZStack {
            
            //MARK: - Background layer
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView) {
                    PortfolioView()
                }
            
            //MARK: - Content layer
            VStack {
                
                // Header
                homeHeader
                
                // Statistic views
                HomeStatsView(showPortfolio: $showPortfolio)
                    .padding(.top, 10)
                // Search bar
                SearchBarView(searchText: $vm.searchText)
                    
                // Titles
                columnTitles
                
                // Right transition
                if !showPortfolio {
                    allCoinsList
                        .transition(.move(edge: .leading))
                        .refreshable {
                        vm.refreshData()
                    }
                }
                
                // left transition. show portfolio
                if showPortfolio {
                    coinsPortfolioList
                        .transition(.move(edge: .trailing))
                        .refreshable {
                        vm.refreshData()
                    }
                }
                
                Spacer(minLength: 0)
            }
        }
        .background (
            NavigationLink(destination: DetailLoadingView(coin: $selectedCoin),
                           isActive: $showDetailsView,
                           label: { EmptyView() })
        )
    }
}

#Preview {
    NavigationView {
        HomeView()
            .navigationBarHidden(true)
    }
    .environmentObject(DeveloperPreview.instance.homeVM)
}

extension HomeView {
    private var homeHeader: some View {
        HStack {
            CircleButton(iconName: showPortfolio ? "plus" : "info")
                .animation(.none)
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    }
                }
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none)
            Spacer()
            CircleButton(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var allCoinsList: some View {
        List {
            ForEach(vm.allCoins) { coin in
                    CoinRowView(coin: coin, showHoldingsColumn: false)
                        .listRowInsets(.init(top: 10,
                                             leading: 0,
                                             bottom: 10,
                                             trailing: 10))
                        .onTapGesture {
                            segue(coin: coin)
                        }

            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var coinsPortfolioList: some View {
        List {
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10,
                                         leading: 0,
                                         bottom: 10,
                                         trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    
    private func segue(coin: CoinModel) {
        selectedCoin = coin
        showDetailsView.toggle()
    }
    
    private var columnTitles: some View {
        HStack {
            HStack(spacing: 4) {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = (vm.sortOption == .rank ? .rankReversed : .rank)
                }
            }
            
            Spacer()
            
            if showPortfolio {
                HStack(spacing: 4) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity((vm.sortOption == .holdings || vm.sortOption == .holdingReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.default) {
                        vm.sortOption = (vm.sortOption == .holdings ? .holdingReversed : .holdings)
                    }
                }
            }
            
            HStack(spacing: 4) {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = (vm.sortOption == .price ? .priceReversed : .price)
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
    }
}
