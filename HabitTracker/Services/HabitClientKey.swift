//
//  HabitClientKey.swift
//  HabitTracker
//
//  Created by Cleo Howard on 5/21/25.
//


import ComposableArchitecture
import Foundation

private enum HabitClientKey: DependencyKey {
    static let liveValue = HabitClient.mock
}

extension DependencyValues {
    var habitClient: HabitClient {
        get { self[HabitClientKey.self] }
        set { self[HabitClientKey.self] = newValue }
    }
}