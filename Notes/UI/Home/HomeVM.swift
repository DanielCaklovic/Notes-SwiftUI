//
//  HomeVM.swift
//  Notes
//
//  Created by Daniel Caklovic on 31.01.2021..
//

import Foundation
import Resolver
import Combine
import SwiftUI

class HomeVM: ObservableObject, Resolving {
    
    @Published var isLoggedOut = false
    @Published var notes: [Note] = []
    
    @Injected private var noteService: NoteService
    
    private var cancelBag = CancelBag()
    
    init() {
        fetchNotes()
    }
    
    func fetchNotes() {
//        noteService.getNotes().sinkToResult { result in
//            switch result {
//            case .success(let notes):
//                self.notes = employees.map({ ListItem.initWithEmployee($0) })
//            case .failure(let err):
//                debugPrint(err.localizedDescription)
//            }
//        }.store(in: cancelBag)
    }
}
