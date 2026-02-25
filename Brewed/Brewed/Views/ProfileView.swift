//
//  ProfileView.swift
//  Brewed
//
//  Created by JD Hadley on 1/13/26.
//

import SwiftUI
import PhotosUI
import UIKit

struct ProfileView: View {
    @EnvironmentObject var appData: AppData
    @EnvironmentObject var authManager: AuthManager
    @State private var showFriends = false
    @State private var showAddFriend = false
    @State private var showSettings = false
    @State private var showImagePicker = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var profileImage: UIImage?
    
    var userPosts: [Post] {
        appData.posts.filter { $0.userId == appData.currentUser.id }
    }
    
    var friends: [User] {
        appData.currentUser.friends.compactMap { appData.getUser(by: $0) }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Profile header
                    VStack(spacing: 16) {
                        // Profile picture with edit button
                        ZStack(alignment: .bottomTrailing) {
                            // Profile image or placeholder
                            if let image = profileImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            } else if let imageURL = appData.currentUser.profileImageURL, !imageURL.isEmpty {
                                AsyncImage(url: URL(string: imageURL)) { phase in
                                    switch phase {
                                    case .empty:
                                        Circle()
                                            .fill(Color.coffeeAccent)
                                            .frame(width: 100, height: 100)
                                            .overlay(
                                                ProgressView()
                                                    .tint(.white)
                                            )
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                    case .failure:
                                        Circle()
                                            .fill(Color.coffeeAccent)
                                            .frame(width: 100, height: 100)
                                            .overlay(
                                                Text(appData.currentUser.displayName.prefix(1).uppercased())
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 40, weight: .bold))
                                            )
                                    @unknown default:
                                        Circle()
                                            .fill(Color.coffeeAccent)
                                            .frame(width: 100, height: 100)
                                            .overlay(
                                                Text(appData.currentUser.displayName.prefix(1).uppercased())
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 40, weight: .bold))
                                            )
                                    }
                                }
                            } else {
                                Circle()
                                    .fill(Color.coffeeAccent)
                                    .frame(width: 100, height: 100)
                                    .overlay(
                                        Text(appData.currentUser.displayName.prefix(1).uppercased())
                                            .foregroundColor(.white)
                                            .font(.system(size: 40, weight: .bold))
                                    )
                            }
                            
                            // Edit button
                            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                                ZStack {
                                    Circle()
                                        .fill(Color.coffeeBrown)
                                        .frame(width: 32, height: 32)
                                    
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(.coffeeCream)
                                }
                            }
                            .offset(x: 4, y: 4)
                        }
                        
                        VStack(spacing: 4) {
                            Text(appData.currentUser.displayName)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.coffeeBrown)
                            
                            Text("@\(appData.currentUser.username)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            if !appData.currentUser.bio.isEmpty {
                                Text(appData.currentUser.bio)
                                    .font(.body)
                                    .foregroundColor(.coffeeBrown)
                                    .padding(.top, 4)
                            }
                        }
                        
                        // Stats
                        HStack(spacing: 30) {
                            VStack {
                                Text("\(userPosts.count)")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.coffeeBrown)
                                Text("Posts")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            VStack {
                                Text("\(friends.count)")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.coffeeBrown)
                                Text("Friends")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            VStack {
                                Text("\(userPosts.reduce(0) { $0 + $1.likes.count })")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.coffeeBrown)
                                Text("Likes")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.top, 8)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Friends section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Friends")
                                .font(.headline)
                                .foregroundColor(.coffeeBrown)
                            
                            Spacer()
                            
                            Button(action: {
                                showAddFriend = true
                            }) {
                                Image(systemName: "person.badge.plus")
                                    .foregroundColor(.coffeeBrown)
                            }
                        }
                        .padding(.horizontal)
                        
                        if friends.isEmpty {
                            Text("No friends yet. Add some to see their posts!")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(12)
                                .padding(.horizontal)
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(friends) { friend in
                                        FriendCardView(friend: friend)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.top)
                    
                    // My Posts
                    VStack(alignment: .leading, spacing: 12) {
                        Text("My Posts")
                            .font(.headline)
                            .foregroundColor(.coffeeBrown)
                            .padding(.horizontal)
                        
                        if userPosts.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "cup.and.saucer")
                                    .font(.system(size: 50))
                                    .foregroundColor(.coffeeAccent.opacity(0.5))
                                Text("No posts yet")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Share your coffee experience!")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .padding(.horizontal)
                        } else {
                            LazyVStack(spacing: 16) {
                                ForEach(userPosts) { post in
                                    PostCardView(post: post)
                                        .environmentObject(appData)
                                }
                            }
                        }
                    }
                    .padding(.top)
                }
            }
            .background(Color.coffeeCream)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showSettings = true
                    }) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.coffeeBrown)
                    }
                }
            }
            .sheet(isPresented: $showAddFriend) {
                AddFriendView()
                    .environmentObject(appData)
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .onChange(of: selectedPhoto) { oldValue, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        profileImage = image
                        // Save the image URL (in a real app, you'd upload to a server)
                        let imageURL = "profile_\(appData.currentUser.id.uuidString)"
                        appData.updateProfileImage(imageURL: imageURL)
                    }
                }
            }
            .onAppear {
                // Load existing profile image if available
                if let imageURL = appData.currentUser.profileImageURL, !imageURL.isEmpty {
                    // In a real app, you'd load from the server
                    // For now, we'll just show the placeholder if it's a local reference
                }
            }
        }
    }
}

struct FriendCardView: View {
    let friend: User
    
    var body: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(Color.coffeeAccent)
                .frame(width: 60, height: 60)
                .overlay(
                    Text(friend.displayName.prefix(1).uppercased())
                        .foregroundColor(.white)
                        .font(.headline)
                )
            
            Text(friend.displayName)
                .font(.caption)
                .foregroundColor(.coffeeBrown)
                .lineLimit(1)
                .frame(width: 80)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
    }
}

struct AddFriendView: View {
    @EnvironmentObject var appData: AppData
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    
    var availableUsers: [User] {
        let currentUserId = appData.currentUser.id
        let friendIds = appData.currentUser.friends
        
        return appData.users.filter { user in
            user.id != currentUserId && !friendIds.contains(user.id)
        }
    }
    
    var filteredUsers: [User] {
        if searchText.isEmpty {
            return availableUsers
        }
        return availableUsers.filter { user in
            user.displayName.localizedCaseInsensitiveContains(searchText) ||
            user.username.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .padding()
                
                List {
                    ForEach(filteredUsers) { user in
                        HStack {
                            Circle()
                                .fill(Color.coffeeAccent)
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Text(user.displayName.prefix(1).uppercased())
                                        .foregroundColor(.white)
                                        .font(.headline)
                                )
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(user.displayName)
                                    .font(.headline)
                                    .foregroundColor(.coffeeBrown)
                                Text("@\(user.username)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                appData.addFriend(userId: user.id)
                            }) {
                                Text("Add")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.coffeeBrown)
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .background(Color.coffeeCream)
            }
            .navigationTitle("Add Friends")
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

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search users...", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(10)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppData())
}
