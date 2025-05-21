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
