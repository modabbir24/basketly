//
//  EditItemView.swift
//  Basketly
//
//  Created by Modabbir Tarique on 16/02/26.
//

import SwiftUI

struct EditItemView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String
    @State private var selectedCategory: ProductCategory
    
    private let originalItem: ShoppingItemViewData
    /// Called when user taps Save. Returns true if save succeeded (caller may dismiss), false if duplicate.
    private let onSave: (ShoppingItemViewData) -> Bool
    
    init(
        viewData: ShoppingItemViewData,
        onSave: @escaping (ShoppingItemViewData) -> Bool
    ) {
        self.originalItem = viewData
        self._name = State(initialValue: viewData.name)
        self._selectedCategory = State(initialValue: viewData.category)
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                TextField("Item name", text: $name)
                    .textFieldStyle(.roundedBorder)
                
                categorySelector
                
                Spacer()
            }
            .padding()
            .navigationTitle("Edit Item")
            .toolbar {
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty || (selectedCategory == originalItem.category && name == originalItem.name))
                }
            }
        }
    }
}

private extension EditItemView {
    
    var categorySelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(ProductCategory.allCases, id: \.self) { category in
                    CategoryTile(
                        category: category,
                        isSelected: selectedCategory == category
                    )
                    .onTapGesture {
                        selectedCategory = category
                    }
                }
            }
        }
    }
    
    func save() {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var updated = originalItem
        updated.name = trimmed
        updated.category = selectedCategory
        
        if onSave(updated) {
            dismiss()
        }
    }
}
