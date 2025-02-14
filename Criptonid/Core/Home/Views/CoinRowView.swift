//
//  CoinRowView.swift
//  Criptonid
//
//  Created by Roman Bigun on 31.12.2024.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin: CoinModel
    let showHoldingsColumn: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            
            leftColumn
            
            Spacer()
            
            if showHoldingsColumn {
                centerView
            }
            
            rightView
            
        }
        .font(.subheadline)
      //  .background(Color.theme.background).opacity(0.001)
    }
}

#Preview {
    CoinRowView(coin: DeveloperPreview.instance.coin, showHoldingsColumn: true)
            .previewLayout(.sizeThatFits)
    
}

extension CoinRowView {
    private var leftColumn: some View {
        HStack(spacing: 0) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .frame(minWidth: 30)
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(Color.theme.accent)
        }
    }
    
    private var centerView: some View {
        HStack(spacing: 0) {
            VStack(alignment: .trailing) {
                Text(coin.currentHoldingsValue.asCurrencyWith6Decimals())
                    .bold()
                Text((coin.currentHoldings ?? 0).asNumberString())
            }
            .foregroundColor(Color.theme.accent)
        }
    }
    
    private var rightView: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWith2Decimals())
                .bold()
                .foregroundColor(Color.theme.accent)
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                .foregroundColor(
                    (coin.priceChangePercentage24H ?? 0 > 0) ?
                    Color.theme.green :
                    Color.theme.red
                )
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
    
}
