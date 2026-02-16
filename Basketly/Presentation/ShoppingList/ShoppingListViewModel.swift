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

    func addProduct(name: String, category: ProductCategory) -> Bool
    func deleteProduct(_ viewData: ShoppingItemViewData)
    func updateProduct(_ viewData: ShoppingItemViewData) -> Bool
    func setPurchased(_ viewData: ShoppingItemViewData, isPurchased: Bool)
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
    func addProduct(name: String, category: ProductCategory) -> Bool {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }
        
        let isDuplicate = items.contains { item in
            item.name.caseInsensitiveCompare(trimmed) == .orderedSame && item.category == category
        }
        guard !isDuplicate else { return false }
        
        let newItem = ShoppingItem(
            name: trimmed,
            category: category,
            isPurchased: false
        )
        
        do {
            try dataStore.addItem(newItem)
            loadShoppingItems()
            return true
        } catch {
            print("Add failed")
            return false
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
    
    func updateProduct(_ viewData: ShoppingItemViewData) -> Bool {
        let isDuplicate = items.contains { item in
            item.id != viewData.id
                && item.name.caseInsensitiveCompare(viewData.name.trimmingCharacters(in: .whitespacesAndNewlines)) == .orderedSame
                && item.category == viewData.category
        }
        guard !isDuplicate else { return false }
        
        do {
            guard let item = try dataStore.fetchItem(by: viewData.id) else { return false }
            
            try dataStore.editItem(
                item,
                name: viewData.name,
                category: viewData.category,
                isPurchased: viewData.isPurchased
            )
            
            loadShoppingItems()
            return true
        } catch {
            print("Update failed")
            return false
        }
    }
    
    func setPurchased(_ viewData: ShoppingItemViewData, isPurchased: Bool) {
        var updated = viewData
        updated.isPurchased = isPurchased
        _ = updateProduct(updated)
    }
}
