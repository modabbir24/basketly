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
        VStack(spacing: 8) {
            Image(systemName: category.iconName)
                .font(.title)
            
            Text(category.rawValue)
                .font(.title3)
                .foregroundColor(isSelected ? Color.white : category.color)
        }
        .padding()
        .frame(width: 90, height: 90)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? Color.blue.opacity(0.8) : category.color.opacity(0.3))
        )
    }
}
