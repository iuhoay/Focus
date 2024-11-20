//
//  ContentView.swift
//  Focus Watch Watch App
//
//  Created by Jack Wu on 11/21/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var timerManager = TimerManager()

    var body: some View {
        ZStack {
            timerManager.isWorkTime ? Color.primary
                .opacity(0.1) : Color.green
                .opacity(0.1)

            VStack(spacing: 25) {
                Text(timerManager.timeString)
                    .font(.largeTitle)

                HStack {
                    Button(
                        "reset timer",
                        systemImage: timerManager.isRunning ? "pause.fill" : "play.fill",
                        role: .cancel,
                        action: timerManager.toggleTimer
                    )
                    .labelStyle(IconOnlyLabelStyle())

                    if (timerManager.isWorkTime) {
                        Button(
                            "reset timer",
                            systemImage: "arrow.clockwise",
                            role: .destructive,
                            action: timerManager.resetTimer
                        )
                        .labelStyle(IconOnlyLabelStyle())
                    } else {
                        Button(
                            "skip break",
                            systemImage: "forward.frame.fill",
                            role: .destructive,
                            action: timerManager.skipBreak
                        )
                        .labelStyle(IconOnlyLabelStyle())
                    }
                }
            }
            .padding()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
