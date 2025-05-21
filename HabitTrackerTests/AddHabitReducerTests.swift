//
//  AddHabitReducerTests.swift
//  HabitTracker
//
//  Created by Cleo Howard on 5/21/25.
//

import XCTest
import ComposableArchitecture
import CasePaths
@testable import HabitTracker

final class AddHabitReducerTests: XCTestCase {
    @MainActor
    func test_bindingUpdates() async {
        let store = TestStore(
            initialState: AddHabitReducer.State(),
            reducer: AddHabitReducer.init
        )
        
        await store.send(.binding(.set(\.$name, "New Habit"))) {
            $0.name = "New Habit"
        }
        
        await store.send(.binding(.set(\.$schedule, HabitSchedule.weekly([.monday])))) {
            $0.schedule = HabitSchedule.weekly([.monday])
        }
        
        await store.send(.binding(.set(\.$remindersEnabled, true))) {
            $0.remindersEnabled = true
        }
    }
    
    @MainActor
    func test_saveTappedSendsDelegate() async {
        let testUUID = UUID(uuidString: "00000000-0000-0000-0000-000000000005")!
        let testDate = Date(timeIntervalSince1970: 1_689_000_000)
        
        let store = TestStore(
            initialState: AddHabitReducer.State(
                name: "Walk Dog",
                schedule: HabitSchedule.daily,
                remindersEnabled: true
            ),
            reducer: AddHabitReducer.init
        ) {
            $0.uuid = { testUUID }
            $0.date = { testDate }
        }
        
        await store.send(AddHabitReducer.Action.saveTapped)
        
        await store.receive(AddHabitReducer.Action.delegate(.habitCreated(
            Habit(
                id: testUUID,
                name: "Walk Dog",
                createdAt: testDate,
                schedule: HabitSchedule.daily,
                completionLog: [],
                remindersEnabled: true,
                archived: false
            )
        )))
    }
    
    @MainActor
    func test_saveTappedWithEmptyName_doesNotCreateHabit() async {
        let store = TestStore(
            initialState: AddHabitReducer.State(name: " "),
            reducer: AddHabitReducer.init
        ) {
            $0.uuid = { UUID(uuidString: "00000000-0000-0000-0000-000000000000")! }
            $0.date = { Date(timeIntervalSince1970: 0) }
        }
        
        await store.send(.saveTapped)
    }
}
