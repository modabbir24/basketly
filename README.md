# 📦 Basketly – Shopping List App

A simple and clean shopping list application built using **SwiftUI** and **SwiftData**, allowing users to manage grocery items with filtering, editing, and persistent storage.

---

## 🚀 Features

### ✅ Adding Items
- Enter item name  
- Select category (**Milk, Vegetables, Fruits, Breads, Meats**)  
- Add item to list  
- Input field clears after successful addition  

### ✅ Displaying Items
- Items shown in a grouped list by category  
- Each item displays name and category  
- Empty state shown when list is empty  

### ✅ Managing Items
- Mark item as purchased  
- Edit item name and/or category  
- Delete item using swipe action  

### ✅ Filtering & Organization
- Filter items by category  
- Items grouped visually under category sections  

### ✅ Data Persistence
- Built using **SwiftData**  
- Items persist between app launches  

---

## 🏗 Architecture

The app follows a lightweight **MVVM architecture**:

### View
- Responsible for UI rendering  
- Does not directly interact with persistence  
- Passes user actions to ViewModel  

### ViewModel
- Contains business logic  
- Handles item creation, update, deletion  
- Maps persistence models to ViewData  
- Keeps View layer thin  

### Data Layer
- `ShoppingDataStore` protocol defines persistence contract  
- `SwiftDataShoppingDataStore` implements local storage using SwiftData  
- Designed to be extensible for future remote storage support  

---

## 📂 Project Structure

```
Basketly
│
├── Model
│   ├── ShoppingItem.swift
│   ├── ProductCategory.swift
│
├── Persistence
│   ├── ShoppingDataStore.swift
│   ├── SwiftDataShoppingDataStore.swift
│
├── Presentation
│   ├── ShoppingListViewModel.swift
|   ├── Model
|       ├── ShoppingItemViewData.swift
│   |── Views
│       ├── ShoppingListView.swift
│       ├── ShoppingItemCell.swift
│       ├── EditItemView.swift
│       ├── CategoryTile.swift
│
└── App
    └── BasketlyApp.swift
```

---

## 🧠 Design Decisions

- Used **MVVM** to maintain separation of concerns.  
- Avoided using `@Query` directly in the View to keep persistence logic out of the UI layer.  
- Introduced a `DataStore` protocol to allow future scalability (e.g., remote sync).  
- Used a ViewData model to decouple SwiftData model from UI.  

---

## 🛠 Tech Stack

- Xcode 15+  
- Swift 5.9+  
- SwiftUI  
- SwiftData  
- iOS 17+  

---

## ▶️ How to Run

1. Clone the repository  
2. Open `Basketly.xcodeproj`  
3. Run on iOS 17+ simulator or device  

---

## 📌 Future Improvements

- Remote sync support  
- Unit tests for ViewModel  
- Search functionality  
- Offline conflict resolution  
- UI refinements and animations  

---

## 👤 Author

**Modabbir Tarique**  
iOS Developer
