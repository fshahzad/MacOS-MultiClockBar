//
//  SettingsWindow.swift
//  MultiClockBar
//
//  Created by Farrukh Shahzad on 09/11/2025.
//

import SwiftUI

struct SettingsWindow: View {
    @AppStorage("use24HourFormat") private var use24HourFormat = true
    @AppStorage("showSeconds") private var showSeconds = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Preferences")
                .font(.title2)
                .padding(.bottom, 8)
            
            Toggle("Use 24-hour format", isOn: $use24HourFormat)
            Toggle("Show seconds", isOn: $showSeconds)
            
            Divider()
            
            Text("These settings affect how times are displayed in both the menu bar and list.")
                .font(.footnote)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
        .padding(24)
        .frame(width: 320, height: 220)
    }
}
