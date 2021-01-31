//
//  NoteRepository.swift
//  Notes
//
//  Created by Daniel Caklovic on 31.01.2021..
//

import Foundation
import Combine
import CoreData

protocol NoteRepository {
    func getNotes() -> AnyPublisher<[Note], Error>
    func getNote(id: String) -> AnyPublisher<Note, Error>
    func deleteNote(id: String) -> AnyPublisher<Note, Error>
    func updateNote(id: String) -> AnyPublisher<Note, Error>
    func createNote(id: String) -> AnyPublisher<Note, Error>
}

class NoteRepositoryImpl: NoteRepository {
    func getNotes() -> AnyPublisher<[Note], Error> {
        let fetchNotes = Future<[Note], Error> {_ in }
        return fetchNotes.eraseToAnyPublisher()
    }
    
    func getNote(id: String) -> AnyPublisher<Note, Error> {
        let fetchNote = Future<Note, Error> {_ in }
        return fetchNote.eraseToAnyPublisher()
    }
    
    func deleteNote(id: String) -> AnyPublisher<Note, Error> {
        let deleteNote = Future<Note, Error> {_ in }
        return deleteNote.eraseToAnyPublisher()
    }
    
    func updateNote(id: String) -> AnyPublisher<Note, Error> {
        let updateNote = Future<Note, Error> {_ in }
        return updateNote.eraseToAnyPublisher()
    }
    
    func createNote(id: String) -> AnyPublisher<Note, Error> {
        let createNote = Future<Note, Error> {_ in }
        return createNote.eraseToAnyPublisher()
    }
}
