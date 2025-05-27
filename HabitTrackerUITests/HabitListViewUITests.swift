//
//  HabitListViewUITests.swift
//  HabitTracker
//
//  Created by Cleo Howard on 5/21/25.
//


import XCTest

final class HabitListViewUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func test_habitListUIFlow() throws {
        // Confirm navigation title
        XCTAssertTrue(app.navigationBars["My Habits"].exists)

        // Tap add button
        app.buttons["plus"].tap()

        // Confirm AddHabitView appears
        let nameField = app.textFields["e.g. Walk the dog"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 2))

        // Enter a habit name
        nameField.tap()
        nameField.typeText("Morning Run")

        // Save
        app.buttons["Save"].tap()

        // Wait for AddHabitView to dismiss
        XCTAssertFalse(app.buttons["Save"].exists)

        // Check if habit is added to the list
        let habitLabel = app.staticTexts["Morning Run"]
        XCTAssertTrue(habitLabel.waitForExistence(timeout: 2))

        // Toggle completion
        let toggleButton = app.buttons.matching(identifier: "toggleCompletion_").firstMatch
        if toggleButton.exists {
            toggleButton.tap()
        }
    }
}
