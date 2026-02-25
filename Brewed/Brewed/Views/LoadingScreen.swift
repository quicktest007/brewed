//
//  LoadingScreen.swift
//  Brewed
//
//  Created by JD Hadley on 1/13/26.
//

import SwiftUI

struct LoadingScreen: View {
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0
    @State private var steamAnimation: Bool = false
    @State private var loadingDotsScale: [CGFloat] = [1.0, 1.0, 1.0]
    @State private var loadingDotsOpacity: [Double] = [0.5, 0.5, 0.5]
    
    var body: some View {
        ZStack {
            // Cream background matching logo design
            Color.coffeeCream
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Animated Logo - centered
                Image("BrewedLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 250, maxHeight: 250)
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                    .frame(maxWidth: .infinity)
                
                // Loading indicator
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(Color.coffeeBrown)
                            .frame(width: 8, height: 8)
                            .scaleEffect(loadingDotsScale[index])
                            .opacity(loadingDotsOpacity[index])
                    }
                }
                .padding(.top, 24)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .onAppear {
            // Animate logo appearance
            withAnimation(.easeOut(duration: 0.8)) {
                logoOpacity = 1.0
                logoScale = 1.0
            }
            
            // Animate steam
            withAnimation(
                Animation.easeInOut(duration: 2.0)
                    .repeatForever(autoreverses: true)
                    .delay(0.5)
            ) {
                steamAnimation = true
            }
            
            // Animate loading dots appearing
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                for i in 0..<3 {
                    withAnimation(.easeIn(duration: 0.3).delay(Double(i) * 0.1)) {
                        loadingDotsOpacity[i] = 1.0
                    }
                }
            }
            
            // Animate loading dots pulsing
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                for i in 0..<3 {
                    withAnimation(
                        Animation.easeInOut(duration: 0.8)
                            .repeatForever(autoreverses: true)
                            .delay(Double(i) * 0.2)
                    ) {
                        loadingDotsScale[i] = 1.3
                        loadingDotsOpacity[i] = 0.8
                    }
                }
            }
        }
    }
}

#Preview {
    LoadingScreen()
}
