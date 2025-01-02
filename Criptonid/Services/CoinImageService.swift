//
//  CoinImageService.swift
//  Criptonid
//
//  Created by Roman Bigun on 02.01.2025.
//

import Foundation
import SwiftUI
import Combine

final class CoinImageService {
    
    @Published var image: UIImage?
    
    private let fileManager = LocalFileManager.instance
    private var imageSubscription: AnyCancellable?
    private let coin: CoinModel
    private let folderName = "coin_images"
    private let imageName: String
    
    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage() {
        if let image = fileManager.getImage(imageName: imageName, folderName: folderName) {
            self.image = image
            print("Retrieved image from file manager")
        } else {
            downloadCoinImage()
            print("Download image now...")
        }
    }
    
    private func downloadCoinImage() {
        
        guard let url = URL(string: coin.image) else { return }
        
        imageSubscription = NetworkManager.download(url: url)
            .tryMap({ data -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] (returnedImage) in
                guard let self = self, let downloadedImage = returnedImage else { return }
                self.image = downloadedImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadedImage,
                                           imageName: self.imageName,
                                           folderName: self.folderName)
            })
    }
}
