//
//  ClockManager.swift
//  MultiClockBar
//
//  Created by Farrukh Shahzad on 07/11/2025.
//

import SwiftUI
import Combine

class ClockManager: ObservableObject {
    @Published var clocks: [Clock] = []
    private var timer: AnyCancellable?
    private var saveCancellable: AnyCancellable?
    private let storageKey = "SavedClocks"
    @AppStorage("use24HourFormat") private var use24HourFormat = true
    @AppStorage("showSeconds") private var showSeconds = false

    init() {
        loadClocks()
        setupTimer()
        setupAutoSave()
    }
    
    // MARK: - Add / Remove
    func addClock(name: String, timezone: TimeZone) {
        clocks.append(Clock(
            name: name,
            timezoneIdentifier: timezone.identifier,
            showInMenuBar: true
        ))
    }
    
    //func removeClock(at offsets: IndexSet) {
        //clocks.remove(atOffsets: offsets)
    //}
    func removeClock(_ clock: Clock) {
        if let index = clocks.firstIndex(where: { $0.id == clock.id }) {
            clocks.remove(at: index)
        }
    }
    
    // Support for List’s built-in swipe-to-delete
    func removeClock(at offsets: IndexSet) {
        clocks.remove(atOffsets: offsets)
    }
    
    // MARK: - Persistence
    private func loadClocks() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([Clock].self, from: data)
        {
            self.clocks = decoded
        }
        else {
            // Default clocks
            self.clocks = [
                Clock(name: "Local", timezoneIdentifier: TimeZone.current.identifier, showInMenuBar: true),
                //Clock(name: "London", timezoneIdentifier: "Europe/London", showInMenuBar: true),
                //Clock(name: "Tokyo", timezoneIdentifier: "Asia/Tokyo", showInMenuBar: false)
            ]
        }
        /*
        if self.clocks.count == 0 {
            // Default clocks
            self.clocks = [
                Clock(name: "Local", timezoneIdentifier: TimeZone.current.identifier, showInMenuBar: true)
            ]
        }
        */
        objectWillChange.send()
        
        //Sort clocks timezone
        //self.clocks = decoded.sorted { $0.name < $1.name }
    }
    
    private func setupAutoSave() {
        saveCancellable = $clocks
            .dropFirst()
            .sink { clocks in
                if let data = try? JSONEncoder().encode(clocks) {
                    UserDefaults.standard.set(data, forKey: self.storageKey)
                }
            }
    }
    
    // MARK: - Live updates
    private func setupTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
    }

}

struct Clock: Identifiable, Codable {
    let id: UUID
    var name: String
    var timezoneIdentifier: String
    var showInMenuBar: Bool
    
    init(id: UUID = UUID(), name: String, timezoneIdentifier: String, showInMenuBar: Bool) {
        self.id = id
        self.name = name
        self.timezoneIdentifier = timezoneIdentifier
        self.showInMenuBar = showInMenuBar
    }

    
    var timezone: TimeZone {
        TimeZone(identifier: timezoneIdentifier) ?? .current
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeZone = timezone
        //formatter.timeStyle = .short
        let use24 = UserDefaults.standard.bool(forKey: "use24HourFormat")
        let showSec = UserDefaults.standard.bool(forKey: "showSeconds")
        
        if use24 {
            formatter.dateFormat = showSec ? "HH:mm:ss" : "HH:mm"
        } else {
            formatter.dateFormat = showSec ? "h:mm:ss a" : "h:mm a"
        }
        return formatter.string(from: Date())
    }
    
    var shortDisplay: String {
        let formatter = DateFormatter()
        formatter.timeZone = timezone
        let use24 = UserDefaults.standard.bool(forKey: "use24HourFormat")
        let showSec = UserDefaults.standard.bool(forKey: "showSeconds")
        if use24 {
            formatter.dateFormat = showSec ? "HH:mm:ss" : "HH:mm"
        } else {
            formatter.dateFormat = showSec ? "h:mm:ss a" : "h:mm a"
        }
        return "\(name.prefix(3).uppercased()) \(formatter.string(from: Date()))"
    }
}
