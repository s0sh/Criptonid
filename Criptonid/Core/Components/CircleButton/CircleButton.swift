//
//  CircleButton.swift
//  Criptonid
//
//  Created by Roman Bigun on 31.12.2024.
//

import SwiftUI

struct CircleButton: View {
    let iconName: String
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundColor(Color.theme.accent)
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .foregroundColor(Color.theme.background)
            )
            .shadow(color: Color.theme.accent.opacity(0.25), radius: 10)
    }
}

#Preview {
    CircleButton(iconName: "heart.fill")
        .padding()
        .previewLayout(.sizeThatFits)
}
