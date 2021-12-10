import CoreData
import TravelWell   

struct TestingEnvironmentPersistenceController{
    
    static var shared = TestingEnvironmentPersistenceController()
    
    let container: NSPersistentContainer
    
    init(){
        container = NSPersistentContainer(name: "Model")
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        container.persistentStoreDescriptions = [description]
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
