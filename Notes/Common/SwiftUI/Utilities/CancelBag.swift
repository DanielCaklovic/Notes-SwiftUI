//
//  CancelBag.swift
//  Notes
//
//  Created by Daniel Caklovic on 31.01.2021..
//

import Combine
import Foundation

final class CancelBag {
    var subscriptions = Set<AnyCancellable>()
    
    func cancel() {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
}

extension AnyCancellable {
    
    func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.insert(self)
    }
}
