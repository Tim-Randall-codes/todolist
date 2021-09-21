//
//  contactinfostorageApp.swift
//  contactinfostorage
//
//  Created by Tim Randall on 19/9/21.
//

import SwiftUI
import CoreData

@main
struct contactinfostorageApp: App {
    let persistenceContainer = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, persistenceContainer.container.viewContext)
        }
    }
}
