//
//  BaseModel.swift
//  Notes
//
//  Created by Daniel Caklovic on 31.01.2021..
//

import Foundation
import CoreData

/// Represents Domain model
protocol BaseModel: Codable, Identifiable {
    associatedtype CoreDataType: Persistable
    
    /// In case your API does not provide an id, make sure to define a custom one.
    var id: UUID? { get set }
    
    var localId: String? { get set }
    
    /// Associates a notification name with this data type.
    /// This notification is sent when data is updated.
    /// Nil by default (no notification is sent).
    static var notificationName: Notification.Name { get }
    
    func getCDObject(using coreDataManager: CoreDataManager, context: NSManagedObjectContext) -> CoreDataType
    
    func valuesDictionary() -> [String: Any]
}

extension BaseModel {
    
    static var typeName: String { return String(describing: self) }
    
    static var notificationName: Notification.Name { return Notification.Name(typeName) }
    
    func valuesDictionary() -> [String: Any] {
        return [:]
    }
}
