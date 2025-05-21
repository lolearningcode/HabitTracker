//
//  AddHabitViewUITests.swift
//  HabitTracker
//
//  Created by Cleo Howard on 5/21/25.
//


import XCTest

final class AddHabitViewUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func test_addHabitFormUIFlow() throws {
        // Tap the "+" button to present AddHabitView
        app.buttons["plus"].tap()

        let nameField = app.textFields["e.g. Walk the dog"]
        XCTAssertTrue(nameField.exists)
        
        // Name Field should be empty and Save should be disabled
        XCTAssertFalse(app.buttons["Save"].isEnabled)

        // Type into the name field
        nameField.tap()
        nameField.typeText("Run 5K")

        // Save button should be enabled now
        XCTAssertTrue(app.buttons["Save"].isEnabled)

        // Toggle reminders
        app.switches["Reminders"].tap()

        // Change frequency
        app.segmentedControls.buttons["Weekly"].tap()

        // Save the habit
        app.buttons["Save"].tap()

        // Check that we returned to the main list or modal is dismissed
        XCTAssertFalse(app.buttons["Save"].exists)
    }
}