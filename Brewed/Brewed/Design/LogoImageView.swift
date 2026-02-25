//
//  LogoImageView.swift
//  Brewed
//
//  Created by JD Hadley on 1/13/26.
//

import SwiftUI

struct LogoImageView: View {
    var size: CGFloat = 120
    
    var body: some View {
        Group {
            if let image = UIImage(named: "BrewedLogo") {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: size)
            } else {
                // Fallback to programmatic logo if image not found
                LogoView(size: size)
            }
        }
    }
}

#Preview {
    LogoImageView()
        .padding()
        .background(Color.coffeeCream)
}
