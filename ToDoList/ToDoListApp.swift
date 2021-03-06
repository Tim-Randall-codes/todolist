//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Tim Randall on 21/9/21.
//

import SwiftUI
import CoreData

@main
struct ToDoListApp: App {
    let persistenceContainer = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, persistenceContainer.container.viewContext)
        }
    }
}
