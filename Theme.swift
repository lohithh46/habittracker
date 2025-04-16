import SwiftUI

struct Theme: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let primaryColor: Color
    let secondaryColor: Color
    let backgroundColor: Color
    let accentColor: Color
    let textColor: Color
    let tertiaryColor: Color
    let quaternaryColor: Color
    
    var gradient: LinearGradient {
        LinearGradient(
            colors: [primaryColor, secondaryColor, tertiaryColor],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    static let themes: [Theme] = [
        Theme(
            name: "Ocean Waves",
            icon: "water.waves",
            primaryColor: Color(red: 0.2, green: 0.5, blue: 0.8),
            secondaryColor: Color(red: 0.4, green: 0.7, blue: 0.9),
            backgroundColor: Color(red: 0.95, green: 0.97, blue: 1.0),
            accentColor: Color(red: 0.1, green: 0.3, blue: 0.6),
            textColor: Color(red: 0.2, green: 0.2, blue: 0.3),
            tertiaryColor: Color(red: 0.3, green: 0.6, blue: 0.85),
            quaternaryColor: Color(red: 0.5, green: 0.8, blue: 0.95)
        ),
        Theme(
            name: "Sunset Dream",
            icon: "sun.max.fill",
            primaryColor: Color(red: 0.9, green: 0.4, blue: 0.2),
            secondaryColor: Color(red: 1.0, green: 0.6, blue: 0.3),
            backgroundColor: Color(red: 1.0, green: 0.97, blue: 0.95),
            accentColor: Color(red: 0.7, green: 0.3, blue: 0.1),
            textColor: Color(red: 0.3, green: 0.2, blue: 0.2),
            tertiaryColor: Color(red: 0.95, green: 0.5, blue: 0.25),
            quaternaryColor: Color(red: 1.0, green: 0.7, blue: 0.4)
        ),
        Theme(
            name: "Forest Mist",
            icon: "leaf.fill",
            primaryColor: Color(red: 0.2, green: 0.6, blue: 0.3),
            secondaryColor: Color(red: 0.4, green: 0.7, blue: 0.4),
            backgroundColor: Color(red: 0.95, green: 0.98, blue: 0.95),
            accentColor: Color(red: 0.1, green: 0.4, blue: 0.2),
            textColor: Color(red: 0.2, green: 0.3, blue: 0.2),
            tertiaryColor: Color(red: 0.3, green: 0.65, blue: 0.35),
            quaternaryColor: Color(red: 0.5, green: 0.75, blue: 0.45)
        ),
        Theme(
            name: "Lavender Fields",
            icon: "sparkles",
            primaryColor: Color(red: 0.6, green: 0.2, blue: 0.8),
            secondaryColor: Color(red: 0.8, green: 0.4, blue: 0.9),
            backgroundColor: Color(red: 0.98, green: 0.95, blue: 1.0),
            accentColor: Color(red: 0.4, green: 0.1, blue: 0.6),
            textColor: Color(red: 0.3, green: 0.2, blue: 0.3),
            tertiaryColor: Color(red: 0.7, green: 0.3, blue: 0.85),
            quaternaryColor: Color(red: 0.9, green: 0.5, blue: 0.95)
        ),
        Theme(
            name: "Ocean Breeze",
            icon: "drop.fill",
            primaryColor: Color(red: 0.2, green: 0.5, blue: 0.8),
            secondaryColor: Color(red: 0.4, green: 0.7, blue: 0.9),
            backgroundColor: Color(red: 0.95, green: 0.97, blue: 1.0),
            accentColor: Color(red: 0.1, green: 0.3, blue: 0.6),
            textColor: Color(red: 0.2, green: 0.2, blue: 0.3),
            tertiaryColor: Color(red: 0.3, green: 0.6, blue: 0.85),
            quaternaryColor: Color(red: 0.5, green: 0.8, blue: 0.95)
        ),
        Theme(
            name: "Mountain Mist",
            icon: "mountain.2.fill",
            primaryColor: Color(red: 0.4, green: 0.5, blue: 0.6),
            secondaryColor: Color(red: 0.6, green: 0.7, blue: 0.8),
            backgroundColor: Color(red: 0.97, green: 0.97, blue: 0.98),
            accentColor: Color(red: 0.3, green: 0.4, blue: 0.5),
            textColor: Color(red: 0.3, green: 0.3, blue: 0.4),
            tertiaryColor: Color(red: 0.5, green: 0.6, blue: 0.7),
            quaternaryColor: Color(red: 0.7, green: 0.8, blue: 0.9)
        ),
        Theme(
            name: "Cherry Blossom",
            icon: "leaf.circle.fill",
            primaryColor: Color(red: 0.9, green: 0.3, blue: 0.5),
            secondaryColor: Color(red: 1.0, green: 0.5, blue: 0.7),
            backgroundColor: Color(red: 1.0, green: 0.97, blue: 0.98),
            accentColor: Color(red: 0.7, green: 0.2, blue: 0.4),
            textColor: Color(red: 0.3, green: 0.2, blue: 0.2),
            tertiaryColor: Color(red: 0.95, green: 0.4, blue: 0.6),
            quaternaryColor: Color(red: 1.0, green: 0.6, blue: 0.8)
        ),
        Theme(
            name: "Northern Lights",
            icon: "sparkles.rectangle.stack",
            primaryColor: Color(red: 0.2, green: 0.8, blue: 0.4),
            secondaryColor: Color(red: 0.3, green: 0.9, blue: 0.5),
            backgroundColor: Color(red: 0.95, green: 0.98, blue: 0.96),
            accentColor: Color(red: 0.1, green: 0.6, blue: 0.3),
            textColor: Color(red: 0.2, green: 0.3, blue: 0.2),
            tertiaryColor: Color(red: 0.25, green: 0.85, blue: 0.45),
            quaternaryColor: Color(red: 0.35, green: 0.95, blue: 0.55)
        ),
        Theme(
            name: "Desert Sunset",
            icon: "sun.and.horizon.fill",
            primaryColor: Color(red: 0.9, green: 0.5, blue: 0.2),
            secondaryColor: Color(red: 1.0, green: 0.7, blue: 0.3),
            backgroundColor: Color(red: 1.0, green: 0.98, blue: 0.95),
            accentColor: Color(red: 0.7, green: 0.4, blue: 0.1),
            textColor: Color(red: 0.3, green: 0.2, blue: 0.2),
            tertiaryColor: Color(red: 0.95, green: 0.6, blue: 0.25),
            quaternaryColor: Color(red: 1.0, green: 0.8, blue: 0.35)
        ),
        Theme(
            name: "Ocean Depths",
            icon: "water.waves",
            primaryColor: Color(red: 0.1, green: 0.3, blue: 0.5),
            secondaryColor: Color(red: 0.2, green: 0.5, blue: 0.7),
            backgroundColor: Color(red: 0.95, green: 0.97, blue: 1.0),
            accentColor: Color(red: 0.05, green: 0.2, blue: 0.4),
            textColor: Color(red: 0.2, green: 0.2, blue: 0.3),
            tertiaryColor: Color(red: 0.15, green: 0.4, blue: 0.6),
            quaternaryColor: Color(red: 0.25, green: 0.6, blue: 0.8)
        ),
        Theme(
            name: "Aurora Borealis",
            icon: "sparkles.rectangle.stack",
            primaryColor: Color(red: 0.2, green: 0.8, blue: 0.4),
            secondaryColor: Color(red: 0.3, green: 0.9, blue: 0.5),
            backgroundColor: Color(red: 0.95, green: 0.98, blue: 0.96),
            accentColor: Color(red: 0.1, green: 0.6, blue: 0.3),
            textColor: Color(red: 0.2, green: 0.3, blue: 0.2),
            tertiaryColor: Color(red: 0.25, green: 0.85, blue: 0.45),
            quaternaryColor: Color(red: 0.35, green: 0.95, blue: 0.55)
        )
    ]
}

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var currentTheme: Theme {
        didSet {
            UserDefaults.standard.set(currentTheme.name, forKey: "selectedTheme")
        }
    }
    
    private init() {
        let savedThemeName = UserDefaults.standard.string(forKey: "selectedTheme")
        currentTheme = Theme.themes.first { $0.name == savedThemeName } ?? Theme.themes[0]
    }
} 