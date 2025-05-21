//
//  HabitListState.swift
//  HabitTracker
//
//  Created by Cleo Howard on 5/21/25.
//

import Foundation
import ComposableArchitecture

struct HabitListState: Equatable {
    var habits: [Habit] = []
    var isLoading: Bool = false
    var showAddHabit: Bool = false
}
