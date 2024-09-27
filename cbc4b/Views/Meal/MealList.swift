//
//  MealList.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 22/08/2024.
//

import SwiftUI

struct MealList: View {
    @EnvironmentObject var modelData: ModelData 
    @State private var showingProfile = false
    
    var body: some View {
        NavigationStack {
            List {
            }
            .listStyle(.inset)
            .navigationTitle("Meal log")
            .toolbar {
                Button {
                    showingProfile.toggle()
                } label: {
                    Label("User Profile", systemImage: "person.crop.circle")
                }
            }
            .sheet(isPresented: $showingProfile) {
                ProfileHost()
                    .environmentObject(modelData)
            }
        }
    }
}

#Preview {
    MealList().environmentObject(ModelData())
}
