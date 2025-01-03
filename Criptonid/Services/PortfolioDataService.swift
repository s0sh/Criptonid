//
//  PortfolioDataService.swift
//  Criptonid
//
//  Created by Roman Bigun on 03.01.2025.
//

import Foundation
import CoreData

final class PortfolioDataService: ObservableObject {
    
    @Published var savedEntities: [PortfolioEntity] = []
    
    private let container: NSPersistentContainer
    private let name: String = "PortfolioContainer"
    private let entityName = "PortfolioEntity"
    
    init() {
        container = NSPersistentContainer(name: name)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Failed to load persistent stores: \(error)")
            }
        }
        getPortfolio()
    }
    // MARK: - PUBLIC
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        getPortfolio()
        if let entity = savedEntities.first(where: { $0.coinID == coin.id }) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                remove(entity: entity)
            }
            
        } else {
            add(coin: coin, amount: amount)
        }
        applyChanges()
    }
    
    // MARK: - PRIVATES
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching portfolio. Error: \(error.localizedDescription)")
        }
    }
    
    private func add(coin: CoinModel, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        
    }
    
    private func update(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    
    private func remove(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving portfolio. Error: \(error.localizedDescription)")
        }
    }
    
    private func applyChanges() {
        save()
        getPortfolio()
    }
}
