//
//  ShoppingItemCell.swift
//  Basketly
//
//  Created by Modabbir Tarique on 16/02/26.
//

import SwiftUI

struct ShoppingItemCell: View {
    
    let viewData: ShoppingItemViewData
    let onToggle: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(viewData.name)
                    .strikethrough(viewData.isPurchased)
                
                Text(viewData.category.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: onToggle) {
                Image(systemName: viewData.isPurchased ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(viewData.isPurchased ? .green : .gray)
            }
        }
    }
}
