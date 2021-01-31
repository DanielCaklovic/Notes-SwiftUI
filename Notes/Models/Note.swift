//
//  Note.swift
//  Notes
//
//  Created by Daniel Caklovic on 31.01.2021..
//

import Foundation

struct Note: BaseModel {
    var serverId: String?
    var id: UUID?
    var localId: String?
    var title: String?
    var text: String?
    var date: Date?
}
