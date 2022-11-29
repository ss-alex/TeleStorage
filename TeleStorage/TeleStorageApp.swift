//
//  TeleStorageApp.swift
//  TeleStorage
//
//  Created by Alexey on 2022-11-27.
//

import SwiftUI

@main
struct TeleStorageApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            AuthView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
