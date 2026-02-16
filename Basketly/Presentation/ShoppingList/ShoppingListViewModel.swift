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
    var errorMessage: String? { get set }

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
    var errorMessage: String?
    
    init(dataStore: ShoppingDataStore) {
        self.dataStore = dataStore
        loadShoppingItems()
    }
    
    private func loadShoppingItems() {
        do {
            let persistanceItems = try dataStore.fetchItems()
            self.items = mapToViewData(persistanceItems)
        } catch {
            errorMessage = "Failed to load items."
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
        
        guard !isDuplicate else {
            errorMessage = "Item already exists in this category."
            return false
        }
        
        let newItem = ShoppingItem(
            name: trimmed,
            category: category,
            isPurchased: false
        )
        
        do {
            try dataStore.addItem(newItem)
            items.append(
                ShoppingItemViewData(
                    id: newItem.persistentModelID,
                    name: trimmed,
                    category: category,
                    isPurchased: false
                )
            )
            return true
        } catch {
            self.errorMessage = "Failed to add item."
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
            items.removeAll { $0.id == viewData.id }
        } catch {
            self.errorMessage = "Failed to delete item."
        }
    }
    
    func updateProduct(_ viewData: ShoppingItemViewData) -> Bool {
        let trimmedName = viewData.name.trimmingCharacters(in: .whitespacesAndNewlines)
        let isDuplicate = items.contains { item in
            item.id != viewData.id
                && item.name.caseInsensitiveCompare(trimmedName) == .orderedSame
                && item.category == viewData.category
        }
        
        guard !isDuplicate else {
            errorMessage = "Item already exists in this category."
            return false
        }
        
        do {
            guard let item = try dataStore.fetchItem(by: viewData.id) else { return false }
            
            try dataStore.editItem(
                item,
                name: trimmedName,
                category: viewData.category,
                isPurchased: viewData.isPurchased
            )
            
            if let index = items.firstIndex(where: { $0.id == viewData.id }) {
                items[index] = ShoppingItemViewData(
                    id: viewData.id,
                    name: trimmedName,
                    category: viewData.category,
                    isPurchased: viewData.isPurchased
                )
            }

            return true
        } catch {
            self.errorMessage = "Failed to update item."
            return false
        }
    }
    
    func setPurchased(_ viewData: ShoppingItemViewData, isPurchased: Bool) {
        var updated = viewData
        updated.isPurchased = isPurchased
        _ = updateProduct(updated)
    }
}
