//
//  LogoView.swift
//  Brewed
//
//  Created by JD Hadley on 1/13/26.
//

import SwiftUI

struct LogoView: View {
    var size: CGFloat = 120
    
    var body: some View {
        VStack(spacing: 8) {
            // Stylized B with steam
            ZStack(alignment: .topLeading) {
                // The letter B
                Text("B")
                    .font(.system(size: size * 0.6, weight: .bold, design: .rounded))
                    .foregroundColor(.coffeeBrown)
                    .offset(x: 0, y: 0)
                
                // Steam curl - positioned relative to B
                ZStack {
                    // First curl
                    Path { path in
                        let startX: CGFloat = size * 0.12
                        let startY: CGFloat = size * 0.08
                        path.move(to: CGPoint(x: startX, y: startY))
                        path.addCurve(
                            to: CGPoint(x: startX - 6, y: startY - 12),
                            control1: CGPoint(x: startX - 2, y: startY - 4),
                            control2: CGPoint(x: startX - 4, y: startY - 8)
                        )
                        path.addCurve(
                            to: CGPoint(x: startX + 1, y: startY - 18),
                            control1: CGPoint(x: startX - 4, y: startY - 15),
                            control2: CGPoint(x: startX - 1, y: startY - 17)
                        )
                    }
                    .stroke(Color.coffeeBrown, lineWidth: 2.5)
                    
                    // Second smaller curl
                    Path { path in
                        let startX: CGFloat = size * 0.18
                        let startY: CGFloat = size * 0.10
                        path.move(to: CGPoint(x: startX, y: startY))
                        path.addCurve(
                            to: CGPoint(x: startX - 4, y: startY - 10),
                            control1: CGPoint(x: startX - 1, y: startY - 3),
                            control2: CGPoint(x: startX - 3, y: startY - 6)
                        )
                        path.addCurve(
                            to: CGPoint(x: startX + 1, y: startY - 15),
                            control1: CGPoint(x: startX - 3, y: startY - 13),
                            control2: CGPoint(x: startX - 1, y: startY - 14)
                        )
                    }
                    .stroke(Color.coffeeBrown, lineWidth: 2)
                }
                .offset(x: 0, y: 0)
            }
            .frame(width: size, height: size * 0.7)
            
            // "Brewed" text
            Text("Brewed")
                .font(.system(size: size * 0.35, weight: .bold, design: .rounded))
                .foregroundColor(.coffeeBrown)
            
            // Tagline
            Text("TASTE. RATE. DISCOVER.")
                .font(.system(size: size * 0.12, weight: .medium, design: .rounded))
                .foregroundColor(.coffeeBrown)
                .tracking(1)
        }
    }
}

#Preview {
    LogoView()
        .padding()
        .background(Color.coffeeCream)
}
