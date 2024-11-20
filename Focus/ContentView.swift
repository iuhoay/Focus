//
//  ContentView.swift
//  Focus
//
//  Created by Jack Wu on 11/20/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var timerManager = TimerManager()

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 20)

                Circle()
                    .trim(from: 0, to: timerManager.progress)
                    .stroke(
                        timerManager.isWorkTime ? Color.blue : Color.green,
                        style: StrokeStyle(lineWidth: 20, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))

                VStack {
                    Text(timerManager.timeString)
                        .font(.system(size: 60, weight: .bold))

                    Button(action: timerManager.toggleTimer) {
                        Image(systemName: timerManager.isRunning ? "pause.fill" : "play.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                    }
                    .padding(.bottom, 20)

                    if (timerManager.isWorkTime) {
                        Button(action: timerManager.resetTimer) {
                            Image(systemName: "arrow.clockwise")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                    } else {
                        // button to skip break time
                        Button(action: timerManager.skipBreak) {
                            Image(systemName: "forward.frame.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                    }
                }
            }
        }
        .padding(40)

        VStack(alignment: .leading, spacing: 20) {
            Text("Today's Focus")
                .font(.headline)

            HStack {
                VStack {
                    Text("\(timerManager.todayFocusCount)")
                        .font(.system(size: 24, weight: .bold))
                    Text("Times")
                        .foregroundColor(.gray)
                }

                Spacer()

                VStack {
                    Text("\(timerManager.todayFocusMinutes)")
                        .font(.system(size: 24, weight: .bold))
                    Text("Minutes")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}

#Preview {
    ContentView()
}
