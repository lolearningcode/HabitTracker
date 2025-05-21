//
//  HabitListReducer.swift
//  HabitTracker
//
//  Created by Cleo Howard on 5/21/25.
//

import ComposableArchitecture
import Foundation

struct HabitListReducer: Reducer {
    struct State: Equatable {
        var habits: [Habit] = []
        var isLoading: Bool = false
        var showAddHabit: Bool = false
    }
    
    enum Action: Equatable {
        case onAppear
        case habitsLoaded([Habit])
        case toggleCompletion(Habit.ID)
        case delete(IndexSet)
        case addButtonTapped
        case addHabitSaved(Habit)
    }
    
    @Dependency(\.habitClient) var habitClient
    @Dependency(\.mainQueue) var mainQueue
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.isLoading = true
            return .run { send in
                for await habits in habitClient.fetch().receive(on: mainQueue).values {
                    await send(.habitsLoaded(habits))
                }
            }
            
        case let .habitsLoaded(habits):
            state.habits = habits
            state.isLoading = false
            return .none
            
        case let .toggleCompletion(id):
            guard let idx = state.habits.firstIndex(where: { $0.id == id }) else {
                return .none
            }
            
            var habit = state.habits[idx]
            let cal = Calendar.current
            if habit.isCompletedToday {
                habit.completionLog.removeAll { cal.isDateInToday($0) }
            } else {
                habit.completionLog.append(Date())
            }
            
            state.habits[idx] = habit
            let habitToSave = habit  // ✅ safe capture
            
            return .run { _ in
                _ = habitClient.save(habitToSave)
            }
            
        case let .delete(indexSet):
            let ids = indexSet.map { state.habits[$0].id }
            state.habits.remove(atOffsets: indexSet)
            
            return .merge(
                ids.map { id in
                    .run { _ in
                            _ = habitClient.delete(id)
                    }
                }
            )
            
        case .addButtonTapped:
            state.showAddHabit = true
            return .none
            
        case let .addHabitSaved(habit):
            state.habits.append(habit)
            state.showAddHabit = false
            let habitToSave = habit
            
            return .run { _ in
                _ = habitClient.save(habitToSave)
            }
        }
    }
}
