# 🧠 HabitTracker – Built with TCA, SwiftUI, and SwiftData

A modern habit tracking app built using [The Composable Architecture (TCA)](https://github.com/pointfreeco/swift-composable-architecture), SwiftUI, and SwiftData. Designed to help users build consistent daily routines, this project showcases scalable architecture, clean state management, and modern Apple development patterns.

## 🚀 Features

- ✅ **Track Daily Habits**  
  Add, view, and complete daily habits with a simple tap. The app automatically tracks completion and shows a running streak.

- 🔁 **Composable Reducer Logic**  
  Uses TCA to manage feature logic, navigation state, and side effects in a clean, testable architecture.

- 📅 **Streak System**  
  Real-time tracking of habit completion streaks based on user interactions.

- 🔁 **Toggle Completion with Smart Checks**  
  Users can’t complete the same habit more than once per day, and completions are stored with proper date logic.

- 🧪 **Unit Tests**  
  Includes tests for reducers, bindings, and streak calculations using TCA’s `TestStore`.

## 🧩 Architecture

- **State Management:** [TCA (Composable Architecture)](https://github.com/pointfreeco/swift-composable-architecture)
- **Persistence:** `SwiftData` with model classes annotated using `@Model`
- **UI:** SwiftUI with declarative views and view store bindings
- **Testing:** TCA’s `TestStore` for reducer and feature-level tests

## 🧪 Key TCA Concepts Demonstrated

- Scoped reducers using `.ifLet`
- `@PresentationState` and `PresentationAction` for modal flow
- Dependency injection using `@Dependency`
- Reducer-driven navigation and feature composition
- Test-driven reducer validation

## 📷 Screenshots

| Habit List | Add Habit Modal | Completion Toggle |
|------------|------------------|-------------------|
| ![List](docs/list.png) | ![Add](docs/add.png) | ![Toggle](docs/toggle.png) |

> *Screenshots coming soon*

## 🧰 Tech Stack

- Swift 5.10+
- SwiftUI
- SwiftData (Swift-native CoreData replacement)
- The Composable Architecture
- XCTest for unit tests

## 🧠 What I Learned

- Building feature-first modular code with TCA
- Scoping navigation and dependencies cleanly
- Writing better reducer logic with test coverage
- Improving architecture decisions with state isolationtreaks
- iCloud sync

## 📂 Project Structure
├── Models/
├── Features/
│   ├── HabitList/
│   └── AddHabit/
├── Services/
├── Tests/
└── Resources/
