//
//  AddHabitReducer.swift
//  HabitTracker
//
//  Created by Cleo Howard on 5/21/25.
//

import Foundation
import CasePaths
import ComposableArchitecture
import SwiftUI

struct AddHabitReducer: Reducer {
    // MARK: - State
    struct State: Equatable {
        @BindingState var name: String = ""
        @BindingState var schedule: HabitSchedule = .daily
        @BindingState var remindersEnabled: Bool = false
    }
    
    // MARK: - Actions
    @CasePathable
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case saveTapped
        case delegate(Delegate)
    }
    
    // MARK: - Delegate
    enum Delegate: Equatable {
        case habitCreated(Habit)
    }
    
    // MARK: - Dependencies
    @Dependency(\.uuid) var uuid
    @Dependency(\.date) var date
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .saveTapped:
                let trimmed = state.name.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmed.isEmpty else { return .none }
                
                let newHabit = Habit(
                    id: uuid(),
                    name: trimmed,
                    createdAt: date(),
                    schedule: state.schedule,
                    completionLog: [],
                    remindersEnabled: state.remindersEnabled,
                    archived: false
                )
                return .send(.delegate(.habitCreated(newHabit)))
                
            case .delegate:
                return .none
            }
        }
    }
}
