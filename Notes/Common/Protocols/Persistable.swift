//
//  Persistable.swift
//  Notes
//
//  Created by Daniel Caklovic on 31.01.2021..
//

import CoreData

/// Represents Core Data model
protocol Persistable where Self: NSManagedObject {
    associatedtype DomainType
    
    var identifier: String? { get set }
    
    var serverId: String? { get set }
    
    func asDomain() -> DomainType
    func populate(with data: DomainType, coreDataManager: CoreDataManager)
}

extension Persistable {
    
    static var identifierName: String { return "identifier" }
    
    public static var defaultSortDescriptor: [NSSortDescriptor] {
        return [NSSortDescriptor(key: identifierName, ascending: true)]
    }
}
