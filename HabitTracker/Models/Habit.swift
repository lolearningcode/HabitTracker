//
//  Habit.swift
//  HabitTracker
//
//  Created by Cleo Howard on 5/21/25.
//

import Foundation
import SwiftData

@Model
final class Habit: Identifiable, Equatable, Sendable {
    @Attribute(.unique) var id: UUID
    var name: String
    var createdAt: Date
    var schedule: HabitSchedule
    var remindersEnabled: Bool
    var archived: Bool
    
    @Relationship(deleteRule: .cascade)
    var completions: [HabitCompletion] = []
    
    var isCompletedToday: Bool {
        completions.contains { Calendar.current.isDateInToday($0.date) }
    }
    
    var currentStreak: Int {
        let dates = completions.map(\.date).sorted()
        return HabitStreakCalculator.calculateStreak(from: dates)
    }
    
    init(
        id: UUID = UUID(),
        name: String,
        createdAt: Date = .now,
        schedule: HabitSchedule,
        remindersEnabled: Bool = false,
        archived: Bool = false
    ) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.schedule = schedule
        self.remindersEnabled = remindersEnabled
        self.archived = archived
    }
}
