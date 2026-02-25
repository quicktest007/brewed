//
//  LegacyFeedView.swift
//  Brewed
//
//  Legacy Instagram-style feed (Post/CoffeeShop). Use Features/Feed/FeedView for Coffee Cards.
//

import SwiftUI

/// Legacy Instagram-style feed (Post/CoffeeShop). Use Features/Feed/FeedView for Coffee Cards.
struct LegacyFeedView: View {
    @EnvironmentObject var appData: AppData
    @State private var selectedPost: Post?
    @State private var showComments = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Header with logo - centered
                    HStack {
                        Spacer()
                        Image("BrewedLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .background(Color.coffeeCream)
                    
                    // Posts
                    LazyVStack(spacing: 20) {
                        ForEach(appData.posts) { post in
                            PostCardView(post: post)
                                .environmentObject(appData)
                        }
                    }
                    .padding(.top)
                }
            }
            .background(Color.coffeeCream)
            .navigationBarHidden(true)
        }
    }
}

struct PostCardView: View {
    let post: Post
    @EnvironmentObject var appData: AppData
    @State private var showComments = false
    @State private var commentText = ""
    @State private var showCommentInput = false
    
    var user: User? {
        appData.getUser(by: post.userId)
    }
    
    var coffeeShop: CoffeeShop? {
        if let shopId = post.coffeeShopId {
            return appData.coffeeShops.first { $0.id == shopId }
        }
        return nil
    }
    
    var isLiked: Bool {
        post.likes.contains(appData.currentUser.id)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // User header
            HStack {
                AvatarView(user: user, size: 40)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(user?.displayName ?? "Unknown")
                        .font(.headline)
                        .foregroundColor(.coffeeBrown)
                    
                    if let shop = coffeeShop {
                        Text(shop.name)
                            .font(.caption)
                            .foregroundColor(.coffeeAccent)
                    }
                    
                    Text(post.timestamp, style: .relative)
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            
            // Coffee image placeholder
            if post.imageURL != nil {
                Rectangle()
                    .fill(Color.coffeeLight.opacity(0.3))
                    .frame(height: 300)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 50))
                            .foregroundColor(.coffeeAccent)
                    )
            }
            
            // Ratings
            HStack(spacing: 20) {
                HStack(spacing: 4) {
                    Image(systemName: "cup.and.saucer.fill")
                        .foregroundColor(.coffeeBrown)
                    Text(String(format: "%.1f", post.coffeeRating))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.coffeeBrown)
                }
                
                if let shopRating = post.shopRating {
                    HStack(spacing: 4) {
                        Image(systemName: "leaf.fill")
                            .foregroundColor(.coffeeBrown)
                        Text(String(format: "%.1f", shopRating))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.coffeeBrown)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal)
            
            // Caption
            Text(post.caption)
                .font(.body)
                .foregroundColor(.coffeeBrown)
                .padding(.horizontal)
            
            // Actions
            HStack(spacing: 20) {
                Button(action: {
                    appData.toggleLike(postId: post.id)
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(isLiked ? .red : .coffeeBrown)
                        Text("\(post.likes.count)")
                            .foregroundColor(.coffeeBrown)
                    }
                }
                
                Button(action: {
                    showCommentInput.toggle()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "bubble.right")
                            .foregroundColor(.coffeeBrown)
                        Text("\(post.comments.count)")
                            .foregroundColor(.coffeeBrown)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
            
            // Comment input
            if showCommentInput {
                HStack {
                    TextField("Add a comment...", text: $commentText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("Post") {
                        if !commentText.isEmpty {
                            appData.addComment(postId: post.id, text: commentText)
                            commentText = ""
                            showCommentInput = false
                        }
                    }
                    .foregroundColor(.coffeeBrown)
                    .fontWeight(.semibold)
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
            
            // Comments preview
            if !post.comments.isEmpty && !showCommentInput {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(post.comments.prefix(2)) { comment in
                        CommentRowView(comment: comment)
                            .environmentObject(appData)
                    }
                    
                    if post.comments.count > 2 {
                        Button("View all \(post.comments.count) comments") {
                            showComments = true
                        }
                        .font(.caption)
                        .foregroundColor(.coffeeAccent)
                        .padding(.top, 4)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
        .sheet(isPresented: $showComments) {
            CommentsView(post: post)
                .environmentObject(appData)
        }
    }
}

struct CommentRowView: View {
    let comment: Comment
    @EnvironmentObject var appData: AppData
    
    var user: User? {
        appData.getUser(by: comment.userId)
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            AvatarView(user: user, size: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(user?.displayName ?? "Unknown")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.coffeeBrown)
                
                Text(comment.text)
                    .font(.caption)
                    .foregroundColor(.coffeeBrown.opacity(0.8))
            }
            
            Spacer()
        }
    }
}

struct CommentsView: View {
    let post: Post
    @EnvironmentObject var appData: AppData
    @State private var commentText = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(post.comments) { comment in
                            CommentRowView(comment: comment)
                                .environmentObject(appData)
                        }
                    }
                    .padding()
                }
                
                HStack {
                    TextField("Add a comment...", text: $commentText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("Post") {
                        if !commentText.isEmpty {
                            appData.addComment(postId: post.id, text: commentText)
                            commentText = ""
                        }
                    }
                    .foregroundColor(.coffeeBrown)
                    .fontWeight(.semibold)
                }
                .padding()
            }
            .background(Color.coffeeCream)
            .navigationTitle("Comments")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.coffeeBrown)
                }
            }
        }
    }
}

#Preview {
    LegacyFeedView()
        .environmentObject(AppData())
}
