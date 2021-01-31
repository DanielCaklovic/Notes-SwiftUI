//
//  NoteItem.swift
//  Notes
//
//  Created by Daniel Caklovic on 31.01.2021..
//

import Foundation

struct NoteItem: Identifiable {
    let title: String
    let text: String
    let date: String
    let id: String = UUID().uuidString
}
