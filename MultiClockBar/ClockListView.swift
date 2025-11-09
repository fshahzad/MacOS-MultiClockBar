//
//  ClockListView.swift
//  MultiClockBar
//
//  Created by Farrukh Shahzad on 07/11/2025.
//

import SwiftUI
import Combine

struct ClockListView: View {
    @EnvironmentObject var clockManager: ClockManager
    @State private var showingAddClock = false
    
    var body: some View {
        VStack {
            List {
                ForEach($clockManager.clocks) { $clock in
                    HStack {
                        // ✅ Checkbox toggle to show/hide in menu bar
                        Toggle("", isOn: $clock.showInMenuBar)
                            .toggleStyle(.checkbox)
                            .labelsHidden()
                            //Swift infers the parameter _ automatically.
                            .onChange(of: clock.showInMenuBar) { _ in
                                clockManager.objectWillChange.send()
                            }
                        // Clock name and time
                        Text(clock.name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(clock.formattedTime)
                            .monospacedDigit()
                            .frame(width: 70, alignment: .trailing)
                        
                        // ✅ Manual delete button
                        HoverableDeleteButton {
                            clockManager.removeClock(clock)
                        }
                        .buttonStyle(.borderless)
                    }
                    .padding(.vertical, 2)
                }
                // ✅ Swipe-to-delete support (uses same method)
                .onDelete(perform: clockManager.removeClock)
            }
            .listStyle(.inset)
            .frame(width: 280, height: 250)
            
            Divider()
            
            Button("Add Clock") {
                showingAddClock.toggle()
            }
            .sheet(isPresented: $showingAddClock) {
                AddClockView()
                    .environmentObject(clockManager)
            }
            
            Spacer()
            
            Button("Preferences…") {
                SettingsWindowController.shared.show()
            }
            
            Spacer()
            Button("Quit") {
                NSApp.terminate(nil)
            }
        }
        .padding(.bottom, 6)
    }
}

private struct HoverableDeleteButton: View {
    let action: () -> Void
    @State private var isHovering = false
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(isHovering ? .red : .secondary)
                .background(
                    Circle()
                        .fill(Color.red.opacity(isHovering ? 0.1 : 0))
                )
        }
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovering = hovering
            }
        }
        .buttonStyle(.borderless)
        .help("Delete")
    }
}
