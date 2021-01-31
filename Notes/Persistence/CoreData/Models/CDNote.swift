//
//  CDNote.swift
//  Notes
//
//  Created by Daniel Caklovic on 31.01.2021..
//

import Foundation

extension CDNote: Persistable {

    func asDomain() -> Note {
        return Note(serverId: self.serverId,
                    id: self.id,
                    localId: self.identifier,
                    title: self.title,
                    text: self.text,
                    date: self.date)
    }
    
    func populate(with data: Note, coreDataManager: CoreDataManager) {
        serverId = (data.id != nil) ? "\(data.id ?? UUID())" : "0"
        id = data.id
        title = data.title
        text = data.text
        date = data.date
    }
}
