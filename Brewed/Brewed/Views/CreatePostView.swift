//
//  CreatePostView.swift
//  Brewed
//
//  Created by JD Hadley on 1/13/26.
//

import SwiftUI
import PhotosUI
import UIKit

struct CreatePostView: View {
    @EnvironmentObject var appData: AppData
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) var dismiss
    @State private var coffeeName = ""
    @State private var roaster = ""
    @State private var location = ""
    @State private var preparationMethod = ""
    @State private var rating: Int = 0
    @State private var hoverRating: Int = 0
    @State private var selectedTastingNotes: Set<String> = []
    @State private var customNote = ""
    @State private var caption = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showSuccessAlert = false
    
    let suggestedNotes = [
        "Chocolate", "Caramel", "Nutty", "Citrus", "Floral",
        "Berry", "Fruity", "Smooth", "Bright", "Bold",
        "Earthy", "Spicy", "Sweet", "Balanced", "Complex"
    ]
    
    let brewingMethods = [
        "Espresso", "Pour Over", "French Press", "AeroPress",
        "Cold Brew", "Moka Pot", "Drip", "Chemex", "Siphon"
    ]
    
    var body: some View {
        if !authManager.hasAccount {
            // Show create account prompt
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Create Post")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.coffeeBrown)
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.coffeeAccent)
                            .padding(8)
                            .background(Color.coffeeCream)
                            .clipShape(Circle())
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
                
                // Empty State
                VStack(spacing: 24) {
                    Spacer()
                    
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
                        
                        Image(systemName: "camera.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.coffeeCream)
                    }
                    
                    VStack(spacing: 12) {
                        Text("Share Your Coffee Experience")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.coffeeBrown)
                        
                        Text("Create an account to share photos, rate coffees, add tasting notes, and connect with the coffee community.")
                            .font(.body)
                            .foregroundColor(.coffeeAccent)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                            .padding(.horizontal, 32)
                    }
                    
                    VStack(spacing: 12) {
                        Button(action: {
                            authManager.signOut()
                            dismiss()
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
                        
                        Button(action: { dismiss() }) {
                            Text("Back")
                                .font(.headline)
                                .foregroundColor(.coffeeBrown)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.coffeeCream.opacity(0.5), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.coffeeCream)
            }
        } else {
            // Create post form
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.coffeeBrown)
                            .padding(8)
                            .background(Color.coffeeCream)
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Text("New Post")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.coffeeBrown)
                    
                    Spacer()
                    
                    Button(action: {
                        createPost()
                    }) {
                        Text("Share")
                            .font(.headline)
                            .foregroundColor(.coffeeCream)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 8)
                            .background(Color.coffeeBrown)
                            .cornerRadius(20)
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
                
                // Form
                ScrollView {
                    VStack(spacing: 24) {
                        // Photo upload
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Photo (Optional)")
                                .font(.subheadline)
                                .foregroundColor(.coffeeBrown)
                            
                            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color.coffeeCream.opacity(0.5), style: StrokeStyle(lineWidth: 2, dash: [8]))
                                        .frame(height: 200)
                                        .background(Color.coffeeCream.opacity(0.3))
                                    
                                    if let image = selectedImage {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height: 200)
                                            .clipped()
                                            .cornerRadius(16)
                                    } else {
                                        VStack(spacing: 12) {
                                            Image(systemName: "camera.fill")
                                                .font(.system(size: 48))
                                                .foregroundColor(.coffeeAccent)
                                            Text("Tap to add photo")
                                                .font(.subheadline)
                                                .foregroundColor(.coffeeAccent)
                                        }
                                    }
                                }
                            }
                            .onChange(of: selectedPhoto) { oldValue, newItem in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                                       let image = UIImage(data: data) {
                                        selectedImage = image
                                    }
                                }
                            }
                        }
                        
                        // Coffee name
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Coffee Name *")
                                .font(.subheadline)
                                .foregroundColor(.coffeeBrown)
                            TextField("e.g., Ethiopia Yirgacheffe", text: $coffeeName)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        // Roaster
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Roaster (Optional)")
                                .font(.subheadline)
                                .foregroundColor(.coffeeBrown)
                            TextField("e.g., Blue Bottle Coffee", text: $roaster)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        // Location
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Where did you taste it?")
                                .font(.subheadline)
                                .foregroundColor(.coffeeBrown)
                            
                            HStack {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(.coffeeAccent)
                                TextField("Café or location name", text: $location)
                                    .textFieldStyle(PlainTextFieldStyle())
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.coffeeCream.opacity(0.5), lineWidth: 1)
                            )
                            
                            Button(action: {
                                // Use current location
                            }) {
                                HStack {
                                    Image(systemName: "mappin.circle.fill")
                                        .font(.caption)
                                    Text("Use current location")
                                        .font(.caption)
                                }
                                .foregroundColor(.coffeeBrown)
                            }
                        }
                        
                        // Preparation method
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Preparation Method *")
                                .font(.subheadline)
                                .foregroundColor(.coffeeBrown)
                            
                            Menu {
                                ForEach(brewingMethods, id: \.self) { method in
                                    Button(method) {
                                        preparationMethod = method
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(preparationMethod.isEmpty ? "Select brewing method" : preparationMethod)
                                        .foregroundColor(preparationMethod.isEmpty ? .gray : .coffeeBrown)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.coffeeAccent)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.coffeeCream.opacity(0.5), lineWidth: 1)
                                )
                            }
                        }
                        
                        // Rating
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Rating *")
                                .font(.subheadline)
                                .foregroundColor(.coffeeBrown)
                            
                            HStack(spacing: 8) {
                                ForEach(1...5, id: \.self) { bean in
                                    Button(action: {
                                        rating = bean
                                    }) {
                                        Image(systemName: bean <= rating ? "leaf.fill" : "leaf")
                                            .font(.system(size: 40))
                                            .foregroundColor(bean <= rating ? .coffeeAccent : Color.coffeeCream.opacity(0.5))
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.coffeeCream, Color.coffeeCream.opacity(0.5)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(16)
                            
                            if rating > 0 {
                                Text(ratingText)
                                    .font(.caption)
                                    .foregroundColor(.coffeeAccent)
                                    .frame(maxWidth: .infinity)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        
                        // Tasting notes
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Tasting Notes")
                                .font(.subheadline)
                                .foregroundColor(.coffeeBrown)
                            
                            Text("Select or add your own")
                                .font(.caption)
                                .foregroundColor(.coffeeAccent)
                            
                            // Suggested notes
                            FlowLayout(spacing: 8) {
                                ForEach(suggestedNotes, id: \.self) { note in
                                    Button(action: {
                                        if selectedTastingNotes.contains(note) {
                                            selectedTastingNotes.remove(note)
                                        } else {
                                            selectedTastingNotes.insert(note)
                                        }
                                    }) {
                                        HStack(spacing: 4) {
                                            if selectedTastingNotes.contains(note) {
                                                Image(systemName: "checkmark")
                                                    .font(.caption2)
                                            }
                                            Text(note)
                                                .font(.caption)
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(selectedTastingNotes.contains(note) ? Color.coffeeBrown : Color.white)
                                        .foregroundColor(selectedTastingNotes.contains(note) ? .coffeeCream : .coffeeAccent)
                                        .cornerRadius(20)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(selectedTastingNotes.contains(note) ? Color.clear : Color.coffeeCream.opacity(0.5), lineWidth: 1)
                                        )
                                    }
                                }
                            }
                            
                            // Custom note input
                            HStack(spacing: 8) {
                                TextField("Add custom tasting note", text: $customNote)
                                    .textFieldStyle(CustomTextFieldStyle())
                                
                                Button(action: {
                                    if !customNote.trimmingCharacters(in: .whitespaces).isEmpty {
                                        selectedTastingNotes.insert(customNote.trimmingCharacters(in: .whitespaces))
                                        customNote = ""
                                    }
                                }) {
                                    Image(systemName: "plus")
                                        .foregroundColor(.coffeeCream)
                                        .padding(8)
                                        .background(Color.coffeeBrown)
                                        .clipShape(Circle())
                                }
                            }
                        }
                        
                        // Caption
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Caption")
                                .font(.subheadline)
                                .foregroundColor(.coffeeBrown)
                            TextEditor(text: $caption)
                                .frame(minHeight: 100)
                                .padding(8)
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.coffeeCream.opacity(0.5), lineWidth: 1)
                                )
                        }
                        
                        // Partnership tag
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "tag.fill")
                                    .foregroundColor(.coffeeBrown)
                                Text("Partnership (Optional)")
                                    .font(.subheadline)
                                    .foregroundColor(.coffeeBrown)
                            }
                            
                            Text("Tag this as a partnership post or add affiliate links")
                                .font(.caption2)
                                .foregroundColor(.coffeeAccent)
                            
                            Button(action: {
                                // Add partnership details
                            }) {
                                Text("Add Partnership Details")
                                    .font(.subheadline)
                                    .foregroundColor(.coffeeBrown)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.coffeeAccent, lineWidth: 1)
                                    )
                            }
                        }
                        .padding()
                        .background(Color.coffeeCream)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.coffeeCream.opacity(0.5), lineWidth: 1)
                        )
                    }
                    .padding()
                }
                .background(Color.coffeeCream)
            }
            .alert("Post Created!", isPresented: $showSuccessAlert) {
                Button("OK") {
                    dismiss()
                }
            }
        }
    }
    
    private var ratingText: String {
        switch rating {
        case 5: return "Exceptional! ⭐️"
        case 4: return "Great coffee! 👍"
        case 3: return "Good! ☕️"
        case 2: return "Okay 👌"
        case 1: return "Not my favorite 😅"
        default: return ""
        }
    }
    
    private func createPost() {
        let post = Post(
            userId: appData.currentUser.id,
            coffeeShopId: nil,
            imageURL: selectedImage != nil ? "photo_\(UUID().uuidString)" : nil,
            coffeeRating: Double(rating),
            shopRating: nil,
            caption: caption
        )
        
        appData.addPost(post)
        showSuccessAlert = true
    }
}

#Preview {
    CreatePostView()
        .environmentObject(AppData())
        .environmentObject(AuthManager())
}
