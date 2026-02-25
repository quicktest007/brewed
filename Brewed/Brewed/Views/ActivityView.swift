//
//  ActivityView.swift
//  Brewed
//
//  Created by JD Hadley on 1/13/26.
//

import SwiftUI

struct ActivityView: View {
    @EnvironmentObject var appData: AppData
    @EnvironmentObject var authManager: AuthManager
    @State private var showCreateAccount = false
    
    var body: some View {
        if !authManager.hasAccount {
            // Show create account prompt
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 0) {
                    HStack {
                        Text("Activity")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.coffeeBrown)
                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    
                    Divider()
                        .background(Color.coffeeCream)
                }
                
                // Empty State
                VStack(spacing: 24) {
                    Spacer()
                    
                    // Icon
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.coffeeBrown, Color.coffeeAccent]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 96, height: 96)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                        
                        Image(systemName: "heart.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.coffeeCream)
                    }
                    
                    VStack(spacing: 12) {
                        Text("Stay Connected")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.coffeeBrown)
                        
                        Text("Create an account to see likes, comments, and interactions from other coffee enthusiasts in the community.")
                            .font(.body)
                            .foregroundColor(.coffeeAccent)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                            .padding(.horizontal, 32)
                    }
                    
                    Button(action: {
                        showCreateAccount = true
                    }) {
                        Text("Create Account")
                            .font(.headline)
                            .foregroundColor(.coffeeCream)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.coffeeBrown, Color.coffeeAccent]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 8)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.coffeeCream)
            }
            .onChange(of: showCreateAccount) { oldValue, newValue in
                if newValue {
                    authManager.signOut()
                }
            }
        } else {
            // Show activity feed
            activityFeedView
        }
    }
    
    private var activityFeedView: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 0) {
                HStack {
                    Text("Activity")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.coffeeBrown)
                    Spacer()
                }
                .padding()
                .background(Color.white)
                
                Divider()
                    .background(Color.coffeeCream)
            }
            
            // Activity feed
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(sampleActivities) { activity in
                        ActivityRowView(activity: activity)
                            .environmentObject(appData)
                    }
                }
            }
            .background(Color.coffeeCream)
        }
    }
    
    // Sample activities matching the React design
    private var sampleActivities: [ActivityItem] {
        [
            ActivityItem(
                id: UUID(),
                type: .like,
                userName: "Blue Bottle Coffee",
                userUsername: "bluebottle",
                userVerified: true,
                postImageURL: "https://images.unsplash.com/photo-1650963121913-84909144dc89?w=100",
                activityText: "liked your post",
                timestamp: Date().addingTimeInterval(-120)
            ),
            ActivityItem(
                id: UUID(),
                type: .comment,
                userName: "Marcus Williams",
                userUsername: "coffeewithmarcus",
                userVerified: false,
                postImageURL: "https://images.unsplash.com/photo-1595827295672-97a059484442?w=100",
                activityText: "commented: \"This looks amazing! What brew ratio did you use?\"",
                timestamp: Date().addingTimeInterval(-900)
            ),
            ActivityItem(
                id: UUID(),
                type: .follow,
                userName: "Emma Rodriguez",
                userUsername: "emmacoffeejourney",
                userVerified: false,
                postImageURL: nil,
                activityText: "started following you",
                timestamp: Date().addingTimeInterval(-3600)
            ),
            ActivityItem(
                id: UUID(),
                type: .like,
                userName: "Stumptown Coffee",
                userUsername: "stumptowncoffee",
                userVerified: true,
                postImageURL: "https://images.unsplash.com/photo-1705952285570-113e76f63fb0?w=100",
                activityText: "liked your post",
                timestamp: Date().addingTimeInterval(-7200)
            ),
            ActivityItem(
                id: UUID(),
                type: .mention,
                userName: "Counter Culture",
                userUsername: "counterculturecoffee",
                userVerified: true,
                postImageURL: "https://images.unsplash.com/photo-1613536844480-ac5d7b1b6ed1?w=100",
                activityText: "mentioned you in a post",
                timestamp: Date().addingTimeInterval(-10800)
            ),
            ActivityItem(
                id: UUID(),
                type: .like,
                userName: "Jake Mitchell",
                userUsername: "jakesbrewery",
                userVerified: false,
                postImageURL: "https://images.unsplash.com/photo-1561641377-f7456d23aa9b?w=100",
                activityText: "and 23 others liked your post",
                timestamp: Date().addingTimeInterval(-18000)
            ),
            ActivityItem(
                id: UUID(),
                type: .comment,
                userName: "Intelligentsia",
                userUsername: "intelligentsiacoffee",
                userVerified: true,
                postImageURL: "https://images.unsplash.com/photo-1558996260-4bac67dbd110?w=100",
                activityText: "commented: \"Great tasting notes! Have you tried our Kenya Kiambu?\"",
                timestamp: Date().addingTimeInterval(-28800)
            ),
            ActivityItem(
                id: UUID(),
                type: .follow,
                userName: "Sarah Chen",
                userUsername: "sarahcoffee",
                userVerified: false,
                postImageURL: nil,
                activityText: "started following you",
                timestamp: Date().addingTimeInterval(-43200)
            )
        ]
    }
}

struct ActivityItem: Identifiable {
    let id: UUID
    let type: ActivityType
    let userName: String
    let userUsername: String
    let userVerified: Bool
    let postImageURL: String?
    let activityText: String
    let timestamp: Date
    
    enum ActivityType {
        case like
        case comment
        case follow
        case mention
    }
}

struct ActivityRowView: View {
    let activity: ActivityItem
    @EnvironmentObject var appData: AppData
    @State private var isFollowing = false
    
    var activityIcon: (name: String, color: Color) {
        switch activity.type {
        case .like:
            return ("heart.fill", .red)
        case .comment:
            return ("bubble.right.fill", .coffeeBrown)
        case .follow:
            return ("person.badge.plus", .coffeeBrown)
        case .mention:
            return ("cup.and.saucer.fill", .coffeeAccent)
        }
    }
    
    var formattedTimestamp: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: activity.timestamp, relativeTo: Date())
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Activity icon
            ZStack {
                Circle()
                    .fill(Color.coffeeCream)
                    .frame(width: 40, height: 40)
                
                Image(systemName: activityIcon.name)
                    .font(.system(size: 20))
                    .foregroundColor(activityIcon.color)
            }
            
            // User avatar
            AvatarView(user: nil, size: 40)
                .overlay(
                    // Note: In a real app, you'd pass the actual user object here
                    // For now, we'll use a placeholder since ActivityItem doesn't have full user info
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.coffeeAccent, Color.coffeeLight]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 40, height: 40)
                        .overlay(
                            Text(activity.userName.prefix(1).uppercased())
                                .font(.headline)
                                .foregroundColor(.white)
                        )
                )
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .center, spacing: 4) {
                    Text(activity.userName)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.coffeeBrown)
                    
                    if activity.userVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.coffeeBrown)
                    }
                    
                    Text(activity.activityText)
                        .font(.subheadline)
                        .foregroundColor(.coffeeAccent)
                }
                
                Text(formattedTimestamp)
                    .font(.caption)
                    .foregroundColor(.coffeeAccent)
            }
            
            Spacer()
            
            // Post thumbnail or Follow button
            if activity.type == .follow {
                Button(action: {
                    isFollowing.toggle()
                }) {
                    Text(isFollowing ? "Following" : "Follow")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(isFollowing ? .coffeeBrown : .coffeeCream)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(isFollowing ? Color.coffeeCream : Color.coffeeBrown)
                        .cornerRadius(20)
                }
            } else if let imageURL = activity.postImageURL {
                AsyncImage(url: URL(string: imageURL)) { phase in
                    switch phase {
                    case .empty:
                        Rectangle()
                            .fill(Color.coffeeCream)
                            .frame(width: 48, height: 48)
                            .cornerRadius(8)
                            .overlay(
                                ProgressView()
                                    .tint(.coffeeBrown)
                            )
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 48, height: 48)
                            .clipped()
                            .cornerRadius(8)
                    case .failure:
                        Rectangle()
                            .fill(Color.coffeeCream)
                            .frame(width: 48, height: 48)
                            .cornerRadius(8)
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundColor(.coffeeAccent)
                            )
                    @unknown default:
                        EmptyView()
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.coffeeCream),
            alignment: .bottom
        )
        .contentShape(Rectangle())
        .onTapGesture {
            // Handle tap to navigate to post or profile
        }
    }
}

#Preview {
    ActivityView()
        .environmentObject(AppData())
        .environmentObject(AuthManager())
}
