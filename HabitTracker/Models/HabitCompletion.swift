//
//  HabitCompletion.swift
//  HabitTracker
//
//  Created by Cleo Howard on 5/21/25.
//

import Foundation
import SwiftData

@Model
final class HabitCompletion: Sendable {
    var date: Date
    var habit: Habit

    init(date: Date, habit: Habit) {
        self.date = date
        self.habit = habit
    }
}
