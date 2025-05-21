//
//  HabitListEnvironment.swift
//  HabitTracker
//
//  Created by Cleo Howard on 5/21/25.
//

import ComposableArchitecture
import Foundation

struct HabitListEnvironment {
    var habitClient: HabitClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}
