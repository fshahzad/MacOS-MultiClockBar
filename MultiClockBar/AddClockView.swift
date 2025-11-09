//
//  AddClockView.swift
//  MultiClockBar
//
//  Created by Farrukh Shahzad on 07/11/2025.
//

import SwiftUI

struct AddClockView: View {
    @EnvironmentObject var clockManager: ClockManager
    @Environment(\.dismiss) var dismiss
    @State private var cityName = ""
    @State private var selectedTimeZone = TimeZone.current
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Add New Clock").font(.headline)
            
            TextField("City name", text: $cityName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Picker("Time Zone", selection: $selectedTimeZone) {
                ForEach(TimeZone.knownTimeZoneIdentifiers, id: \.self) { id in
                    if let tz = TimeZone(identifier: id) {
                        Text(id).tag(tz)
                    }
                }
            }
            .frame(height: 50)
            
            Button("Add") {
                clockManager.addClock(name: cityName.isEmpty ? selectedTimeZone.identifier : cityName,
                                      timezone: selectedTimeZone)
                dismiss()
            }
            
            Spacer()
            
            Button("Cancel", role: .cancel) {
                dismiss()
            }
        }
        .padding()
        .frame(width: 300, height: 300)
    }
}
