import SwiftUI

struct ThemeSelectorView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Theme.themes) { theme in
                    Button(action: {
                        themeManager.currentTheme = theme
                        dismiss()
                    }) {
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(theme.primaryColor.opacity(0.2))
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: theme.icon)
                                    .font(.system(size: 20))
                                    .foregroundColor(theme.primaryColor)
                            }
                            
                            Text(theme.name)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            if themeManager.currentTheme.name == theme.name {
                                Image(systemName: "checkmark")
                                    .foregroundColor(theme.primaryColor)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select Theme")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
} 