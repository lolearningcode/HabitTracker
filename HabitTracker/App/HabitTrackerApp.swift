//
//  HabitTrackerApp.swift
//  HabitTracker
//
//  Created by Cleo Howard on 5/21/25.
//

import SwiftUI
import ComposableArchitecture

@main
struct HabitTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            HabitListView(
                store: Store(
                    initialState: HabitListReducer.State(),
                    reducer: {
                        HabitListReducer()
                    }
                )
            )
        }
    }
}
