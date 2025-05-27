//
//  HabitDataService.swift
//  HabitTracker
//
//  Created by Cleo Howard on 5/21/25.
//


import Foundation
import SwiftData

@MainActor
final class HabitDataService {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func fetchHabits() async -> [Habit] {
        (try? context.fetch(FetchDescriptor<Habit>())) ?? []
    }
    
    func saveHabit(_ habit: Habit) async {
        context.insert(habit)
        try? context.save()
    }
    
    func deleteHabit(_ habit: Habit) async {
        context.delete(habit)
        try? context.save()
    }
    
    func addCompletion(for habit: Habit) async {
        let completion = HabitCompletion(date: .now, habit: habit)
        context.insert(completion)
        try? context.save()
    }
}
