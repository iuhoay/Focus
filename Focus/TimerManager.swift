//
//  TimerManager.swift
//  Focus
//
//  Created by Jack Wu on 11/20/24.
//

import Foundation
import AVFoundation

class TimerManager: ObservableObject {
    @Published var timeRemaining: TimeInterval = 0
    @Published var workDuration: Double = 25
    @Published var breakDuration: Double = 5
    @Published var isWorkTime: Bool = true
    @Published var isRunning: Bool = false
    @Published var todayFocusCount = 0
    @Published var todayFocusMinutes = 0

    private var timer: Timer?
    private let calendar = Calendar.current
    private let defaults = UserDefaults.standard
    private var lastDate: Date?

    init() {
        self.timeRemaining = workDuration * 60
        loadTodayStats()
    }

    var progress: Double {
        let totalTime = (isWorkTime ? workDuration : breakDuration) * 60
        return 1 - timeRemaining / totalTime
    }

    var timeString: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func toggleTimer() {
        if isRunning {
            timer?.invalidate()
            timer = nil
        } else {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                self?.updateTimer()
            }
        }
        isRunning.toggle()
    }

    func resetTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        isWorkTime = true
        timeRemaining = workDuration * 60
    }

    func skipBreak() {
        if !isWorkTime {
            timeRemaining = 0
        }
    }

    private func updateTimer() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            if isWorkTime {
                todayFocusCount += 1
                todayFocusMinutes += Int(workDuration)
                saveTodayStats()
            }

            playSound()
            isWorkTime.toggle()
            timeRemaining = (isWorkTime ? workDuration : breakDuration) * 60
        }
    }

    private func playSound() {
        AudioServicesPlaySystemSound(1005)
    }

    private func loadTodayStats() {
        let today = calendar.startOfDay(for: Date())
        lastDate = defaults.object(forKey: "LastFocusDate") as? Date

        if lastDate == nil || !calendar.isDate(lastDate!, inSameDayAs: today) {
            todayFocusCount = 0
            todayFocusMinutes = 0
            lastDate = today
        } else {
            todayFocusCount = defaults.integer(forKey: "TodayFocusCount")
            todayFocusMinutes = defaults.integer(forKey: "TodayFocusMinutes")
        }
    }

    private func saveTodayStats() {
        defaults.set(todayFocusCount, forKey: "TodayFocusCount")
        defaults.set(todayFocusMinutes, forKey: "TodayFocusMinutes")
        defaults.set(lastDate, forKey: "LastFocusDate")
    }
}
