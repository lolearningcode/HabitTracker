//
//  HabitListAction.swift
//  HabitTracker
//
//  Created by Cleo Howard on 5/21/25.
//


import Foundation

enum HabitListAction: Equatable {
    case onAppear
    case habitsLoaded([Habit])
    case toggleCompletion(Habit.ID)
    case delete(IndexSet)
    case addButtonTapped
    case addHabitSaved(Habit)
}