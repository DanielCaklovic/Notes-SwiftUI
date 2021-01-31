// Generated using Sourcery 1.0.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Swinject
import CoreData

final class SingletonContainer {

    static let instance: Container = {
        let container = Container(defaultObjectScope: .container)
        return SingletonContainer.build(container: container)
    }()

    static func build(container: Container) -> Container {

        return container
    }

}

final class FactoryContainer {

    static let instance: Container = {
        let container = Container(parent: SingletonContainer.instance, defaultObjectScope: .transient)
        return FactoryContainer.build(container: container)
    }()

    static func build(container: Container) -> Container {
        return container
    }
}
