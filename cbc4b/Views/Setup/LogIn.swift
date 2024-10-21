//
//  LogIn.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 26/09/2024.
//

// Imports
import SwiftUI

// View structure
struct LogIn: View {
    
    // Initialise variables
    @EnvironmentObject var authManager: AuthManager
    @State private var email = ""
    @State private var password = ""
    @State private var isSigningIn = false
    @State private var isSignedIn = false
    
    // View body
    var body: some View {
        NavigationStack {
            VStack (spacing: 0) {
                ZStack {
                    Color.indigo.ignoresSafeArea()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                    VStack {
                        
                        // Heading
                        Text("Caloric Balance Calculator for Bodybuilding")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundColor(.white)
                            

                        ZStack {
                            Color.white
                                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                .frame(width: 350, height: UIScreen.main.bounds.height/4)
                            
                            VStack {
                                VStack {
                                    
                                    // Login form
                                    HStack {
                                        Text("Email")
                                        Spacer()
                                        TextField("Email", text: $email)
                                            .autocapitalization(.none)
                                    }.padding()
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(.indigo, lineWidth: 2)
                                        )
                                    HStack {
                                        Text("Password")
                                        Spacer()
                                        SecureField("Password", text: $password)
                                            .autocapitalization(.none)
                                    }.padding()
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(.indigo, lineWidth: 2)
                                        )
                                }
                                .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)
                                HStack {
                                    
                                    // Back button
                                    NavigationLink("Go back", destination: Start())
                                        .buttonStyle(.borderedProminent)

                                    // Sign in button
                                    Button(action: {
                                        isSigningIn = true
                                        authManager.signInWithEmail(withEmail: email, password: password, completion: { error in
                                            handleAuthenticationResult(error)
                                        })
                                    }) {
                                        if isSigningIn {
                                            ProgressView()
                                        } else {
                                            Text("Sign In")
                                        }
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .disabled(isSigningIn)
                                }
                                .padding(.top)
                            }
                            .padding().padding()
                        }
                        
                        Spacer().frame(height: 50.0)
                        
                        NavigationLink("", destination: AuthNavTabs(), isActive: $isSignedIn)
                            .hidden()
                    }
                }
            }
        }
    }
    
    private func handleAuthenticationResult(_ error: Error?) {
        if let error = error {
            // Handle sign-in error
            print("Sign-in error: \(error.localizedDescription)")
        } else {
            print("Signed in successfully!")
            isSignedIn = true // Trigger navigation to AuthNavTabs
        }
        isSigningIn = false
    }
}

#Preview {
    LogIn()
}
