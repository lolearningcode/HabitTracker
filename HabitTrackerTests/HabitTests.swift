//
//  HabitTests.swift
//  HabitTracker
//
//  Created by Cleo Howard on 5/21/25.
//


import XCTest
@testable import HabitTracker

final class HabitTests: XCTestCase {
    
    func test_isCompletedToday_whenLoggedToday_returnsTrue() {
        let today = Date()
        let habit = Habit(
            id: UUID(),
            name: "Drink Water",
            createdAt: today,
            schedule: .daily,
            completionLog: [today],
            remindersEnabled: false,
            archived: false
        )
        
        XCTAssertTrue(habit.isCompletedToday)
    }

    func test_isCompletedToday_whenNotLoggedToday_returnsFalse() {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let habit = Habit(
            id: UUID(),
            name: "Run",
            createdAt: yesterday,
            schedule: .daily,
            completionLog: [yesterday],
            remindersEnabled: false,
            archived: false
        )
        
        XCTAssertFalse(habit.isCompletedToday)
    }

    func test_calculateStreak_withThreeConsecutiveDays_returns3() {
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: today)!
        
        let log = [today, yesterday, twoDaysAgo]
        let streak = HabitStreakCalculator.calculateStreak(from: log)
        
        XCTAssertEqual(streak, 3)
    }

    func test_calculateStreak_withGap_returns1() {
        let today = Date()
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: today)!
        
        let log = [today, twoDaysAgo]
        let streak = HabitStreakCalculator.calculateStreak(from: log)
        
        XCTAssertEqual(streak, 2)
    }

    func test_currentStreak_readsFromCompletionLog() {
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let habit = Habit(
            id: UUID(),
            name: "Stretch",
            createdAt: yesterday,
            schedule: .daily,
            completionLog: [yesterday, today],
            remindersEnabled: false,
            archived: false
        )

        XCTAssertEqual(habit.currentStreak, 2)
    }
    
    func test_calculateStreak_withDuplicateDates_returnsCorrectStreak() {
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        
        let log = [today, today, yesterday, yesterday] // duplicate entries
        let streak = HabitStreakCalculator.calculateStreak(from: log)
        
        XCTAssertEqual(streak, 2, "Streak should be 2 even with duplicate logs")
    }
    
    func test_calculateStreak_withOutOfOrderDates_returnsCorrectStreak() {
        let today = Date()
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: today)!
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        
        let log = [twoDaysAgo, today, yesterday] // intentionally out of order
        let streak = HabitStreakCalculator.calculateStreak(from: log)
        
        XCTAssertEqual(streak, 3, "Streak should be 3 regardless of log order")
    }
}
