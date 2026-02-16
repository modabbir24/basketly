//
//  ShoppingItemCell.swift
//  Basketly
//
//  Created by Modabbir Tarique on 16/02/26.
//

import SwiftUI

struct ShoppingItemCell: View {
    
    let viewData: ShoppingItemViewData
    @Binding var isPurchased: Bool
    var onTapToEdit: (() -> Void)?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(viewData.name)
                    .strikethrough(isPurchased)
                
                Text(viewData.category.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                onTapToEdit?()
            }
            
            Spacer()
            
            Toggle("", isOn: $isPurchased)
                .toggleStyle(.switch)
                .labelsHidden()
        }
    }
}
