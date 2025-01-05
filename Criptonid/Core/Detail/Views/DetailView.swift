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
    
    @State private var showFullDescription: Bool = false
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    private let spacing: CGFloat = 30
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    ChartView(coin: vm.coin)
                        .padding(.vertical)
                    VStack(spacing: 20) {
                        overviewTitle
                        Divider()
                        descriptionSection
                        overviewGrid
                        additionalInfoTitle
                        Divider()
                        additionalGrid
                        Divider()
                        linksSection
                    }
                    .padding()
                }
            }
            .navigationTitle(vm.coin.name)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    navigationBarTrailingItems
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DetailView(coin: DeveloperPreview.instance.coin)
    }
}

extension DetailView {
    private var navigationBarTrailingItems: some View {
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.secondaryText)
            CoinImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
        }
    }
    
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var descriptionSection: some View {
        ZStack {
            if let coinDescription = vm.coinDescriprtion,
                !coinDescription.isEmpty {
                
                VStack(alignment: .leading) {
                    Text(coinDescription)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundColor(Color.theme.secondaryText)
                    
                    Button {
                        withAnimation(.easeInOut) {
                            showFullDescription.toggle()
                        }
                    } label: {
                        Text(showFullDescription ? "Less" : "Read more...")
                    }
                    .accentColor(.blue)
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.vertical, 4)

                }
            }
        }
    }
    
    private var additionalInfoTitle: some View {
        Text("Additional details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overviewGrid: some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: spacing,
                  pinnedViews: []) {
            ForEach(vm.overviewStatistics) { stat in
                StatisticView(stat: stat)
            }
        }
    }
    
    private var linksSection: some View {
        ZStack {
            HStack {
                if let websiteString = vm.homepageLink,
                   let url = URL(string: websiteString) {
                    Link("Hope page", destination: url)
                }
                Spacer()
                if let reditString = vm.redditLink,
                   let url = URL(string: reditString) {
                    Link("Reddit page", destination: url)
                }
            }
            .frame(alignment: .leading)
            .padding([.leading, .trailing], 10)
        }
        .accentColor(.blue)
        .font(.headline)
    }
    private var additionalGrid: some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: spacing,
                  pinnedViews: []) {
            ForEach(vm.additionalStatistics) { stat in
                StatisticView(stat: stat)
            }
        }
    }
}
