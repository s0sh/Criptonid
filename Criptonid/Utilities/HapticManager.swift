//
//  HapticManager.swift
//  Criptonid
//
//  Created by Roman Bigun on 04.01.2025.
//

import Foundation
import SwiftUI
import CoreHaptics

final class HapticManager {
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
