//
//  DataDemoApp.swift
//  DataDemo
//
//  Created by Charlie Gottlieb on 6/5/24.
//

import SwiftUI
import SwiftData

@main
struct DataDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Person.self)
    }
}
