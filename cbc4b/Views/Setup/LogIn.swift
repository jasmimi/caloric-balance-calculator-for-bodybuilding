//
//  LogIn.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 26/09/2024.
//

import SwiftUI

struct LogIn: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var email = ""
    @State private var password = ""
    @State private var isSigningIn = false
    @State private var isSignedIn = false
    
    var body: some View {
        NavigationStack {
            VStack (spacing: 0) {
                ZStack {
                    Color.indigo.ignoresSafeArea()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                    VStack {
                        Text("Caloric Balance Calculator for Bodybuilding")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundColor(.white)
                            .padding().padding()

                        ZStack {
                            Color.white
                                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                .frame(width: 350, height: UIScreen.main.bounds.height/4)
                            
                            VStack {
                                HStack {
                                    Text("Email")
                                    Spacer()
                                    TextField("Email", text: $email)
                                        .autocapitalization(.none)
                                }.padding()
                                
                                HStack {
                                    Text("Password")
                                    Spacer()
                                    SecureField("Password", text: $password)
                                        .autocapitalization(.none)
                                }.padding()
                                
                                HStack {
                                    NavigationLink("Go back", destination: Start())
                                        .buttonStyle(.borderedProminent)
                                        .padding()

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
                                    .padding()
                                    .disabled(isSigningIn)
                                }
                            }.padding().padding()
                        }
                        
                        Spacer().frame(height: 60)
                        
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
