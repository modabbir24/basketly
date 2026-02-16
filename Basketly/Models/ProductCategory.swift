//
//  ProductCategory.swift
//  Basketly
//
//  Created by Modabbir Tarique on 16/02/26.
//

import SwiftUI

enum ProductCategory: String, CaseIterable, Codable {
    case milk = "Milk"
    case vegetables = "Vegetables"
    case fruits = "Fruits"
    case breads = "Breads"
    case meats = "Meats"
}

extension ProductCategory {
    
    var iconName: String {
        switch self {
        case .milk:
            return "cup.and.saucer.fill"
        case .vegetables:
            return "leaf.fill"
        case .fruits:
            return "applelogo"
        case .breads:
            return "takeoutbag.and.cup.and.straw.fill"
        case .meats:
            return "flame.fill"
        }
    }
}

extension ProductCategory {
    
    var color: Color {
        switch self {
        case .milk:
            return .blue
        case .vegetables:
            return .green
        case .fruits:
            return .red
        case .breads:
            return .orange
        case .meats:
            return .pink
        }
    }
}
