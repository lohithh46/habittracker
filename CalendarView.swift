import SwiftUI

struct CalendarView: View {
    let habits: [Habit]
    let theme: Theme
    @State private var selectedDate = Date()
    
    private let calendar = Calendar.current
    private let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    private var monthTitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: selectedDate)
    }
    
    private var daysInMonth: [Date] {
        let interval = DateInterval(start: startOfMonth(), end: endOfMonth())
        return calendar.generateDates(inside: interval, matching: DateComponents(hour: 0, minute: 0, second: 0))
    }
    
    private var firstWeekday: Int {
        calendar.component(.weekday, from: startOfMonth()) - 1
    }
    
    private func startOfMonth() -> Date {
        let components = calendar.dateComponents([.year, .month], from: selectedDate)
        return calendar.date(from: components) ?? Date()
    }
    
    private func endOfMonth() -> Date {
        let components = DateComponents(month: 1, day: -1)
        return calendar.date(byAdding: components, to: startOfMonth()) ?? Date()
    }
    
    private func isDateCompleted(_ date: Date) -> Bool {
        habits.contains { habit in
            if let completionDate = habit.completionDate {
                return calendar.isDate(completionDate, inSameDayAs: date)
            }
            return false
        }
    }
    
    private func getDateColor(_ date: Date) -> Color {
        if calendar.isDateInToday(date) {
            return theme.primaryColor
        }
        return isDateCompleted(date) ? .green : .red
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Month navigation
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(theme.primaryColor)
                }
                
                Text(monthTitle)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(theme.primaryColor)
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(theme.primaryColor)
                }
            }
            
            // Days of week header
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(theme.secondaryColor)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Calendar grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(0..<firstWeekday, id: \.self) { _ in
                    Color.clear
                        .aspectRatio(1, contentMode: .fill)
                }
                
                ForEach(daysInMonth, id: \.self) { date in
                    let isCompleted = isDateCompleted(date)
                    let isToday = calendar.isDateInToday(date)
                    let dateColor = getDateColor(date)
                    
                    ZStack {
                        Circle()
                            .fill(isCompleted ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                            .overlay(
                                Circle()
                                    .stroke(isToday ? theme.primaryColor : dateColor, lineWidth: 2)
                            )
                        
                        VStack(spacing: 2) {
                            Text("\(calendar.component(.day, from: date))")
                                .font(.system(size: 16, weight: isToday ? .bold : .regular))
                                .foregroundColor(dateColor)
                            
                            if isCompleted {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 8))
                                    .foregroundColor(.green)
                            } else {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 8))
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .aspectRatio(1, contentMode: .fill)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    private func previousMonth() {
        withAnimation {
            selectedDate = calendar.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
        }
    }
    
    private func nextMonth() {
        withAnimation {
            selectedDate = calendar.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
        }
    }
}

// Helper extension for Calendar
extension Calendar {
    func generateDates(inside interval: DateInterval, matching components: DateComponents) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)
        
        enumerateDates(
            startingAfter: interval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }
        
        return dates
    }
} 