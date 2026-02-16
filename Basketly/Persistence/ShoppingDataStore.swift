//
//  ShoppingDataStore.swift
//  Basketly
//
//  Created by Modabbir Tarique on 16/02/26.
//

import SwiftData

protocol ShoppingDataStore {
    func fetchItems() throws -> [ShoppingItem]
    func editItem(_ item: ShoppingItem, name: String?, category: ProductCategory?, isPurchased: Bool?) throws
    func addItem(_ item: ShoppingItem) throws
    func deleteItem(_ item: ShoppingItem) throws
    func fetchItem(by id: PersistentIdentifier) throws -> ShoppingItem?
}
