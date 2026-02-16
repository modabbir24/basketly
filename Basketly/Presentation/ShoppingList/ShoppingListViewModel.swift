//
//  ShoppingListViewModel.swift
//  Basketly
//
//  Created by Modabbir Tarique on 16/02/26.
//

import Foundation
import Observation
import SwiftData

protocol ShoppingListViewModelProtocol: AnyObject {
    var filteredItems: [ShoppingItemViewData] { get }
    var isEmpty: Bool { get }
    
    func addProduct(name: String, category: ProductCategory)
    func deleteProduct(_ viewData: ShoppingItemViewData)
    func updateProduct(_ viewData: ShoppingItemViewData)
    func togglePurchased(_ viewData: ShoppingItemViewData)
}

@Observable
final class ShoppingListViewModel {
    private let dataStore: ShoppingDataStore
    private(set) var items: [ShoppingItemViewData] = []
    var selectedFilter: ProductCategory?
    
    init(dataStore: ShoppingDataStore) {
        self.dataStore = dataStore
        loadShoppingItems()
    }
    
    private func loadShoppingItems() {
        do {
            let persistanceItems = try dataStore.fetchItems()
            self.items = mapToViewData(persistanceItems)
        } catch {
            items = []
        }
    }
    
    private func mapToViewData(_ items: [ShoppingItem]) -> [ShoppingItemViewData] {
        items.map {
            ShoppingItemViewData(
                id: $0.persistentModelID,
                name: $0.name,
                category: $0.category,
                isPurchased: $0.isPurchased
            )
        }
    }
}

extension ShoppingListViewModel: ShoppingListViewModelProtocol {
    func addProduct(name: String, category: ProductCategory) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        let newItem = ShoppingItem(
            name: trimmed,
            category: category,
            isPurchased: false
        )
        
        do {
            try dataStore.addItem(newItem)
            loadShoppingItems()
        } catch {
            print("Add failed")
        }
    }
    
    var filteredItems: [ShoppingItemViewData] {
        guard let selectedFilter else { return items }
        return items.filter { $0.category == selectedFilter }
    }

    var isEmpty: Bool {
        filteredItems.isEmpty
    }

    func deleteProduct(_ viewData: ShoppingItemViewData) {
        do {
            guard let item = try dataStore.fetchItem(by: viewData.id) else { return }
            
            try dataStore.deleteItem(item)
            loadShoppingItems()
        } catch {
            print("Delete failed")
        }
    }
    
    func updateProduct(_ viewData: ShoppingItemViewData) {
        do {
            guard let item = try dataStore.fetchItem(by: viewData.id) else { return }
            
            try dataStore.editItem(
                item,
                name: viewData.name,
                category: viewData.category
            )
            
            loadShoppingItems()
        } catch {
            print("Update failed")
        }
    }
    
    func togglePurchased(_ viewData: ShoppingItemViewData) {
        var updated = viewData
        updated.isPurchased.toggle()
        updateProduct(updated)
    }
}
