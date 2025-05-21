//
//  Habit.swift
//  HabitTracker
//
//  Created by Cleo Howard on 5/21/25.
//

import Foundation

struct Habit: Identifiable, Equatable, Codable {
    let id: UUID
    var name: String
    var createdAt: Date
    var schedule: HabitSchedule
    var completionLog: [Date]
    var remindersEnabled: Bool
    var archived: Bool

    var isCompletedToday: Bool {
        Calendar.current.isDateInToday(completionLog.last ?? .distantPast)
    }

    var currentStreak: Int {
        HabitStreakCalculator.calculateStreak(from: completionLog)
    }
}
