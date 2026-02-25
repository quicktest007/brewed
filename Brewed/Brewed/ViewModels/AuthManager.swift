//
//  AuthManager.swift
//  Brewed
//
//  Created by JD Hadley on 1/13/26.
//

import Foundation
import Combine

class AuthManager: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var hasAccount: Bool = false
    @Published var isLoading: Bool = true
    
    private let userDefaults = UserDefaults.standard
    private let isAuthenticatedKey = "brewed_isAuthenticated"
    private let hasAccountKey = "brewed_hasAccount"
    
    init() {
        // Check for saved authentication state
        isAuthenticated = userDefaults.bool(forKey: isAuthenticatedKey)
        hasAccount = userDefaults.bool(forKey: hasAccountKey)
        
        // Simulate loading time (3.5 seconds like the React app)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            self.isLoading = false
        }
    }
    
    func authenticate(hasAccount: Bool) {
        self.isAuthenticated = true
        self.hasAccount = hasAccount
        userDefaults.set(true, forKey: isAuthenticatedKey)
        userDefaults.set(hasAccount, forKey: hasAccountKey)
    }
    
    func signOut() {
        self.isAuthenticated = false
        self.hasAccount = false
        userDefaults.set(false, forKey: isAuthenticatedKey)
        userDefaults.set(false, forKey: hasAccountKey)
    }
}
