//
//  HabitTrackerApp.swift
//  HabitTracker
//
//  Created by Cleo Howard on 5/21/25.
//

import SwiftUI
import ComposableArchitecture
import SwiftData

@main
struct HabitTrackerApp: App {
    @State private var modelContainer: ModelContainer = {
        let schema = Schema([Habit.self])
        let config = ModelConfiguration("HabitDB", schema: schema)
        return try! ModelContainer(for: schema, configurations: [config])
    }()
    
    var body: some Scene {
        WindowGroup {
            HabitListView(
                store: withDependencies {                    
                    let habitDataService = HabitDataService(context: modelContainer.mainContext)
                    
                    $0.habitDataService = habitDataService
                    $0.habitClient = HabitClient(
                        fetch: {
                            await habitDataService.fetchHabits()
                        },
                        save: { habit in
                            await habitDataService.saveHabit(habit)
                        },
                        delete: { id in
                            let habits = await habitDataService.fetchHabits()
                            if let habit = habits.first(where: { $0.id == id }) {
                                await habitDataService.deleteHabit(habit)
                            }
                        }
                    )
                } operation: {
                    Store(
                        initialState: HabitListReducer.State()
                    ) {
                        HabitListReducer()
                    }
                }
            )
            .modelContainer(modelContainer)
        }
    }
}
