//
//  HabitSchedule.swift
//  HabitTracker
//
//  Created by Cleo Howard on 5/21/25.
//

import Foundation

enum HabitSchedule: Codable, Equatable {
    case daily
    case weekly([Weekday])
    case custom([Int]) // Every X days

    enum Weekday: Int, Codable, CaseIterable {
        case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
    }
}

extension HabitSchedule: Hashable {}
