import SwiftUI

struct AddHabitView: View {
    @State private var habitName = ""
    @State private var selectedCategory: HabitCategory = .lifestyle
    @State private var showingCategoryPicker = false
    @Binding var habits: [Habit]
    @State private var isAnimating = false
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        VStack(spacing: 15) {
            // Category selection button
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    showingCategoryPicker.toggle()
                }
            }) {
                HStack {
                    Image(systemName: selectedCategory.icon)
                        .font(.system(size: 16))
                    Text(selectedCategory.rawValue)
                        .font(.system(size: 14, weight: .medium))
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12))
                        .rotationEffect(.degrees(showingCategoryPicker ? 180 : 0))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(selectedCategory.color.opacity(0.2))
                )
                .foregroundColor(selectedCategory.color)
            }
            
            if showingCategoryPicker {
                VStack(spacing: 8) {
                    ForEach(HabitCategory.allCases, id: \.self) { category in
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                selectedCategory = category
                                showingCategoryPicker = false
                            }
                        }) {
                            HStack {
                                Image(systemName: category.icon)
                                    .font(.system(size: 16))
                                Text(category.rawValue)
                                    .font(.system(size: 14, weight: .medium))
                                Spacer()
                                if category == selectedCategory {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 12))
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(category.color.opacity(0.2))
                            )
                            .foregroundColor(category.color)
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(.top, 4)
            }
            
            // Habit input
            HStack(spacing: 15) {
                // Custom text field
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(theme.primaryColor.opacity(0.7))
                    
                    TextField("Add a new habit", text: $habitName)
                        .font(.system(size: 16))
                        .textFieldStyle(PlainTextFieldStyle())
                    
                    if !habitName.isEmpty {
                        Button(action: {
                            habitName = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray.opacity(0.5))
                                .font(.system(size: 16))
                        }
                    }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                )
                
                // Add button
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isAnimating = true
                        addHabit()
                    }
                }) {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(habitName.isEmpty ? .gray.opacity(0.3) : theme.primaryColor)
                        .scaleEffect(isAnimating ? 1.2 : 1.0)
                        .rotationEffect(.degrees(isAnimating ? 360 : 0))
                }
                .disabled(habitName.isEmpty)
                .onChange(of: isAnimating) { oldValue, newValue in
                    if newValue {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            isAnimating = false
                        }
                    }
                }
            }
        }
    }
    
    private var theme: Theme {
        themeManager.currentTheme
    }
    
    private func addHabit() {
        let trimmedHabit = habitName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedHabit.isEmpty {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                habits.append(Habit(name: trimmedHabit, category: selectedCategory))
                habitName = ""
            }
        }
    }
}

struct CategoryButton: View {
    let category: HabitCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.system(size: 14))
                Text(category.rawValue)
                    .font(.system(size: 14, weight: .medium))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? category.color.opacity(0.2) : Color.gray.opacity(0.1))
            )
            .foregroundColor(isSelected ? category.color : .gray)
        }
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    let theme: Theme
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(theme.backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(theme.primaryColor.opacity(0.2), lineWidth: 1)
            )
    }
}

#Preview {
    AddHabitView(habits: .constant([]))
} 