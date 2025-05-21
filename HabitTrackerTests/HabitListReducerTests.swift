//
//  HabitListReducerTests.swift
//  HabitTracker
//
//  Created by Cleo Howard on 5/21/25.
//

import XCTest
import ComposableArchitecture
import Combine
@testable import HabitTracker

final class HabitListReducerTests: XCTestCase {
    func test_onAppearLoadsHabits() async {
        let mockHabit = Habit(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
            name: "Mock Habit",
            createdAt: .now,
            schedule: .daily,
            completionLog: [],
            remindersEnabled: false,
            archived: false
        )
        
        let store = await TestStore(
            initialState: HabitListReducer.State(),
            reducer: HabitListReducer.init
        ) {
            $0.habitClient.fetch = {
                Just([mockHabit])
                    .setFailureType(to: Never.self)
                    .eraseToAnyPublisher()
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
    
    func test_toggleCompletion() async {
        let testDate = Date(timeIntervalSince1970: 1_689_000_000)
        let habitID = UUID(uuidString: "00000000-0000-0000-0000-000000000002")!
        
        var savedHabit: Habit? = nil
        
        let testHabit = Habit(
            id: habitID,
            name: "Test Habit",
            createdAt: testDate,
            schedule: .daily,
            completionLog: [],
            remindersEnabled: false,
            archived: false
        )
        
        let store = await TestStore(
            initialState: HabitListReducer.State(habits: [testHabit]),
            reducer: HabitListReducer.init
        ) {
            $0.date = { testDate }
            $0.habitClient.save = { habit in
                savedHabit = habit
                return .none
            }
        }
        
        await store.send(HabitListReducer.Action.toggleCompletion(habitID)) {
            $0.habits[0].completionLog = [testDate]
        }
        
        XCTAssertEqual(savedHabit?.completionLog, [testDate])
    }
    
    func test_deleteHabit() async {
        let habitID = UUID(uuidString: "00000000-0000-0000-0000-000000000003")!
        var deletedHabitIDs: [UUID] = []
        
        let testHabit = Habit(
            id: habitID,
            name: "Delete Me",
            createdAt: .now,
            schedule: .daily,
            completionLog: [],
            remindersEnabled: false,
            archived: false
        )
        
        let store = await TestStore(
            initialState: HabitListReducer.State(habits: [testHabit]),
            reducer: HabitListReducer.init
        ) {
            $0.habitClient.delete = { id in
                deletedHabitIDs.append(id)
                return .none
            }
        }
        
        await store.send(.delete(IndexSet(integer: 0))) {
            $0.habits = []
        }
        
        XCTAssertEqual(deletedHabitIDs, [habitID])
    }
    
    func test_addButtonTappedPresentsAddHabitModal() async {
        let store = await TestStore(
            initialState: HabitListReducer.State(),
            reducer: HabitListReducer.init
        )
        
        await store.send(.addButtonTapped) {
            $0.addHabit = AddHabitReducer.State()
        }
    }
    
    func test_addHabitDelegateCreatesHabit() async {
        let habitID = UUID(uuidString: "00000000-0000-0000-0000-000000000004")!
        let createdHabit = Habit(
            id: habitID,
            name: "New Habit",
            createdAt: .now,
            schedule: .daily,
            completionLog: [],
            remindersEnabled: false,
            archived: false
        )
        
        var savedHabit: Habit? = nil
        
        let store = await TestStore(
            initialState: HabitListReducer.State(addHabit: AddHabitReducer.State()),
            reducer: HabitListReducer.init
        ) {
            $0.habitClient.save = { habit in
                savedHabit = habit
                return .none
            }
        }
        
        await store.send(.addHabit(.presented(.delegate(.habitCreated(createdHabit))))) {
            $0.habits = [createdHabit]
            $0.addHabit = nil
        }
        
        XCTAssertEqual(savedHabit, createdHabit)
    }
}
