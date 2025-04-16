import SwiftUI

struct AnimatedBackground: View {
    let theme: Theme
    @State private var phase = 0.0
    
    var body: some View {
        ZStack {
            // Base gradient background with multiple colors
            LinearGradient(
                colors: [
                    theme.primaryColor.opacity(0.1),
                    theme.secondaryColor.opacity(0.1),
                    theme.tertiaryColor.opacity(0.1),
                    theme.backgroundColor
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Animated floating shapes with multiple colors
            ForEach(0..<5) { index in
                FloatingShape(index: index, phase: phase)
                    .fill(
                        index % 2 == 0 ? theme.primaryColor.opacity(0.1) : theme.secondaryColor.opacity(0.1)
                    )
                    .blur(radius: 20)
            }
            
            // Additional floating elements with tertiary and quaternary colors
            ForEach(5..<8) { index in
                FloatingShape(index: index, phase: phase + .pi)
                    .fill(
                        index % 2 == 0 ? theme.tertiaryColor.opacity(0.1) : theme.quaternaryColor.opacity(0.1)
                    )
                    .blur(radius: 15)
            }
            
            // Subtle pattern overlay with multiple colors
            GeometryReader { geometry in
                Path { path in
                    let width = geometry.size.width
                    let height = geometry.size.height
                    let spacing: CGFloat = 20
                    
                    for x in stride(from: 0, through: width, by: spacing) {
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: height))
                    }
                    
                    for y in stride(from: 0, through: height, by: spacing) {
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: width, y: y))
                    }
                }
                .stroke(
                    LinearGradient(
                        colors: [
                            theme.primaryColor.opacity(0.05),
                            theme.secondaryColor.opacity(0.05),
                            theme.tertiaryColor.opacity(0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
                .blur(radius: 1)
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
                phase = 2 * .pi
            }
        }
    }
}

struct FloatingShape: Shape {
    let index: Int
    let phase: Double
    
    func path(in rect: CGRect) -> Path {
        let size = rect.width * 0.3
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        var path = Path()
        
        switch index {
        case 0:
            // Circle
            path.addEllipse(in: CGRect(x: center.x - size/2,
                                     y: center.y - size/2,
                                     width: size,
                                     height: size))
        case 1:
            // Star
            let points = 5
            let innerRadius = size * 0.4
            let outerRadius = size * 0.6
            
            for i in 0..<points * 2 {
                let radius = i % 2 == 0 ? outerRadius : innerRadius
                let angle = Double(i) * .pi / Double(points) + phase
                let x = center.x + radius * cos(angle)
                let y = center.y + radius * sin(angle)
                
                if i == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            path.closeSubpath()
        case 2:
            // Wave
            let width = size * 2
            let height = size * 0.5
            let points = 50
            
            for i in 0...points {
                let x = center.x - width/2 + width * CGFloat(i) / CGFloat(points)
                let y = center.y + height * sin(Double(i) * .pi / Double(points) + phase)
                
                if i == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
        case 3:
            // Spiral
            let points = 50
            let maxRadius = size * 0.8
            
            for i in 0...points {
                let angle = Double(i) * 4 * .pi / Double(points)
                let radius = maxRadius * CGFloat(i) / CGFloat(points)
                let x = center.x + radius * cos(angle + phase)
                let y = center.y + radius * sin(angle + phase)
                
                if i == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
        case 4:
            // Heart
            let width = size
            let height = size * 1.2
            
            path.move(to: CGPoint(x: center.x, y: center.y + height/4))
            path.addCurve(to: CGPoint(x: center.x, y: center.y - height/2),
                         control1: CGPoint(x: center.x + width/2, y: center.y - height/4),
                         control2: CGPoint(x: center.x + width/2, y: center.y - height/2))
            path.addCurve(to: CGPoint(x: center.x, y: center.y + height/4),
                         control1: CGPoint(x: center.x - width/2, y: center.y - height/2),
                         control2: CGPoint(x: center.x - width/2, y: center.y - height/4))
        default:
            break
        }
        
        return path
    }
} 