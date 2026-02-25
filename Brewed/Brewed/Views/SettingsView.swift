//
//  SettingsView.swift
//  Brewed
//
//  Created by JD Hadley on 1/13/26.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authManager: AuthManager
    @AppStorage("brewed-theme") private var isDarkMode: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Appearance")) {
                    HStack {
                        Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                            .foregroundColor(.coffeeBrown)
                            .frame(width: 30)
                        
                        Text("Dark Mode")
                            .foregroundColor(.coffeeBrown)
                        
                        Spacer()
                        
                        Toggle("", isOn: $isDarkMode)
                            .tint(.coffeeBrown)
                    }
                }
                
                Section(header: Text("Account")) {
                    NavigationLink(destination: Text("Edit Profile")) {
                        HStack {
                            Image(systemName: "person.circle")
                                .foregroundColor(.coffeeBrown)
                                .frame(width: 30)
                            Text("Edit Profile")
                                .foregroundColor(.coffeeBrown)
                        }
                    }
                    
                    NavigationLink(destination: Text("Privacy Settings")) {
                        HStack {
                            Image(systemName: "lock.shield")
                                .foregroundColor(.coffeeBrown)
                                .frame(width: 30)
                            Text("Privacy")
                                .foregroundColor(.coffeeBrown)
                        }
                    }
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Image(systemName: "info.circle")
                            .foregroundColor(.coffeeBrown)
                            .frame(width: 30)
                        Text("Version")
                            .foregroundColor(.coffeeBrown)
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                    
                    NavigationLink(destination: Text("Terms of Service")) {
                        HStack {
                            Image(systemName: "doc.text")
                                .foregroundColor(.coffeeBrown)
                                .frame(width: 30)
                            Text("Terms of Service")
                                .foregroundColor(.coffeeBrown)
                        }
                    }
                    
                    NavigationLink(destination: Text("Privacy Policy")) {
                        HStack {
                            Image(systemName: "hand.raised")
                                .foregroundColor(.coffeeBrown)
                                .frame(width: 30)
                            Text("Privacy Policy")
                                .foregroundColor(.coffeeBrown)
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        authManager.signOut()
                        dismiss()
                    }) {
                        HStack {
                            Spacer()
                            Text("Sign Out")
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
            }
            .background(Color.coffeeCream)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.coffeeBrown)
                }
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

#Preview {
    SettingsView()
}
