//
//  AddHabitReducerTests.swift
//  HabitTracker
//
//  Created by Cleo Howard on 5/21/25.
//

import XCTest
import ComposableArchitecture
@testable import HabitTracker

@MainActor
final class AddHabitReducerTests: XCTestCase {
    
    func test_saveTappedSendsDelegate() async {
        let testUUID = UUID(uuidString: "00000000-0000-0000-0000-000000000005")!
        let testDate = Date(timeIntervalSince1970: 1_689_000_000)
        
        let store = TestStore(
            initialState: AddHabitReducer.State(
                name: "Walk Dog",
                schedule: .daily,
                remindersEnabled: true
            ),
            reducer: { AddHabitReducer() }
        ) {
            $0.uuid = { testUUID }
            $0.date = { testDate }
        }
        
        await store.send(.saveTapped)
        
        // Manually capture the delegate action
        let _ = await store.receive { action in
            guard case let .delegate(inner) = action else {
                XCTFail("Expected delegate action")
                return false
            }
            guard case let .habitCreated(habit) = inner else {
                XCTFail("Expected habitCreated action")
                return false
            }
            
            XCTAssertEqual(habit.id, testUUID)
            XCTAssertEqual(habit.name, "Walk Dog")
            XCTAssertEqual(habit.createdAt, testDate)
            XCTAssertEqual(habit.schedule, .daily)
            XCTAssertEqual(habit.remindersEnabled, true)
            XCTAssertEqual(habit.archived, false)
            
            return true
        }
    }
    
    func test_saveTappedDoesNothingWhenNameIsEmpty() async {
        let store = TestStore(
            initialState: AddHabitReducer.State(name: "   "),
            reducer: { AddHabitReducer() }
        ) {
            $0.uuid = { UUID(uuidString: "00000000-0000-0000-0000-000000000000")! }
            $0.date = { Date(timeIntervalSince1970: 0) }
        }
        
        await store.send(.saveTapped)
        await store.finish()
    }
    
    func test_bindingNameUpdate() async {
        let store = TestStore(
            initialState: AddHabitReducer.State(),
            reducer: { AddHabitReducer() }
        )
        
        await store.send(.binding(.set(\.$name, "Meditate"))) {
            $0.name = "Meditate"
        }
    }
    
    func test_bindingScheduleUpdate() async {
        let store = TestStore(
            initialState: AddHabitReducer.State(),
            reducer: { AddHabitReducer() }
        )
        
        let schedule: HabitSchedule = .weekly([.monday, .wednesday])
        
        await store.send(.binding(.set(\.$schedule, schedule))) {
            $0.schedule = schedule
        }
    }
    
    func test_bindingRemindersToggle() async {
        let store = TestStore(
            initialState: AddHabitReducer.State(),
            reducer: { AddHabitReducer() }
        )
        
        await store.send(.binding(.set(\.$remindersEnabled, true))) {
            $0.remindersEnabled = true
        }
    }
}
