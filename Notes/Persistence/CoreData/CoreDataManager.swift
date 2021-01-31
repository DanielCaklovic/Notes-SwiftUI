//
//  CoreDataManager.swift
//  Notes
//
//  Created by Daniel Caklovic on 31.01.2021..
//

import CoreData

// sourcery: factory = CoreDataManagerImpl, singleton
protocol CoreDataManager {
    /// Returns a new NSManagedObject instance of the specified class type contained within the context.
    ///
    /// - Parameter type: Class type of object to be returned
    /// - Returns: New instance of core data object
    func create<T: Persistable>(_ type: T.Type, context: NSManagedObjectContext) -> T
    
    /// Syncs and saves current core data representable object to Core Data persistence, matched by their local id's.
    /// If the object does not exist, creates and saves a new one.
    ///
    /// - Parameter entity: Object to sync
    /// - Returns: Core Data observable object
    func syncLocal<C: BaseModel, P>(entity: C,
                                    context: NSManagedObjectContext) -> P where P == C.CoreDataType, C == P.DomainType
    
    /// Tries to find an object of type 'type' by its id.
    /// If it does not exist, creates a new one instead with the specified id.
    /// Make sure the object has an 'id' property of type Int32.
    /// Use this method for saving objects (creating or updating).
    ///
    /// - Parameters:
    ///   - type: Class type of object to be returned
    ///   - uid: id of an existing object (if it does not exist, returns a new object)
    /// - Returns: New (or existing) core data object
    func getExistingOrNew<C: BaseModel, P>(entity: C,
                                           context: NSManagedObjectContext) -> P where P == C.CoreDataType, C == P.DomainType
    
    /// Returns a single object by its id.
    ///
    /// - Parameters:
    ///   - type: Class type of object to be returned
    ///   - id: id of the object
    /// - Returns: Core data object
    func findById<T: Persistable>(_ type: T.Type, id: String, context: NSManagedObjectContext) -> T?
    
    /// Returns a single object matching specified predicate.
    ///
    /// - Parameters:
    ///   - type: Class type of object to be returned
    ///   - predicate: Predicate to be matched by
    /// - Returns: Core data object
    func findFirst<T: Persistable>(_ type: T.Type, predicate: NSPredicate?, context: NSManagedObjectContext) -> T?
    
    /// Returns a list of objects matching specified class type, sorting order and predicate.
    ///
    /// - Parameters:
    ///   - type: Class type of object to be returned
    ///   - sortDescriptors: Sorting rules
    ///   - predicate: Filtering rules
    /// - Returns: List of core data objects
    func findAll<T: Persistable>(_ type: T.Type,
                                 sortDescriptors: [NSSortDescriptor],
                                 predicate: NSPredicate?,
                                 fetchLimit: Int,
                                 context: NSManagedObjectContext) -> [T]
    
    /// Delete an object from Core Data.
    ///
    /// - Parameter object: Object to be deleted.
    func delete<T: Persistable>(_ object: T, context: NSManagedObjectContext)
    
    /// Delete list of objects from Core Data.
    ///
    /// - Parameter objects: Objects to delete.
    func delete<T: Persistable>(_ objects: [T], context: NSManagedObjectContext)
    
    /// Clears Core Data database.
    func deleteAllData(context: NSManagedObjectContext)
    
    /// Deletes all core data objects of specified model class.
    /// Does not work for mocked core data contexts.
    ///
    /// - Parameter entity: Class type of object to be deleted.
    func deleteAllEntities<T: Persistable>(entity: T.Type, context: NSManagedObjectContext)
    
    /// Deletes all core data objects of specified model class, searched by predicate.
    /// Does not work for mocked core data contexts.
    ///
    /// - Parameter entity: Class type of object to be deleted.
    /// - Parameter predicate: NSPredicate, optional
    func deleteAllEntitiesByPredicate<T: Persistable>(entity: T.Type, predicate: NSPredicate?, context: NSManagedObjectContext)
    
    func batchSaveEntities<C: BaseModel, P>(entities: [C], entity: P.Type, context: NSManagedObjectContext) where P == C.CoreDataType, C == P.DomainType
}

extension CoreDataManager {
    func findAll<T: Persistable>(_ type: T.Type,
                                 sortDescriptors: [NSSortDescriptor] = T.defaultSortDescriptor,
                                 predicate: NSPredicate?,
                                 fetchLimit: Int = 500,
                                 context: NSManagedObjectContext) -> [T] {
        return findAll(type, sortDescriptors: sortDescriptors, predicate: predicate, fetchLimit: fetchLimit, context: context)
    }
}

class CoreDataManagerImpl: CoreDataManager {
    
    func create<T: Persistable>(_ type: T.Type, context: NSManagedObjectContext) -> T {
        let entity = NSEntityDescription.entity(forEntityName: String(describing: type), in: context)!
        let object = type.init(entity: entity, insertInto: context)
        object.identifier = object.objectID.uriRepresentation().lastPathComponent
        return object
    }
    
    func syncLocal<C: BaseModel, P>(entity: C, context: NSManagedObjectContext) -> P where P == C.CoreDataType, C == P.DomainType {
        let object = getExistingOrNew(entity: entity, context: context)
        object.populate(with: entity, coreDataManager: self)
        return object
    }
    
    func getExistingOrNew<C: BaseModel, P>(entity: C, context: NSManagedObjectContext) -> P where P == C.CoreDataType, C == P.DomainType {
        return findById(P.self, id: entity.localId ?? "noid", context: context) ?? create(P.self, context: context)
    }
    
    func findById<T: Persistable>(_ type: T.Type, id: String, context: NSManagedObjectContext) -> T? {
        let predicate = NSPredicate(format: "\(T.identifierName) = %@", id)
        return findFirst(type, predicate: predicate, context: context)
    }
    
    func findFirst<T: Persistable>(_ type: T.Type, predicate: NSPredicate?, context: NSManagedObjectContext) -> T? {
        return findAll(type, predicate: predicate, fetchLimit: 1, context: context).first
    }
    
    func findAll<T: Persistable>(_ type: T.Type,
                                 sortDescriptors: [NSSortDescriptor],
                                 predicate: NSPredicate?,
                                 fetchLimit: Int,
                                 context: NSManagedObjectContext) -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: type))
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        if fetchLimit > 0 {
            fetchRequest.fetchLimit = fetchLimit
        }
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            
            if !ApiConfig.isProduction {
                fatalError(error.localizedDescription)
            }
        }
        return []
    }
    
    func delete<T: Persistable>(_ object: T, context: NSManagedObjectContext) {
        context.delete(object)
    }
    
    func delete<T: Persistable>(_ objects: [T], context: NSManagedObjectContext) {
        objects.forEach { delete($0, context: context) }
    }
    
    func deleteAllEntities<T: NSManagedObject>(entity: T.Type, context: NSManagedObjectContext) {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: entity))
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try context.execute(request)
        } catch {
            
            if !ApiConfig.isProduction {
                fatalError(error.localizedDescription)
            }
        }
        //context.reset()
    }
    
    func deleteAllEntitiesByPredicate<T: Persistable>(entity: T.Type, predicate: NSPredicate?, context: NSManagedObjectContext) {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: entity))
        fetch.predicate = predicate
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try context.execute(request)
        } catch {
            
            if !ApiConfig.isProduction {
                fatalError(error.localizedDescription)
            }
        }
        //context.reset()
    }
    
    func batchSaveEntities<C: BaseModel, P>(entities: [C], entity: P.Type, context: NSManagedObjectContext) where C == P.DomainType, P == C.CoreDataType {
        if #available(iOS 13.0, *) {
            let mapedValues = entities.map { $0.valuesDictionary() }
            let updateRequest = NSBatchUpdateRequest(entityName: String(describing: entity))
            updateRequest.propertiesToUpdate = [:]
            let request = NSBatchInsertRequest(entityName: String(describing: entity), objects: mapedValues)
            request.resultType = .objectIDs
            do {
                try context.execute(request)
                try context.save()
            } catch {
                
                if !ApiConfig.isProduction {
                    fatalError(error.localizedDescription)
                }
            }
            //context.reset()
        } else {
            // Fallback on earlier versions
        }
    }
}

