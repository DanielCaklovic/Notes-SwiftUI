//
//  InstanceRegistration.swift
//  Notes
//
//  Created by Daniel Caklovic on 31.01.2021..
//

import Swinject

// Manual dependency injections
final class InstanceRegistration {
    
    static var singletonInstance: Container {
        return SingletonContainer.instance
    }
    
    static var factoryInstance: Container {
        return FactoryContainer.instance
    }
    
    static func build() {

    }
    
    private init() {}
}
