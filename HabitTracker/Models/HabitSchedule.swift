//
//  HabitSchedule.swift
//  HabitTracker
//
//  Created by Cleo Howard on 5/21/25.
//

import Foundation

enum HabitScheduleType: String, Codable {
    case daily
    case weekly
    case custom
}

struct HabitSchedule: Codable, Hashable {
    var type: HabitScheduleType
    var weekdays: [Int] = []
    var customDays: [Int] = []
    
    static let daily = HabitSchedule(type: .daily)
    static func weekly(_ days: [HabitSchedule.Weekday]) -> HabitSchedule {
        .init(type: .weekly, weekdays: days.map(\.rawValue))
    }
    static func custom(_ days: [Int]) -> HabitSchedule {
        .init(type: .custom, customDays: days)
    }
    
    enum Weekday: Int, CaseIterable {
        case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
    }
}
