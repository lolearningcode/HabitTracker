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
        
        // 1. Normalize to unique days
        let uniqueDays = Array(
            Set(log.map { calendar.startOfDay(for: $0) })
        ).sorted(by: >)
        
        // 2. Streak logic
        var streak = 0
        var currentDate = calendar.startOfDay(for: Date())
        
        for date in uniqueDays {
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
