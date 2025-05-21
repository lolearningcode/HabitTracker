//
//  AddHabitView.swift
//  HabitTracker
//
//  Created by Cleo Howard on 5/21/25.
//


import SwiftUI
import ComposableArchitecture

struct AddHabitView: View {
    let store: StoreOf<AddHabitReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                Form {
                    Section(header: Text("Name")) {
                        TextField("e.g. Walk the dog", text: viewStore.$name)
                    }
                    
                    Section(header: Text("Schedule")) {
                        Picker("Frequency", selection: viewStore.$schedule) {
                            Text("Daily").tag(HabitSchedule.daily)
                            Text("Weekly").tag(HabitSchedule.weekly([])) // Placeholder
                            Text("Custom").tag(HabitSchedule.custom([])) // Placeholder
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    Section {
                        Toggle("Reminders", isOn: viewStore.$remindersEnabled)
                    }
                    
                    Section {
                        Button("Save") {
                            viewStore.send(.saveTapped)
                        }
                        .disabled(viewStore.name.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }
                .navigationTitle("New Habit")
            }
        }
    }
}
