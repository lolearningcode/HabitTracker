//
//  HabitClientKey.swift
//  HabitTracker
//
//  Created by Cleo Howard on 5/21/25.
//


import ComposableArchitecture

private enum HabitClientKey: DependencyKey {
    static let liveValue = HabitClient(
        fetch: {
            @Dependency(\.habitDataService) var db
            return await db.fetchHabits()
        },
        save: { habit in
            @Dependency(\.habitDataService) var db
            await db.saveHabit(habit)
        },
        delete: { id in
            @Dependency(\.habitDataService) var db
            if let habit = await db.fetchHabits().first(where: { $0.id == id }) {
                await db.deleteHabit(habit)
            }
        }
    )
}

extension DependencyValues {
    var habitClient: HabitClient {
        get { self[HabitClientKey.self] }
        set { self[HabitClientKey.self] = newValue }
    }
}
