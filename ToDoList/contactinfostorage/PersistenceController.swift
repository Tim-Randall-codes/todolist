//
//  PersistenceController.swift
//  coredatatemplate
//
//  Created by Tim Randall on 18/9/21.
//

import Foundation
import CoreData

// this first part will have the container of the objects equal what is in the Stash file.
// if the things in the Stash can not be loaded the error will be turned into a fatal error which will crash the app

struct PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer
    init() {
        container = NSPersistentContainer(name: "Stash")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    // this method will see if there are any changes to the container's contents.
    // if there are it will save them.
    
    func save(completion: @escaping (Error?) -> () = {_ in}) {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    // this method will take an object as an argument. Then it will delete the object
    // if it is in the container
    
    func delete(_ object: NSManagedObject, completion: @escaping (Error?) -> () = {_ in}) {
        let context = container.viewContext
        context.delete(object)
        save(completion: completion)
    }
}


