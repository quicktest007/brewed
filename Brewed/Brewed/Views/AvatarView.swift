//
//  AvatarView.swift
//  Brewed
//
//  Created by JD Hadley on 1/13/26.
//

import SwiftUI

struct AvatarView: View {
    let user: User?
    let size: CGFloat
    
    init(user: User?, size: CGFloat = 40) {
        self.user = user
        self.size = size
    }
    
    var body: some View {
        Group {
            if let imageURL = user?.profileImageURL, !imageURL.isEmpty {
                AsyncImage(url: URL(string: imageURL)) { phase in
                    switch phase {
                    case .empty:
                        placeholderView
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: size, height: size)
                            .clipShape(Circle())
                    case .failure:
                        placeholderView
                    @unknown default:
                        placeholderView
                    }
                }
            } else {
                placeholderView
            }
        }
    }
    
    private var placeholderView: some View {
        Circle()
            .fill(Color.coffeeAccent)
            .frame(width: size, height: size)
            .overlay(
                Text(user?.displayName.prefix(1).uppercased() ?? "?")
                    .foregroundColor(.white)
                    .font(.system(size: size * 0.4, weight: .bold))
            )
    }
}

#Preview {
    HStack(spacing: 20) {
        AvatarView(user: User(username: "test", displayName: "John Doe"), size: 40)
        AvatarView(user: User(username: "test", displayName: "Jane Smith"), size: 60)
        AvatarView(user: User(username: "test", displayName: "Bob"), size: 80)
    }
    .padding()
}
