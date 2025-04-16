import Foundation
import SwiftUI

enum HabitCategory: String, CaseIterable {
    case health = "Health"
    case productivity = "Productivity"
    case learning = "Learning"
    case lifestyle = "Lifestyle"
    case fitness = "Fitness"
    case mindfulness = "Mindfulness"
    
    var color: Color {
        switch self {
        case .health: return .blue
        case .productivity: return .green
        case .learning: return .purple
        case .lifestyle: return .orange
        case .fitness: return .red
        case .mindfulness: return .indigo
        }
    }
    
    var icon: String {
        switch self {
        case .health: return "heart.fill"
        case .productivity: return "checkmark.circle.fill"
        case .learning: return "book.fill"
        case .lifestyle: return "house.fill"
        case .fitness: return "figure.run"
        case .mindfulness: return "brain.head.profile"
        }
    }
}

struct Habit: Identifiable {
    let id = UUID()
    let name: String
    var isCompleted: Bool
    var completionDate: Date?
    var category: HabitCategory
    var streak: Int
    var lastCompletionDate: Date?
    
    init(name: String, category: HabitCategory = .lifestyle) {
        self.name = name
        self.isCompleted = false
        self.category = category
        self.streak = 0
    }
    
    mutating func toggle() {
        isCompleted.toggle()
        if isCompleted {
            completionDate = Date()
            if let lastDate = lastCompletionDate,
               Calendar.current.isDate(lastDate, inSameDayAs: Date().addingTimeInterval(-86400)) {
                streak += 1
            } else {
                streak = 1
            }
            lastCompletionDate = Date()
        } else {
            completionDate = nil
            if Calendar.current.isDate(lastCompletionDate ?? Date(), inSameDayAs: Date()) {
                streak = max(0, streak - 1)
            }
        }
    }
} 