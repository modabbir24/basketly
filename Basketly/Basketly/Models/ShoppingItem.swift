//
//  ShoppingItem.swift
//  Basketly
//
//  Created by Modabbir Tarique on 16/02/26.
//

import Foundation
import SwiftData

@Model
final class ShoppingItem {
    var name: String
    var category: ProductCategory
    var isPurchased: Bool
    
    init(
        name: String,
        category: ProductCategory,
        isPurchased: Bool
    ) {
        self.name = name
        self.category = category
        self.isPurchased = isPurchased
    }
}
