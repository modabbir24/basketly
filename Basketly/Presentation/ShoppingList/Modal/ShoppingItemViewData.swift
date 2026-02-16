//
//  ShoppingItemViewData.swift
//  Basketly
//
//  Created by Modabbir Tarique on 16/02/26.
//

import SwiftData

struct ShoppingItemViewData: Identifiable, Equatable {
    let id: PersistentIdentifier
    var name: String
    var category: ProductCategory
    var isPurchased: Bool
}
