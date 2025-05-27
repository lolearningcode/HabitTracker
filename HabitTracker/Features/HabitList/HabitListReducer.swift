//
//  HabitListReducer.swift
//  HabitTracker
//
//  Created by Cleo Howard on 5/21/25.
//

import Foundation
import ComposableArchitecture
import SwiftData

struct HabitListReducer: Reducer {
    struct State: Equatable {
        var habits: [Habit] = []
        @PresentationState var addHabit: AddHabitReducer.State?
        var isLoading: Bool = false
    }
    
    @CasePathable
    enum Action: Equatable {
        case onAppear
        case habitsLoaded([Habit])
        case toggleCompletion(Habit.ID)
        case delete(IndexSet)
        case addButtonTapped
        case addHabit(PresentationAction<AddHabitReducer.Action>)
    }
    
    @Dependency(\.habitClient) var habitClient
    @Dependency(\.mainQueue) var mainQueue
    @Dependency(\.date) var date
    @Dependency(\.habitDataService) var habitDataService
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    let habits = try await habitClient.fetch()
                    await send(.habitsLoaded(habits))
                }
                
            case let .habitsLoaded(habits):
                state.habits = habits
                state.isLoading = false
                return .none
                
            case let .toggleCompletion(id):
                guard let idx = state.habits.firstIndex(where: { $0.id == id }) else { return .none }
                let habit = state.habits[idx]
                let cal = Calendar.current
                
                if habit.isCompletedToday {
                    return .none
                }
                
                return .run { send in
                    await habitDataService.addCompletion(for: habit)
                    
                    let updatedHabits = try await habitClient.fetch()
                    await send(.habitsLoaded(updatedHabits))
                }
                
            case let .delete(indexSet):
                let ids = indexSet.map { state.habits[$0].id }
                state.habits.remove(atOffsets: indexSet)
                return .merge(ids.map { id in .run { _ in _ = try await habitClient.delete(id) } })
                
            case .addButtonTapped:
                state.addHabit = AddHabitReducer.State()
                return .none
                
            case let .addHabit(.presented(.delegate(.habitCreated(habit)))):
                state.habits.append(habit)
                state.addHabit = nil
                return .run { _ in _ = try await habitClient.save(habit) }
                
            case .addHabit:
                return .none
            }
        }
        .ifLet(\.$addHabit, action: \.addHabit) {
            AddHabitReducer()
        }
    }
}

extension HabitListReducer.State {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.habits == rhs.habits &&
        lhs.addHabit == rhs.addHabit &&
        lhs.isLoading == rhs.isLoading
    }
}
