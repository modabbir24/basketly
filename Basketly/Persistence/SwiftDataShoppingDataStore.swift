//
//  SwiftDataShoppingDataStore.swift
//  Basketly
//
//  Created by Modabbir Tarique on 16/02/26.
//

import SwiftData
import Foundation

final class SwiftDataShoppingDataStore: ShoppingDataStore {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func fetchItems() throws -> [ShoppingItem] {
        try context.fetch(FetchDescriptor<ShoppingItem>())
    }
    
    func editItem(
        _ item: ShoppingItem,
        name: String?,
        category: ProductCategory?
    ) throws {
        if let name {
            let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return }
            item.name = trimmed
        }
        
        if let category {
            item.category = category
        }
    }
    
    func addItem(_ item: ShoppingItem) throws {
        context.insert(item)
    }
    
    func deleteItem(_ item: ShoppingItem) throws {
        context.delete(item)
    }
    
    func fetchItem(by id: PersistentIdentifier) throws -> ShoppingItem? {
        let descriptor = FetchDescriptor<ShoppingItem>(
            predicate: #Predicate { $0.persistentModelID == id }
        )
        return try context.fetch(descriptor).first
    }
}
