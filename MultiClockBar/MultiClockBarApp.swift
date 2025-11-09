//
//  MultiClockBarApp.swift
//  MultiClockBar
//
//  Created by Farrukh Shahzad on 07/11/2025.
//

import SwiftUI

@main
struct MultiClockBarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    //@StateObject private var clockManager = ClockManager()
    
    var body: some Scene {
        Settings {} // no main window
        /*
        MenuBarExtra("🕒", systemImage: "clock") {
            ClockListView()
                .environmentObject(clockManager)
        }
        .menuBarExtraStyle(.window)
         */
    }
}
