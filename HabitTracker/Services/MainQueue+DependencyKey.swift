//
//  MainQueue+DependencyKey.swift
//  HabitTracker
//
//  Created by Cleo Howard on 5/21/25.
//

import ComposableArchitecture
import Foundation

private enum MainQueueKey: DependencyKey {
    static let liveValue: AnySchedulerOf<DispatchQueue> = .main
}

extension DependencyValues {
    var mainQueue: AnySchedulerOf<DispatchQueue> {
        get { self[MainQueueKey.self] }
        set { self[MainQueueKey.self] = newValue }
    }
}

private enum DateKey: DependencyKey {
    static let liveValue: @Sendable () -> Date = { @Sendable in Date() }
}

extension DependencyValues {
    public var date: @Sendable () -> Date {
        get { self[DateKey.self] }
        set { self[DateKey.self] = newValue }
    }
}

private enum UUIDKey: DependencyKey {
    static let liveValue: @Sendable () -> UUID = { @Sendable in UUID() }
}

extension DependencyValues {
    var uuid: @Sendable () -> UUID {
        get { self[UUIDKey.self] }
        set { self[UUIDKey.self] = newValue }
    }
}
