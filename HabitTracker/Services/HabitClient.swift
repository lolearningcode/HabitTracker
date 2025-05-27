//
//  HabitClient.swift
//  HabitTracker
//
//  Created by Cleo Howard on 5/21/25.
//

import Foundation
import ComposableArchitecture
import Combine
import UIKit

struct HabitClient {
    var fetch: () async throws -> [Habit]
    var save: (Habit) async throws -> Void
    var delete: (Habit.ID) async throws -> Void
}
