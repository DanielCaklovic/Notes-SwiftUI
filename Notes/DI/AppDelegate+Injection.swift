//
//  AppDelegate+Injection.swift
//  Notes
//
//  Created by Daniel Caklovic on 31.01.2021..
//

import Foundation
import Resolver
import Combine

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register { NoteRepositoryImpl() as NoteRepository }
        register { NoteServiceImpl() as NoteService }
        register { HomeVM() }
    }
}
