//
//  Persistence.swift
//  TravelWell
//
//  Created by Callum Graham on 08/11/2021.
//

import CoreData

import CoreData

struct PersistenceController{
    
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(){
        container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores {(desctiption, error) in
            if let error = error {
                fatalError("Error: \(error)") //crash app when error occurs and print
            }
            
        }
    }
    
    func save(completion: @escaping (Error?) -> () = {_ in}){
        let context = container.viewContext
        if context.hasChanges {             //don't save if no changes
            do {
                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    func delete(_ object: NSManagedObject, completion: @escaping (Error?) -> () = {_ in}) {
        let context = container.viewContext
        context.delete(object)
        save(completion: completion)
    }
}

