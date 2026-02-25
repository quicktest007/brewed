//
//  AddBrewView.swift
//  Brewed
//
//  Single-form Add Brew: rating (beans), where (home/shop), coffee type, tasting notes, comments.
//

import SwiftUI
import PhotosUI

struct AddBrewView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var data = MockDataService.shared
    
    @State private var rating: Int = 5
    @State private var brewedAtHome = true
    @State private var selectedPlace: Place?
    @State private var placeSearchText = ""
    @State private var selectedCoffeeType: CoffeeType?
    @State private var tastingNotes: Set<String> = []
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showCamera = false
    @State private var additionalComments = ""
    
    let suggestedNotes = ["Chocolate", "Caramel", "Nutty", "Citrus", "Floral", "Berry", "Smooth", "Bright", "Earthy", "Sweet"]
    
    @Environment(\.colorScheme) private var colorScheme
    private var theme: BrewedTheme { BrewedTheme(isDark: colorScheme == .dark) }
    
    private var canPublish: Bool {
        guard selectedCoffeeType != nil else { return false }
        if brewedAtHome { return true }
        return selectedPlace != nil
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: BrewedSpacing.xxl) {
                    // 1. Rating – 5 beans
                    ratingSection
                    
                    // 2. Where – home or coffee shop
                    whereSection
                    
                    // 3. What coffee
                    coffeeTypeSection
                    
                    // 4. Tasting notes
                    tastingNotesSection
                    
                    // 5. Photo (optional)
                    photoSection
                    
                    // 6. Additional comments
                    commentsSection
                    
                    // Publish
                    BrewedButton("Publish brew", style: .primary) {
                        publishBrew()
                        dismiss()
                    }
                    .disabled(!canPublish)
                    .padding(.top, BrewedSpacing.lg)
                    .padding(.bottom, BrewedSpacing.xxxl)
                }
                .padding(BrewedSpacing.lg)
            }
            .background(theme.background)
            .navigationTitle("Add Brew")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(theme.accent)
                }
            }
            .fullScreenCover(isPresented: $showCamera) {
                CameraImagePicker(selectedImage: $selectedImage)
            }
        }
    }
    
    // MARK: - Rating (5 beans)
    
    private var ratingSection: some View {
        VStack(alignment: .leading, spacing: BrewedSpacing.sm) {
            Text("How was it?")
                .font(BrewedFont.title3())
                .foregroundColor(theme.textPrimary)
            HStack(spacing: BrewedSpacing.sm) {
                ForEach(1...5, id: \.self) { value in
                    Button(action: { rating = value }) {
                        Image(systemName: value <= rating ? "leaf.fill" : "leaf")
                            .font(.system(size: 36))
                            .foregroundColor(value <= rating ? theme.rating : theme.textTertiary.opacity(0.4))
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("\(value) beans")
                    .accessibilityAddTraits(value <= rating ? .isSelected : [])
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    // MARK: - Where (home vs shop)
    
    private var whereSection: some View {
        VStack(alignment: .leading, spacing: BrewedSpacing.md) {
            Text("Where did you brew?")
                .font(BrewedFont.title3())
                .foregroundColor(theme.textPrimary)
            
            HStack(spacing: BrewedSpacing.md) {
                Button(action: {
                    brewedAtHome = true
                    selectedPlace = nil
                }) {
                    Label("At home", systemImage: "house.fill")
                        .font(BrewedFont.subheadline())
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                        .padding(BrewedSpacing.md)
                        .background(brewedAtHome ? theme.accent.opacity(0.2) : theme.surface)
                        .foregroundColor(brewedAtHome ? theme.accent : theme.textSecondary)
                        .clipShape(RoundedRectangle(cornerRadius: BrewedRadius.md))
                }
                .buttonStyle(.plain)
                
                Button(action: { brewedAtHome = false }) {
                    Label("Coffee shop", systemImage: "mappin.circle.fill")
                        .font(BrewedFont.subheadline())
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                        .padding(BrewedSpacing.md)
                        .background(!brewedAtHome ? theme.accent.opacity(0.2) : theme.surface)
                        .foregroundColor(!brewedAtHome ? theme.accent : theme.textSecondary)
                        .clipShape(RoundedRectangle(cornerRadius: BrewedRadius.md))
                }
                .buttonStyle(.plain)
            }
            
            if !brewedAtHome {
                VStack(alignment: .leading, spacing: BrewedSpacing.sm) {
                    HStack(spacing: BrewedSpacing.sm) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(theme.textSecondary)
                        TextField("Search coffee shops", text: $placeSearchText)
                            .font(BrewedFont.body())
                            .foregroundColor(theme.textPrimary)
                        if !placeSearchText.isEmpty {
                            Button(action: { placeSearchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(theme.textSecondary)
                            }
                        }
                    }
                    .padding(BrewedSpacing.sm)
                    .background(theme.surface)
                    .clipShape(RoundedRectangle(cornerRadius: BrewedRadius.md))
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: BrewedSpacing.xs) {
                            ForEach(filteredPlacesForPicker) { place in
                                Button(action: { selectedPlace = place }) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(place.name)
                                                .font(BrewedFont.subheadline())
                                                .foregroundColor(theme.textPrimary)
                                            if let neighborhood = place.neighborhood {
                                                Text(neighborhood)
                                                    .font(BrewedFont.caption())
                                                    .foregroundColor(theme.textSecondary)
                                            }
                                        }
                                        Spacer()
                                        if selectedPlace?.id == place.id {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(theme.accent)
                                        }
                                    }
                                    .padding(BrewedSpacing.sm)
                                    .background(selectedPlace?.id == place.id ? theme.accent.opacity(0.1) : theme.surface)
                                    .clipShape(RoundedRectangle(cornerRadius: BrewedRadius.sm))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .frame(maxHeight: 160)
                }
            }
        }
    }
    
    // MARK: - What coffee (16 options)
    
    private var coffeeTypeSection: some View {
        VStack(alignment: .leading, spacing: BrewedSpacing.md) {
            Text("What did you have?")
                .font(BrewedFont.title3())
                .foregroundColor(theme.textPrimary)
            FlowLayout(spacing: BrewedSpacing.sm) {
                ForEach(CoffeeType.allCases) { type in
                    TagChip(
                        label: type.displayName,
                        selected: selectedCoffeeType == type,
                        onTap: { selectedCoffeeType = type }
                    )
                }
            }
        }
    }
    
    // MARK: - Tasting notes
    
    private var tastingNotesSection: some View {
        VStack(alignment: .leading, spacing: BrewedSpacing.md) {
            Text("Tasting notes")
                .font(BrewedFont.title3())
                .foregroundColor(theme.textPrimary)
            FlowLayout(spacing: BrewedSpacing.sm) {
                ForEach(suggestedNotes, id: \.self) { note in
                    TagChip(
                        label: note,
                        selected: tastingNotes.contains(note),
                        onTap: {
                            if tastingNotes.contains(note) { tastingNotes.remove(note) }
                            else { tastingNotes.insert(note) }
                        }
                    )
                }
            }
        }
    }
    
    // MARK: - Photo (optional)
    
    private var photoSection: some View {
        VStack(alignment: .leading, spacing: BrewedSpacing.md) {
            Text("Photo (optional)")
                .font(BrewedFont.title3())
                .foregroundColor(theme.textPrimary)
            HStack(spacing: BrewedSpacing.md) {
                Button(action: { showCamera = true }) {
                    Label("Take photo", systemImage: "camera.fill")
                        .font(BrewedFont.footnote())
                        .frame(maxWidth: .infinity)
                        .padding(BrewedSpacing.md)
                        .background(theme.surface)
                        .foregroundColor(theme.accent)
                        .clipShape(RoundedRectangle(cornerRadius: BrewedRadius.md))
                }
                .buttonStyle(.plain)
                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    Label("Library", systemImage: "photo.on.rectangle.angled")
                        .font(BrewedFont.footnote())
                        .frame(maxWidth: .infinity)
                        .padding(BrewedSpacing.md)
                        .background(theme.surface)
                        .foregroundColor(theme.accent)
                        .clipShape(RoundedRectangle(cornerRadius: BrewedRadius.md))
                }
                .buttonStyle(.plain)
                .onChange(of: selectedPhoto) { _, newItem in
                    Task {
                        if let d = try? await newItem?.loadTransferable(type: Data.self),
                           let img = UIImage(data: d) {
                            selectedImage = img
                        }
                    }
                }
            }
            if selectedImage != nil {
                Button("Remove photo") {
                    selectedImage = nil
                    selectedPhoto = nil
                }
                .font(BrewedFont.footnote())
                .foregroundColor(theme.textSecondary)
            }
        }
    }
    
    // MARK: - Additional comments
    
    private var commentsSection: some View {
        VStack(alignment: .leading, spacing: BrewedSpacing.sm) {
            Text("Additional comments (optional)")
                .font(BrewedFont.title3())
                .foregroundColor(theme.textPrimary)
            TextField("Notes, vibe, anything else...", text: $additionalComments, axis: .vertical)
                .font(BrewedFont.body())
                .lineLimit(3...6)
                .padding(BrewedSpacing.md)
                .background(theme.surface)
                .clipShape(RoundedRectangle(cornerRadius: BrewedRadius.md))
        }
    }
    
    private var filteredPlacesForPicker: [Place] {
        let query = placeSearchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if query.isEmpty { return data.places }
        return data.places.filter { place in
            place.name.lowercased().contains(query)
            || (place.neighborhood?.lowercased().contains(query) ?? false)
            || place.address.lowercased().contains(query)
            || (place.city?.lowercased().contains(query) ?? false)
        }
    }
    
    private func publishBrew() {
        guard let coffeeType = selectedCoffeeType else { return }
        let placeId: UUID? = brewedAtHome ? nil : selectedPlace?.id
        let brew = Brew(
            userId: data.currentUser.id,
            placeId: placeId,
            imageURL: nil,
            rating: Double(rating),
            tastingNotes: Array(tastingNotes),
            brewMethod: .espresso,
            coffeeType: coffeeType.displayName,
            caption: additionalComments.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        data.addBrew(brew)
        if let placeId = placeId {
            data.addStamp(placeId)
        }
    }
}

// MARK: - Camera image picker

#if canImport(UIKit)
import UIKit

struct CameraImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraImagePicker
        
        init(_ parent: CameraImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
#endif

#Preview("AddBrew") {
    AddBrewView()
}
