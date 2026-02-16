//
//  CategoryTile.swift
//  Basketly
//
//  Created by Modabbir Tarique on 16/02/26.
//

import SwiftUI

struct CategoryTile: View {
    
    let category: ProductCategory
    let isSelected: Bool
    
    var body: some View {
        VStack {
            Image(systemName: category.iconName)
                .font(.title2)
            
            Text(category.rawValue)
                .font(.caption)
        }
        .padding()
        .frame(width: 90)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? category.color.opacity(0.3) : Color.gray.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? category.color : Color.clear, lineWidth: 2)
        )
    }
}
