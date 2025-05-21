//
//  HabitStreakCalculator.swift
//  HabitTracker
//
//  Created by Cleo Howard on 5/21/25.
//

import Foundation

struct HabitStreakCalculator {
    static func calculateStreak(from log: [Date]) -> Int {
        let calendar = Calendar.current
        let sortedLog = log.sorted(by: >)
        var streak = 0
        var currentDate = Date()

        for date in sortedLog {
            if calendar.isDate(date, inSameDayAs: currentDate) ||
               calendar.isDate(date, inSameDayAs: calendar.date(byAdding: .day, value: -1, to: currentDate)!) {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
            } else {
                break
            }
        }

        return streak
    }
}
