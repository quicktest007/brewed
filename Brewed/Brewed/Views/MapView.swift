//
//  MapView.swift
//  Brewed
//
//  Created by JD Hadley on 1/13/26.
//

import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var appData: AppData
    @StateObject private var locationManager = LocationManager()
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    @State private var selectedShop: CoffeeShop?
    @State private var showShopDetail = false
    @State private var searchRadius: Double = 5.0 // kilometers
    
    // Filter coffee shops by proximity to user location
    var nearbyShops: [CoffeeShop] {
        guard let userLocation = locationManager.location else {
            return appData.coffeeShops
        }
        
        return appData.coffeeShops.filter { shop in
            let shopLocation = CLLocation(latitude: shop.latitude, longitude: shop.longitude)
            let distance = userLocation.distance(from: shopLocation) / 1000.0 // Convert to kilometers
            return distance <= searchRadius
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Map(position: $position) {
                    // User location
                    if let userLocation = locationManager.location {
                        Annotation("You", coordinate: userLocation.coordinate) {
                            ZStack {
                                Circle()
                                    .fill(Color.blue.opacity(0.3))
                                    .frame(width: 30, height: 30)
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 20, height: 20)
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 12, height: 12)
                            }
                        }
                    }
                    
                    // Coffee shops
                    ForEach(nearbyShops) { shop in
                        Annotation(shop.name, coordinate: shop.location) {
                            Button(action: {
                                selectedShop = shop
                                showShopDetail = true
                            }) {
                                VStack(spacing: 4) {
                                    Image(systemName: "mappin.circle.fill")
                                        .font(.system(size: 30))
                                        .foregroundColor(.coffeeBrown)
                                    
                                    Text(shop.name)
                                        .font(.caption2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.coffeeBrown)
                                        .padding(4)
                                        .background(Color.white)
                                        .cornerRadius(4)
                                        .shadow(radius: 2)
                                }
                            }
                        }
                    }
                }
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                }
                .onAppear {
                    locationManager.startUpdatingLocation()
                }
                .onChange(of: locationManager.location) { oldValue, newLocation in
                    if let newLocation = newLocation, oldValue == nil {
                        // Only update position when we first get a location
                        position = MapCameraPosition.region(
                            MKCoordinateRegion(
                                center: newLocation.coordinate,
                                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                            )
                        )
                    }
                }
                .ignoresSafeArea()
                
                // Stats overlay
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack(alignment: .trailing, spacing: 8) {
                            if locationManager.authorizationStatus == .denied || locationManager.authorizationStatus == .restricted {
                                Text("Location access needed")
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .padding(8)
                                    .background(Color.white.opacity(0.9))
                                    .cornerRadius(8)
                            } else {
                                Text("\(nearbyShops.count) nearby")
                                    .font(.headline)
                                    .foregroundColor(.coffeeBrown)
                                Text("Coffee Shops")
                                    .font(.subheadline)
                                    .foregroundColor(.coffeeBrown)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(12)
                        .shadow(radius: 5)
                        .padding()
                    }
                }
            }
            .navigationTitle("Discover")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if let userLocation = locationManager.location {
                            position = MapCameraPosition.region(
                                MKCoordinateRegion(
                                    center: userLocation.coordinate,
                                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                )
                            )
                        }
                    }) {
                        Image(systemName: "location.fill")
                            .foregroundColor(.coffeeBrown)
                    }
                }
            }
            .sheet(isPresented: $showShopDetail) {
                if let shop = selectedShop {
                    CoffeeShopDetailView(shop: shop)
                        .environmentObject(appData)
                }
            }
        }
    }
}

#Preview {
    MapView()
        .environmentObject(AppData())
}
