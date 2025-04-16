import SwiftUI

struct NeumorphicCard<Content: View>: View {
    let content: Content
    let theme: Theme
    @State private var isPressed = false
    
    init(theme: Theme, @ViewBuilder content: () -> Content) {
        self.theme = theme
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(
                ZStack {
                    // Base card with gradient
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [
                                    theme.backgroundColor,
                                    theme.backgroundColor.opacity(0.95)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.2),
                                            Color.white.opacity(0.1)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                                .blur(radius: 1)
                        )
                        .shadow(
                            color: theme.primaryColor.opacity(0.1),
                            radius: isPressed ? 5 : 10,
                            x: 5,
                            y: 5
                        )
                        .shadow(
                            color: Color.white.opacity(0.7),
                            radius: isPressed ? 5 : 10,
                            x: -5,
                            y: -5
                        )
                    
                    // Subtle gradient overlay
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [
                                    theme.primaryColor.opacity(0.05),
                                    theme.secondaryColor.opacity(0.05),
                                    theme.tertiaryColor.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    // Inner glow effect
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    theme.primaryColor.opacity(0.1),
                                    theme.secondaryColor.opacity(0.1),
                                    theme.tertiaryColor.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                        .blur(radius: 2)
                }
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
            .onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isPressed = false
                    }
                }
            }
    }
} 