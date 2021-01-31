//
//  CoreDataStack.swift
//  Notes
//
//  Created by Daniel Caklovic on 31.01.2021..
//

import CoreData

// sourcery: factory = CoreDataStackImpl, singleton
protocol CoreDataStack {
    var persistentContainer: NSPersistentContainer { get }
    
    /// Executes and saves any context changes in a single synchronous operation queue.
    /// This makes sure there are no merge conflicts between different contexts.
    /// https://stackoverflow.com/a/42745378/8249743
    func enqueue(block: @escaping (_ context: NSManagedObjectContext) -> Void)
    
    /// Relevant when doing Batch deletes.
    /// Batch deletes are only available when you are using a SQLite persistent store.
    /// https://developer.apple.com/library/archive/featuredarticles/CoreData_Batch_Guide/BatchDeletes/BatchDeletes.html
    func isPersistentStore() -> Bool
    
    /// Forcefully saves changes to the main context
    func saveContext()
}

/// This helper provides instance to Core Data managed object context
class CoreDataStackImpl: CoreDataStack {
    
    lazy var persistentContainerQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: Constants.persistentContainerName)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
            }
        })
        return container
    }()
    
    func enqueue(block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainerQueue.addOperation {
            let context = self.persistentContainer.newBackgroundContext()
            context.mergePolicy = NSMergePolicy.overwrite
            context.performAndWait {
                block(context)
                self.saveChanges(for: context)
            }
        }
    }
    
    func isPersistentStore() -> Bool {
        return true
    }
    
    func saveContext() {
        saveChanges(for: persistentContainer.viewContext)
    }
    
    private func saveChanges(for context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
                //context.reset()
            } catch {
                if !ApiConfig.isProduction {
                    fatalError(error.localizedDescription)
                }
            }
        }
    }
}

/// This helper provides instance to Core Data managed object context used for testing
class CoreDataStackMock: CoreDataStack {
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: Constants.persistentContainerName,
                                              managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false // Make it simpler in test env
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, _) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )
        }
        return container
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application.
        let modelURL = Bundle.main.url(forResource: Constants.persistentContainerName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    func enqueue(block: @escaping (NSManagedObjectContext) -> Void) {
        let context = persistentContainer.viewContext
        block(context)
        try? context.save()
    }
    
    func saveContext() {
        try? persistentContainer.viewContext.save()
    }
    
    func isPersistentStore() -> Bool {
        return false
    }
}
