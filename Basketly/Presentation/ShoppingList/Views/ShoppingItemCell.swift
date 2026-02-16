//
//  ShoppingItemCell.swift
//  Basketly
//
//  Created by Modabbir Tarique on 16/02/26.
//

import SwiftUI

struct ShoppingItemCell: View {
    
    let viewData: ShoppingItemViewData
    var onToggle: (Bool) -> Void
    var onTapToEdit: (() -> Void)?
    
    var body: some View {
        HStack(spacing: 8) {
            
            VStack(alignment: .leading, spacing: 4) {
                Text(viewData.name)
                    .strikethrough(viewData.isPurchased)
                
                Text(viewData.category.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                onTapToEdit?()
            }
            
            Spacer()
            
            Toggle("", isOn: Binding(
                get: { viewData.isPurchased },
                set: { onToggle($0) }
            ))
            .labelsHidden()
        }
    }
}
