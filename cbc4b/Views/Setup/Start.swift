//
//  Start.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 14/09/2024.
//

import SwiftUI

struct Start: View {
    var body: some View {
        NavigationStack {
            VStack (spacing: 0) {
                ZStack {
                    Color.indigo.ignoresSafeArea()
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .frame(height: UIScreen.main.bounds.height/2)
                    VStack {
                        Spacer()
                        Text("Caloric Balance Calculator for Bodybuilding").font(.largeTitle).fontWeight(/*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/).foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/).padding().padding()
                    }
                }
                ZStack {
                    Color.white.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/).frame(height: UIScreen.main.bounds.height/2)
                    VStack {
                        NavigationLink ("Start Journey"){
                            SignUp()
                        }.buttonStyle(.bordered)
                            .padding()
                        Image("StartIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 100)
                            .padding()
                        Spacer()
                            .frame(height: 180)
                    }
                }
            }
        }
    }
}

#Preview {
    Start()
}
