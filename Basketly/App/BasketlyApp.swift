//
//  BasketlyApp.swift
//  Basketly
//
//  Created by Modabbir Tarique on 16/02/26.
//

import SwiftUI
import SwiftData

@main
struct BasketlyApp: App {
    var body: some Scene {
        WindowGroup {
            ShoppingListView()
        }
        .modelContainer(for: ShoppingItem.self)
    }
}
