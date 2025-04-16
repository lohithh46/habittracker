import SwiftUI

struct ContentView: View {
    @State private var habits: [Habit] = []
    @State private var showingDeleteAlert = false
    @State private var habitToDelete: Habit?
    @State private var showingCelebration = false
    @State private var completedHabit: Habit?
    @State private var showingThemeSelector = false
    @State private var selectedTab = 0
    @State private var showStats = false
    @State private var showingCalendar = false
    @State private var showGreeting = false
    @State private var currentQuoteIndex = 0
    @ObservedObject private var themeManager = ThemeManager.shared
    
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        default: return "Good Evening"
        }
    }
    
    private var motivationalQuotes = [
        "Small steps, big changes!",
        "Every day is a new opportunity!",
        "You're making progress!",
        "Stay focused, stay strong!",
        "Your future self will thank you!",
        "Consistency is key to success!",
        "Make today count!",
        "You've got this!",
        "Progress over perfection!",
        "Keep pushing forward!"
    ]
    
    private var currentQuote: String {
        motivationalQuotes[currentQuoteIndex]
    }
    
    private var totalStreak: Int {
        habits.reduce(0) { $0 + $1.streak }
    }
    
    private var bestStreak: Int {
        habits.map { $0.streak }.max() ?? 0
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Enhanced background
                theme.backgroundColor
                    .ignoresSafeArea()
                
                // Animated gradient background
                GeometryReader { geometry in
                    ZStack {
                        // Base gradient
                        LinearGradient(
                            colors: [
                                theme.primaryColor.opacity(0.1),
                                theme.secondaryColor.opacity(0.05),
                                theme.backgroundColor
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .ignoresSafeArea()
                        
                        // Animated circles
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(theme.primaryColor.opacity(0.1))
                                .frame(width: geometry.size.width * 0.6)
                                .blur(radius: 50)
                                .offset(
                                    x: CGFloat.random(in: -100...100),
                                    y: CGFloat.random(in: -100...100)
                                )
                                .animation(
                                    Animation.easeInOut(duration: Double.random(in: 4...6))
                                        .repeatForever(autoreverses: true)
                                        .delay(Double(index) * 0.8),
                                    value: UUID()
                                )
                        }
                        
                        // Subtle pattern
                        Path { path in
                            let size = min(geometry.size.width, geometry.size.height) * 0.15
                            for x in stride(from: 0, to: geometry.size.width, by: size) {
                                for y in stride(from: 0, to: geometry.size.height, by: size) {
                                    let rect = CGRect(x: x, y: y, width: size, height: size)
                                    path.addEllipse(in: rect)
                                }
                            }
                        }
                        .fill(theme.primaryColor.opacity(0.02))
                        .blur(radius: 1)
                    }
                }
                
                // Main content
                ScrollView {
                    VStack(spacing: 20) {
                        // Greeting section
                        VStack(alignment: .leading, spacing: 8) {
                            Text(greeting)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(theme.primaryColor)
                                .opacity(showGreeting ? 1 : 0)
                                .offset(x: showGreeting ? 0 : -20)
                                .animation(.easeOut(duration: 0.8), value: showGreeting)
                            
                            Text(currentQuote)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(theme.secondaryColor)
                                .opacity(showGreeting ? 1 : 0)
                                .offset(x: showGreeting ? 0 : -20)
                                .animation(.easeOut(duration: 0.8).delay(0.2), value: showGreeting)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        // Streak stats
                        HStack(spacing: 15) {
                            StatCard(
                                title: "Total Streak",
                                value: "\(totalStreak)",
                                icon: "flame.fill",
                                theme: theme,
                                showStats: showStats
                            )
                            StatCard(
                                title: "Best Streak",
                                value: "\(bestStreak)",
                                icon: "star.fill",
                                theme: theme,
                                showStats: showStats
                            )
                        }
                        .padding(.horizontal)
                        .opacity(showStats ? 1 : 0)
                        .offset(y: showStats ? 0 : 20)
                        .animation(.easeOut(duration: 0.8).delay(0.1), value: showStats)
                        
                        // Add habit section
                        NeumorphicCard(theme: theme) {
                            AddHabitView(habits: $habits)
                        }
                        .padding(.horizontal)
                        .opacity(showStats ? 1 : 0)
                        .offset(y: showStats ? 0 : 20)
                        .animation(.easeOut(duration: 0.8), value: showStats)
                        
                        // Stats section
                        let completedCount = habits.filter { $0.isCompleted }.count
                        HStack(spacing: 15) {
                            StatCard(title: "Total", value: "\(habits.count)", icon: "list.bullet", theme: theme, showStats: showStats)
                            StatCard(title: "Completed", value: "\(completedCount)", icon: "checkmark.circle", theme: theme, showStats: showStats)
                        }
                        .padding(.horizontal)
                        .opacity(showStats ? 1 : 0)
                        .offset(y: showStats ? 0 : 20)
                        .animation(.easeOut(duration: 0.8).delay(0.1), value: showStats)
                        
                        if habits.isEmpty {
                            // Empty state
                            NeumorphicCard(theme: theme) {
                                VStack(spacing: 25) {
                                    ZStack {
                                        Circle()
                                            .fill(theme.primaryColor.opacity(0.1))
                                            .frame(width: 100, height: 100)
                                        
                                        Image(systemName: "list.bullet.clipboard")
                                            .font(.system(size: 40))
                                            .foregroundColor(theme.primaryColor)
                                            .scaleEffect(showStats ? 1.1 : 1.0)
                                            .animation(
                                                .easeInOut(duration: 2.0)
                                                .repeatForever(autoreverses: true),
                                                value: showStats
                                            )
                                    }
                                    
                                    Text("No habits yet")
                                        .font(.title2.bold())
                                        .foregroundColor(theme.primaryColor)
                                    
                                    Text("Start building better habits today!")
                                        .font(.subheadline)
                                        .foregroundColor(theme.secondaryColor)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                }
                                .padding(.vertical, 30)
                                .frame(maxWidth: .infinity)
                            }
                            .padding(.horizontal)
                            .opacity(showStats ? 1 : 0)
                            .offset(y: showStats ? 0 : 20)
                            .animation(.easeOut(duration: 0.8), value: showStats)
                        } else {
                            // Habits list
                            LazyVStack(spacing: 15) {
                                ForEach(habits) { habit in
                                    NeumorphicCard(theme: theme) {
                                        HStack(spacing: 15) {
                                            // Category icon
                                            ZStack {
                                                Circle()
                                                    .fill(habit.category.color.opacity(0.2))
                                                    .frame(width: 40, height: 40)
                                                
                                                Image(systemName: habit.category.icon)
                                                    .font(.system(size: 20))
                                                    .foregroundColor(habit.category.color)
                                            }
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(habit.name)
                                                    .font(.system(size: 16, weight: .medium))
                                                    .foregroundColor(theme.textColor)
                                                
                                                HStack(spacing: 8) {
                                                    if habit.streak > 0 {
                                                        HStack(spacing: 4) {
                                                            Image(systemName: "flame.fill")
                                                                .font(.system(size: 12))
                                                            Text("\(habit.streak) days")
                                                                .font(.system(size: 12))
                                                        }
                                                        .foregroundColor(.orange)
                                                    }
                                                    
                                                    Text(habit.category.rawValue)
                                                        .font(.system(size: 12))
                                                        .foregroundColor(habit.category.color)
                                                }
                                            }
                                            
                                            Spacer()
                                            
                                            // Action buttons
                                            HStack(spacing: 12) {
                                                // Toggle button
                                                Button(action: {
                                                    toggleHabit(habit)
                                                }) {
                                                    ZStack {
                                                        Circle()
                                                            .stroke(habit.isCompleted ? theme.primaryColor : Color.gray.opacity(0.3), lineWidth: 2)
                                                            .frame(width: 30, height: 30)
                                                        
                                                        if habit.isCompleted {
                                                            Image(systemName: "checkmark")
                                                                .font(.system(size: 16, weight: .bold))
                                                                .foregroundColor(theme.primaryColor)
                                                        }
                                                    }
                                                }
                                                
                                                // Delete button
                                                Button(action: {
                                                    withAnimation {
                                                        habitToDelete = habit
                                                        showingDeleteAlert = true
                                                    }
                                                }) {
                                                    Image(systemName: "trash")
                                                        .font(.system(size: 16))
                                                        .foregroundColor(.red.opacity(0.7))
                                                }
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                    .opacity(showStats ? 1 : 0)
                                    .offset(y: showStats ? 0 : 20)
                                    .animation(.easeOut(duration: 0.8).delay(0.2), value: showStats)
                                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                        Button(role: .destructive) {
                                            withAnimation {
                                                habitToDelete = habit
                                                showingDeleteAlert = true
                                            }
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.bottom, 30)
                }
                .padding(.horizontal, 0)
                .ignoresSafeArea(edges: .horizontal)
            }
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 15) {
                        // Calendar button
                        Button {
                            showingCalendar = true
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(theme.primaryColor.opacity(0.2))
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: "calendar")
                                    .font(.system(size: 20))
                                    .foregroundColor(theme.primaryColor)
                                    .scaleEffect(showStats ? 1.1 : 1.0)
                                    .animation(
                                        .easeInOut(duration: 1.5)
                                        .repeatForever(autoreverses: true),
                                        value: showStats
                                    )
                            }
                        }
                        
                        // Theme selector button
                        Button {
                            showingThemeSelector = true
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(theme.primaryColor.opacity(0.2))
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: theme.icon)
                                    .font(.system(size: 20))
                                    .foregroundColor(theme.primaryColor)
                                    .scaleEffect(showStats ? 1.1 : 1.0)
                                    .animation(
                                        .easeInOut(duration: 1.5)
                                        .repeatForever(autoreverses: true),
                                        value: showStats
                                    )
                            }
                        }
                    }
                }
            }
            .alert("Delete Habit", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) {
                    habitToDelete = nil
                }
                Button("Delete", role: .destructive) {
                    if let habit = habitToDelete {
                        withAnimation(.easeOut(duration: 0.8)) {
                            habits.removeAll { $0.id == habit.id }
                        }
                    }
                }
            } message: {
                if let habit = habitToDelete {
                    Text("Are you sure you want to delete '\(habit.name)'?")
                }
            }
            .overlay {
                if showingCelebration, let habit = completedHabit {
                    CelebrationView(isPresented: $showingCelebration, habitName: habit.name)
                }
            }
            .sheet(isPresented: $showingThemeSelector) {
                ThemeSelectorView()
            }
            .sheet(isPresented: $showingCalendar) {
                NavigationView {
                    CalendarView(habits: habits, theme: theme)
                        .padding()
                        .navigationTitle("Habit Calendar")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Done") {
                                    showingCalendar = false
                                }
                                .foregroundColor(theme.primaryColor)
                            }
                        }
                }
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.8)) {
                    showStats = true
                }
                withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
                    showGreeting = true
                }
                
                // Start quote rotation timer
                Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
                    withAnimation {
                        currentQuoteIndex = (currentQuoteIndex + 1) % motivationalQuotes.count
                    }
                }
            }
        }
    }
    
    private var theme: Theme {
        themeManager.currentTheme
    }
    
    private func toggleHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            var updatedHabit = habit
            updatedHabit.toggle()
            withAnimation(.easeOut(duration: 0.8)) {
                habits[index] = updatedHabit
            }
            
            if updatedHabit.isCompleted {
                completedHabit = updatedHabit
                showingCelebration = true
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let theme: Theme
    let showStats: Bool
    
    var body: some View {
        NeumorphicCard(theme: theme) {
            VStack(spacing: 12) {
                HStack {
                    Text(title)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(theme.secondaryColor)
                    
                    Spacer()
                    
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundColor(theme.primaryColor)
                        .scaleEffect(showStats ? 1.1 : 1.0)
                        .animation(
                            .easeInOut(duration: 2.0)
                            .repeatForever(autoreverses: true),
                            value: showStats
                        )
                }
                
                Text(value)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(theme.primaryColor)
            }
            .padding(.horizontal, 5)
        }
    }
}

#Preview {
    ContentView()
} 