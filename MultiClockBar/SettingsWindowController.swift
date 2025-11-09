//
//  SettingsWindowController.swift
//  MultiClockBar
//
//  Created by Farrukh Shahzad on 09/11/2025.
//

import Cocoa
import SwiftUI

class SettingsWindowController {
    static let shared = SettingsWindowController()
    
    private var window: NSWindow?
    
    func show() {
        if window == nil {
            let contentView = SettingsWindow()
            window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 340, height: 240),
                styleMask: [.titled, .closable],
                backing: .buffered,
                defer: false
            )
            window?.isReleasedWhenClosed = false
            window?.title = "Preferences"
            window?.contentView = NSHostingView(rootView: contentView)
            window?.center()
        }
        
        window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}
