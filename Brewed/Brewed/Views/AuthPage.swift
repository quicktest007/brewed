//
//  AuthPage.swift
//  Brewed
//
//  Created by JD Hadley on 1/13/26.
//

import SwiftUI

struct AuthPage: View {
    @State private var isLogin = true
    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var password = ""
    @State private var agreedToTerms = false
    @State private var accountType: AccountType = .personal
    
    enum AccountType {
        case personal
        case business
    }
    
    let onAuthSuccess: (Bool) -> Void
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.98, green: 0.98, blue: 0.97), Color.coffeeCream]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Header with logo
                    VStack(spacing: 16) {
                        // Coffee icon
                        ZStack {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.coffeeBrown, Color.coffeeAccent]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 80)
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                            
                            Image(systemName: "cup.and.saucer.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.coffeeCream)
                        }
                        .padding(.top, 64)
                        .padding(.bottom, 8)
                        
                        Text("Welcome to Brewed")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.coffeeBrown)
                        
                        Text("Join the world's largest coffee community")
                            .font(.subheadline)
                            .foregroundColor(.coffeeAccent)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                    
                    // Form
                    VStack(spacing: 20) {
                        if !isLogin {
                            // Full Name
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Full Name")
                                    .font(.subheadline)
                                    .foregroundColor(.coffeeBrown)
                                TextField("John Doe", text: $name)
                                    .textFieldStyle(CustomTextFieldStyle())
                            }
                        }
                        
                        // Email
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.subheadline)
                                .foregroundColor(.coffeeBrown)
                            TextField("your@email.com", text: $email)
                                .textFieldStyle(CustomTextFieldStyle())
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        }
                        
                        if !isLogin {
                            // Phone (Optional)
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Phone Number (Optional)")
                                    .font(.subheadline)
                                    .foregroundColor(.coffeeBrown)
                                TextField("+1 (555) 000-0000", text: $phone)
                                    .textFieldStyle(CustomTextFieldStyle())
                                    .keyboardType(.phonePad)
                            }
                        }
                        
                        // Password
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.subheadline)
                                .foregroundColor(.coffeeBrown)
                            SecureField("••••••••", text: $password)
                                .textFieldStyle(CustomTextFieldStyle())
                            
                            if isLogin {
                                HStack {
                                    Spacer()
                                    Button("Forgot password?") {
                                        // Handle forgot password
                                    }
                                    .font(.caption)
                                    .foregroundColor(.coffeeAccent)
                                }
                            }
                        }
                        
                        if !isLogin {
                            // Terms and conditions
                            VStack(spacing: 12) {
                                HStack(alignment: .top, spacing: 12) {
                                    Toggle("", isOn: $agreedToTerms)
                                        .toggleStyle(CheckboxToggleStyle())
                                        .padding(.top, 4)
                                    
                                    Text("I agree to the **Terms of Service** and **Privacy Policy**")
                                        .font(.caption)
                                        .foregroundColor(.coffeeAccent)
                                }
                                
                                // Disclaimer
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Important:")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.coffeeBrown)
                                    
                                    Text("Brewed is designed for coffee enthusiasts to share experiences. We do not collect sensitive personal information. Your data is protected and will never be sold to third parties.")
                                        .font(.caption2)
                                        .foregroundColor(.coffeeAccent)
                                        .lineSpacing(4)
                                }
                                .padding()
                                .background(Color.coffeeCream)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.coffeeCream.opacity(0.5), lineWidth: 1)
                                )
                            }
                            .padding(.top, 8)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                    
                    // Submit button
                    VStack(spacing: 16) {
                        Button(action: {
                            onAuthSuccess(true)
                        }) {
                            HStack {
                                Text(isLogin ? "Login to Brewed" : "Create Account")
                                    .font(.headline)
                                Spacer()
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 20))
                            }
                            .foregroundColor(.coffeeCream)
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
                        
                        if isLogin {
                            Button(action: {
                                isLogin = false
                            }) {
                                Text("Don't have an account? Sign up")
                                    .font(.subheadline)
                                    .foregroundColor(.coffeeAccent)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                    
                    // Account type selection for signup
                    if !isLogin {
                        VStack(spacing: 12) {
                            Text("Account Type")
                                .font(.subheadline)
                                .foregroundColor(.coffeeAccent)
                            
                            HStack(spacing: 12) {
                                // Personal
                                Button(action: {
                                    accountType = .personal
                                }) {
                                    VStack(spacing: 8) {
                                        Image(systemName: accountType == .personal ? "checkmark.circle.fill" : "circle")
                                            .font(.system(size: 20))
                                            .foregroundColor(accountType == .personal ? .coffeeBrown : .coffeeAccent)
                                        Text("Personal")
                                            .font(.caption)
                                            .foregroundColor(accountType == .personal ? .coffeeBrown : .coffeeAccent)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(accountType == .personal ? Color.coffeeBrown : Color.coffeeCream.opacity(0.5), lineWidth: accountType == .personal ? 2 : 1)
                                    )
                                }
                                
                                // Business
                                Button(action: {
                                    accountType = .business
                                }) {
                                    VStack(spacing: 8) {
                                        Image(systemName: "cup.and.saucer.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(accountType == .business ? .coffeeBrown : .coffeeAccent)
                                        Text("Business")
                                            .font(.caption)
                                            .foregroundColor(accountType == .business ? .coffeeBrown : .coffeeAccent)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(accountType == .business ? Color.coffeeBrown : Color.coffeeCream.opacity(0.5), lineWidth: accountType == .business ? 2 : 1)
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)
                    }
                    
                    // Skip button
                    Button(action: {
                        onAuthSuccess(false)
                    }) {
                        Text("Skip for now")
                            .font(.subheadline)
                            .foregroundColor(.coffeeAccent)
                            .underline()
                    }
                    .padding(.bottom, 24)
                }
            }
        }
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.coffeeCream.opacity(0.5), lineWidth: 1)
            )
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .foregroundColor(configuration.isOn ? .coffeeBrown : .coffeeAccent)
                .font(.system(size: 20))
        }
    }
}

#Preview {
    AuthPage(onAuthSuccess: { _ in })
}
