//
//  HabitListView.swift
//  HabitTracker
//
//  Created by Cleo Howard on 5/21/25.
//

import SwiftUI
import ComposableArchitecture

struct HabitListView: View {
    let store: StoreOf<HabitListReducer>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                List {
                    ForEach(viewStore.habits) { habit in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(habit.name)
                                Text("Streak: \(habit.currentStreak)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Button {
                                viewStore.send(.toggleCompletion(habit.id))
                            } label: {
                                Image(systemName:
                                        habit.isCompletedToday
                                        ? "checkmark.circle.fill"
                                        : "circle")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    .onDelete { viewStore.send(.delete($0)) }
                }
                .navigationTitle("My Habits")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            viewStore.send(.addButtonTapped)
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                .onAppear { viewStore.send(.onAppear) }
                .sheet(
                    store: store.scope(state: \.$addHabit, action: \.addHabit)
                ) { addHabitStore in
                    AddHabitView(store: addHabitStore)
                }
            }
        }
    }
}
