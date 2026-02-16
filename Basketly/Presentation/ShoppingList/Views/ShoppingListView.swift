//
//  ShoppingListView.swift
//  Basketly
//
//  Created by Modabbir Tarique on 16/02/26.
//

import SwiftUI
import SwiftData

struct ShoppingListView: View {
    
    @Environment(\.modelContext) private var context
    @State private var viewModel: ShoppingListViewModel?
    
    @State private var itemName: String = ""
    @State private var selectedCategory: ProductCategory = .milk
    @State private var editingItem: ShoppingItemViewData?
    
    var body: some View {
        Group {
            if let viewModel {
                content(viewModel)
                    .background(Color.black)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            if viewModel == nil {
                let store = SwiftDataShoppingDataStore(context: context)
                viewModel = ShoppingListViewModel(dataStore: store)
            }
        }
    }
}

private extension ShoppingListView {
    var headerView: some View {
        VStack(spacing: 8) {
            Image(systemName: "cart.fill")
                .font(.system(size: 40))
                .foregroundStyle(.white)
                .padding()
                .background(
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.purple, .blue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
            
            Text("Grocery List")
                .font(.title.bold())
            
            Text("Add items to your shopping list")
                .foregroundColor(.secondary)
        }
    }

    var emptyState: some View {
        ContentUnavailableView(
            "Your grocery list is empty",
            systemImage: "cart",
            description: Text("Add items above to get started")
        )
    }
    
    func addItemCard(_ viewModel: ShoppingListViewModel) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("Add New Item")
                .font(.headline)
                .foregroundStyle(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [.purple, .blue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
            
            Text("Item Name")
                .font(.title3)
                .padding(.horizontal)
            
            TextField("Enter grocery item...", text: $itemName)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            categorySelector
                .padding(.horizontal)
            
            Button {
                if viewModel.addProduct(
                    name: itemName,
                    category: selectedCategory
                ) {
                    itemName = ""
                }
            } label: {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Item")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(
                itemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            )
            .padding(.horizontal)
            .padding(.bottom, 12)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(radius: 4)
        )
    }
    
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
    
    func groupedList(_ viewModel: ShoppingListViewModel) -> some View {
        let grouped = Dictionary(grouping: viewModel.filteredItems) { $0.category }
        
        return List {
            ForEach(ProductCategory.allCases, id: \.self) { category in
                if let items = grouped[category] {
                    Section(category.rawValue) {
                        ForEach(items) { item in
                            ShoppingItemCell(
                                viewData: item,
                                onToggle: { newValue in
                                    viewModel.setPurchased(item, isPurchased: newValue)
                                },
                                onTapToEdit: {
                                    editingItem = item
                                }
                            )
                            .swipeActions {
                                Button(role: .destructive) {
                                    viewModel.deleteProduct(item)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .frame(maxHeight: .infinity)
    }
    
    // MARK: Main Content
    func content(_ viewModel: ShoppingListViewModel) -> some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                headerView
                addItemCard(viewModel)
                
                if viewModel.isEmpty {
                    emptyState
                } else {
                    groupedList(viewModel)
                }
            }
            .padding()
            .toolbar(.hidden, for: .navigationBar)
            .sheet(item: $editingItem) { item in
                EditItemView(
                    viewData: item,
                    onSave: { updated in
                        viewModel.updateProduct(updated)
                    }
                )
            }
            .alert(
                "Error",
                isPresented: Binding(
                    get: { viewModel.errorMessage != nil },
                    set: { _ in viewModel.errorMessage = nil }
                )
            ) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
}

#Preview {
    ShoppingListView()
}
