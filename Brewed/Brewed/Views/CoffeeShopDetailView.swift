//
//  CoffeeShopDetailView.swift
//  Brewed
//
//  Created by JD Hadley on 1/13/26.
//

import SwiftUI
import MapKit

struct CoffeeShopDetailView: View {
    let shop: CoffeeShop
    @EnvironmentObject var appData: AppData
    @Environment(\.dismiss) var dismiss
    @State private var position: MapCameraPosition
    
    init(shop: CoffeeShop) {
        self.shop = shop
        _position = State(initialValue: MapCameraPosition.region(
            MKCoordinateRegion(
                center: shop.location,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        ))
    }
    
    var postsForShop: [Post] {
        appData.posts.filter { $0.coffeeShopId == shop.id }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 12) {
                        Text(shop.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.coffeeBrown)
                        
                        HStack(spacing: 16) {
                            HStack(spacing: 4) {
                                Image(systemName: "leaf.fill")
                                    .foregroundColor(.coffeeBrown)
                                Text(String(format: "%.1f", shop.averageRating))
                                    .font(.headline)
                                    .foregroundColor(.coffeeBrown)
                                Text("(\(shop.totalRatings) ratings)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Text(shop.address)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        if !shop.description.isEmpty {
                            Text(shop.description)
                                .font(.body)
                                .foregroundColor(.coffeeBrown)
                                .padding(.top, 4)
                        }
                    }
                    .padding()
                    
                    // Map
                    Map(position: $position) {
                        Annotation(shop.name, coordinate: shop.location) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.coffeeBrown)
                        }
                    }
                    .frame(height: 200)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Posts from this shop
                    if !postsForShop.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recent Posts")
                                .font(.headline)
                                .foregroundColor(.coffeeBrown)
                                .padding(.horizontal)
                            
                            ForEach(postsForShop.prefix(3)) { post in
                                PostCardView(post: post)
                                    .environmentObject(appData)
                            }
                        }
                        .padding(.top)
                    }
                    
                    // Action button
                    NavigationLink(destination: CreatePostView().environmentObject(appData)) {
                        HStack {
                            Spacer()
                            Text("Rate This Shop")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding()
                        .background(Color.coffeeBrown)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .background(Color.coffeeCream)
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
    CoffeeShopDetailView(shop: CoffeeShop(
        name: "Artisan Roasters",
        address: "123 Main St, San Francisco, CA",
        latitude: 37.7749,
        longitude: -122.4194,
        averageRating: 4.5,
        totalRatings: 120,
        description: "A cozy spot with excellent espresso"
    ))
    .environmentObject(AppData())
}
