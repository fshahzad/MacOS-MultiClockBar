//
//  AppDelegate.swift
//  MultiClockBar
//
//  Created by Farrukh Shahzad on 09/11/2025.
//

import Cocoa
import SwiftUI
import Combine
import Foundation

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItems: [NSStatusItem] = []
    var clockManager = ClockManager()
    var timerCancellable: AnyCancellable?
    var popover = NSPopover()
    var cancellables = Set<AnyCancellable>()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        /*
         LSUIElement = YES    Info.plist    Production — permanent, clean, native behavior
         NSApp.setActivationPolicy(.accessory)
         */
        NSApp.setActivationPolicy(.accessory)
        observeClockChanges()
        setupStatusItems()
        setupPopover()
        startTimer()
    }
    
    private func observeClockChanges() {
        clockManager.$clocks
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.setupStatusItems()
            }
            .store(in: &cancellables)
    }
    
    private func setupStatusItems() {
        // Remove old items first
        statusItems.forEach { NSStatusBar.system.removeStatusItem($0) }
        statusItems.removeAll()
        
        let filteredItems = clockManager.clocks.filter({ $0.showInMenuBar })
        
        if filteredItems.count == 0 {
            let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
            if let button = item.button {
                button.title = "🕒"
                button.action = #selector(togglePopover(_:))
                button.target = self
            }
            statusItems.append(item)
            return
        }
        else {
            // Create a status item only for checked clocks
            for clock in filteredItems {
                let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
                // Create one NSStatusItem per clock
                if let button = item.button {
                    button.title = clock.shortDisplay
                    button.action = #selector(togglePopover(_:))
                    button.target = self
                }
                statusItems.append(item)
            }
        }
    }
    
    private func setupPopover() {
        popover.behavior = .transient
        popover.animates = true
        popover.contentViewController = NSHostingController(
            rootView: ClockListView()
                .environmentObject(clockManager)
        )
        clockManager.$clocks
            .sink { [weak self] _ in
                self?.setupStatusItems()
            }
            .store(in: &cancellables)
    }
    
    private func startTimer() {
        // Update every second
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateStatusItemTitles()
            }
    }
    
    private func updateStatusItemTitles() {
        for (index, clock) in clockManager.clocks.enumerated() {
            if index < statusItems.count, let button = statusItems[index].button {
                button.title = clock.shortDisplay
            }
        }
    }
    
    @objc func togglePopover(_ sender: NSStatusBarButton) {
        if popover.isShown {
            popover.performClose(sender)
        } else {
            popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: .minY)
            popover.contentViewController?.view.window?.becomeKey()
        }
    }
    
}
