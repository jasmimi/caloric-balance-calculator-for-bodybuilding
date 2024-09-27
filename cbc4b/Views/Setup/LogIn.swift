//
//  LogIn.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 26/09/2024.
//

import SwiftUI

struct LogIn: View {
    @State private var blankProfile = Profile.blank

    var body: some View {
        NavigationStack {
            VStack (spacing: 0) {
                ZStack {
                    Color.indigo.ignoresSafeArea()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                    VStack {
                        Text("Caloric Balance Calculator for Bodybuilding").font(.largeTitle).fontWeight(/*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/).foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/).padding().padding()
                        ZStack {
                            Color.white
                                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                .frame(width: 350, height: UIScreen.main.bounds.height/4)
                            VStack {
                                HStack {
                                    Text("Email")
                                    Spacer()
                                    TextField("Email", text: $blankProfile.email)
                                }.padding()
                                HStack {
                                    Text("Password")
                                    Spacer()
                                    SecureField("Password", text: $blankProfile.password)
                                }.padding()
                                HStack {
                                    NavigationLink ("Go back"){
                                        // sign in logic
                                        Start()
                                    }.buttonStyle(.borderedProminent)
                                        .padding()
                                    NavigationLink ("Sign in"){
                                        // sign in logic
                                        AuthNavTabs()
                                    }.buttonStyle(.borderedProminent)
                                        .padding()
                                }
                            }.padding().padding()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    LogIn()
}
