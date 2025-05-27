//
//  HabitDataService+Dependency.swift
//  HabitTracker
//
//  Created by Cleo Howard on 5/21/25.
//

import ComposableArchitecture

private enum HabitDataServiceDependencyKey: DependencyKey {
    static let liveValue: HabitDataService = {
        fatalError("HabitDataService has not been injected.")
    }()
}

extension DependencyValues {
    var habitDataService: HabitDataService {
        get { self[HabitDataServiceDependencyKey.self] }
        set { self[HabitDataServiceDependencyKey.self] = newValue }
    }
}
