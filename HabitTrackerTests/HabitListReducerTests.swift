//
//  HabitListReducerTests.swift
//  HabitTracker
//
//  Created by Cleo Howard on 5/21/25.
//

import XCTest
import ComposableArchitecture
@testable import HabitTracker

@MainActor
final class HabitListReducerTests: XCTestCase {
    
    func test_onAppearLoadsHabits() async {
        let mockHabit = Habit(
            id: UUID(),
            name: "Sample",
            createdAt: .now,
            schedule: .daily,
            remindersEnabled: false,
            archived: false
        )
        
        let store = TestStore(
            initialState: HabitListReducer.State(),
            reducer: HabitListReducer.init
        ) {
            $0.habitClient.fetch = {
                [mockHabit]
            }
        }
        
        await store.send(.onAppear) {
            $0.isLoading = true
        }
        
        await store.receive(.habitsLoaded([mockHabit])) {
            $0.habits = [mockHabit]
            $0.isLoading = false
        }
    }
    
    func test_addButtonTappedPresentsAddHabit() async {
        let store = TestStore(
            initialState: HabitListReducer.State(),
            reducer: HabitListReducer.init
        )
        
        await store.send(.addButtonTapped) {
            $0.addHabit = AddHabitReducer.State()
        }
    }
    
    func test_addHabitDelegateAppendsHabit() async {
        let newHabit = Habit(
            id: UUID(),
            name: "Drink Water",
            createdAt: .now,
            schedule: .daily,
            remindersEnabled: true,
            archived: false
        )
        
        let store = TestStore(
            initialState: HabitListReducer.State(addHabit: AddHabitReducer.State()),
            reducer: HabitListReducer.init
        ) {
            $0.habitClient.save = { _ in }
        }
        
        await store.send(.addHabit(.presented(.delegate(.habitCreated(newHabit))))) {
            $0.habits = [newHabit]
            $0.addHabit = nil
        }
    }
    
    func test_deleteHabitRemovesCorrectIndex() async {
        let habit = Habit(
            id: UUID(),
            name: "Meditate",
            createdAt: .now,
            schedule: .daily,
            remindersEnabled: false,
            archived: false
        )
        
        var deletedHabitIDs: [UUID] = []
        
        let store = TestStore(
            initialState: HabitListReducer.State(habits: [habit]),
            reducer: HabitListReducer.init
        ) {
            $0.habitClient.delete = { id in
                deletedHabitIDs.append(id)
            }
        }
        
        await store.send(.delete(IndexSet(integer: 0))) {
            $0.habits = []
        }
        
        XCTAssertEqual(deletedHabitIDs, [habit.id])
    }
}
