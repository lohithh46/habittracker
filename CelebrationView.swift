import SwiftUI

struct CelebrationView: View {
    @Binding var isPresented: Bool
    let habitName: String
    @State private var scale: CGFloat = 0.5
    @State private var showSuccess = false
    @State private var showMessage = false
    @ObservedObject private var themeManager = ThemeManager.shared
    
    private var theme: Theme {
        themeManager.currentTheme
    }
    
    var body: some View {
        ZStack {
            // Background overlay with blur
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    dismissCelebration()
                }
            
            // Main celebration card
            VStack(spacing: 25) {
                // Success animation
                ZStack {
                    // Outer circle
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    theme.primaryColor.opacity(0.2),
                                    theme.secondaryColor.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 4
                        )
                        .frame(width: 120, height: 120)
                    
                    // Animated checkmark
                    Circle()
                        .trim(from: 0, to: showSuccess ? 1 : 0)
                        .stroke(
                            LinearGradient(
                                colors: [theme.primaryColor, theme.secondaryColor],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 4
                        )
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))
                    
                    // Checkmark
                    Image(systemName: "checkmark")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [theme.primaryColor, theme.secondaryColor],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .opacity(showSuccess ? 1 : 0)
                        .scaleEffect(showSuccess ? 1 : 0.5)
                }
                .frame(width: 120, height: 120)
                
                // Celebration text with animations
                VStack(spacing: 12) {
                    Text("Habit Completed!")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [theme.primaryColor, theme.secondaryColor],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .opacity(showMessage ? 1 : 0)
                        .offset(y: showMessage ? 0 : 20)
                    
                    Text("Great job completing '\(habitName)'")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(theme.secondaryColor)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .opacity(showMessage ? 1 : 0)
                        .offset(y: showMessage ? 0 : 20)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(.systemBackground))
                    .shadow(
                        color: theme.primaryColor.opacity(0.1),
                        radius: 20,
                        x: 0,
                        y: 10
                    )
            )
            .padding(40)
            .scaleEffect(scale)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                scale = 1.0
            }
            
            withAnimation(.easeOut(duration: 0.5).delay(0.3)) {
                showSuccess = true
            }
            
            withAnimation(.easeOut(duration: 0.5).delay(0.6)) {
                showMessage = true
            }
        }
    }
    
    private func dismissCelebration() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            scale = 0.5
            showSuccess = false
            showMessage = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isPresented = false
        }
    }
}

struct ConfettiPiece: View {
    let index: Int
    @State private var isAnimating = false
    
    private let colors: [Color] = [.red, .blue, .green, .yellow, .purple, .orange, .pink]
    private let shapes: [AnyShape] = [
        AnyShape(Circle()),
        AnyShape(Rectangle()),
        AnyShape(Triangle()),
        AnyShape(Star(points: 5, innerRatio: 0.5)),
        AnyShape(Heart())
    ]
    
    var body: some View {
        shapes[index % shapes.count]
            .fill(colors[index % colors.count])
            .frame(width: 8, height: 8)
            .offset(x: isAnimating ? CGFloat.random(in: -150...150) : 0,
                   y: isAnimating ? 300 : -50)
            .rotationEffect(.degrees(isAnimating ? Double.random(in: 0...360) : 0))
            .opacity(isAnimating ? 0 : 1)
            .onAppear {
                withAnimation(.easeOut(duration: 1.5).delay(Double(index) * 0.02)) {
                    isAnimating = true
                }
            }
    }
}

// Custom shapes for confetti
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct Star: Shape {
    let points: Int
    let innerRatio: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let innerRadius = radius * innerRatio
        
        var path = Path()
        let angle = (2 * .pi) / CGFloat(points * 2)
        
        for i in 0..<points * 2 {
            let currentRadius = i % 2 == 0 ? radius : innerRadius
            let x = center.x + currentRadius * cos(CGFloat(i) * angle - .pi / 2)
            let y = center.y + currentRadius * sin(CGFloat(i) * angle - .pi / 2)
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        path.closeSubpath()
        return path
    }
}

struct Heart: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        
        var path = Path()
        path.move(to: CGPoint(x: width * 0.5, y: height * 0.35))
        
        path.addCurve(
            to: CGPoint(x: width * 0.5, y: height * 0.85),
            control1: CGPoint(x: width * 0.8, y: height * 0.5),
            control2: CGPoint(x: width * 0.8, y: height * 0.7)
        )
        
        path.addCurve(
            to: CGPoint(x: width * 0.5, y: height * 0.35),
            control1: CGPoint(x: width * 0.2, y: height * 0.7),
            control2: CGPoint(x: width * 0.2, y: height * 0.5)
        )
        
        return path
    }
} 