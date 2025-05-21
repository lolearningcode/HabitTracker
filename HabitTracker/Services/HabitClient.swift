//
//  HabitClient.swift
//  HabitTracker
//
//  Created by Cleo Howard on 5/21/25.
//

import Foundation
import ComposableArchitecture
import Combine
import UIKit

struct HabitClient {
    var fetch: () -> AnyPublisher<[Habit], Never>
    var save: (Habit) -> Effect<Never>
    var delete: (Habit.ID) -> Effect<Never>
}

extension HabitClient {
    static let mock = HabitClient(
        fetch: {
            Just([
                Habit(id: UUID(), name: "Walk the dog", createdAt: .now, schedule: .daily, completionLog: [], remindersEnabled: false, archived: false),
                Habit(id: UUID(), name: "Read 10 pages", createdAt: .now, schedule: .weekly([.monday, .wednesday, .friday]), completionLog: [], remindersEnabled: true, archived: false)
            ])
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .setFailureType(to: Never.self)
            .eraseToAnyPublisher()
        },
        save: { _ in .none },
        delete: { _ in .none }
    )
}
