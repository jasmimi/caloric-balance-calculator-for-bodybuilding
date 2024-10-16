//
//  DashboardHome.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 22/08/2024.
//

import SwiftUI
import Foundation
import HealthKit
import Charts

struct DashboardHome: View {
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var authManager: AuthManager
    @State private var showingProfile = false
    
    @State private var dailyCaloricExpenditure: Double? = nil
    @State private var dailyCaloricIntake: Double? = nil
    @State private var dailyCalorieGoal: Double? = nil
    
    @State private var weeklyCaloricExpenditure: [Double?] = [nil]
    @State private var weeklyCaloricIntake: [Double?] = [nil]
    
    var profile: Profile
    var healthKitStore: HealthKitStore

    var body: some View {
        NavigationStack {
            ZStack {
                
                // The ScrollView and its content should be on top of the indigo color
                ScrollView {
                    VStack(spacing: 20) {
                        Spacer()

                        // Daily Calorie Goal Progress Box
                        VStack {
                            Text("Daily Calorie Goal Progress")
                                .font(.headline)
                                .foregroundColor(.black)
                            dailyProgressView
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.indigo, lineWidth: 2) // Border color and width
                        ) // This adds a blue border around the VStack
                        
                        // Weekly Progress Box
                        VStack {
                            Text("Weekly Progress")
                                .font(.headline)
                                .foregroundColor(.black)
                            weeklyLineChart
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.indigo, lineWidth: 2) // Border color and width
                        ) // This adds a blue border around the VStack
                        Spacer()
                    }
                    .padding()
                    .frame(maxHeight: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationTitle("\(modelData.profile.firstName)'s \(genTitle(goal: modelData.profile.goal.rawValue))")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingProfile.toggle()
                    } label: {
                        Label("User Profile", systemImage: "person.crop.circle")
                            .foregroundColor(.white)
                    }
                }
            }
            .sheet(isPresented: $showingProfile) {
                ProfileHost()
                    .environmentObject(modelData)
            }
            .onAppear {
                if let uid = authManager.currentUserUID {
                    modelData.loadProfile(uid: uid)
                }
                fetchCaloricData()
            }
        }
    }

    
    func fetchCaloricData() {
        healthKitStore.fetchCaloricExpenditureForToday { calories in
            DispatchQueue.main.async {
                self.dailyCaloricExpenditure = calories // Update state variable
            }
        }
        healthKitStore.fetchCaloricIntakeForToday { calories in
            DispatchQueue.main.async {
                self.dailyCaloricIntake = calories
            }
        }
        healthKitStore.fetchCaloricIntakeForWeek { calories in
            DispatchQueue.main.async {
                if let unwrappedCalories = calories {
                    self.weeklyCaloricIntake = unwrappedCalories
                } else {
                    self.weeklyCaloricIntake = []  // Handle the case where there's no data
                }
            }
        }
        healthKitStore.fetchCaloricExpenditureForWeek { calories in
            DispatchQueue.main.async {
                if let unwrappedCalories = calories {
                    self.weeklyCaloricExpenditure = unwrappedCalories
                } else {
                    self.weeklyCaloricExpenditure = []  // Handle the case where there's no data
                }
            }
        }
        self.dailyCalorieGoal = profile.goalCalories
    }

        
    func genTitle(goal: String) -> String {
        var x = modelData.profile.goal.rawValue
        if (x == "Maintain"){
            x = "maintenance"
        }
        return x.lowercased()
    }
    
    var dailyProgressView: some View {
        VStack {
            Text("Consumed Today: \(String(format: "%.0f", dailyCaloricIntake ?? 0.0)) kcal")
            Text("Goal: \(String(format: "%.0f", dailyCalorieGoal ?? 0.0)) kcal")

            ProgressView(value: dailyCaloricIntake, total: dailyCalorieGoal ?? 0.0)
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                .frame(height: 20)
                .padding()

            let balance = (dailyCalorieGoal ?? 0.0) - (dailyCaloricIntake ?? 0.0);
            if balance > 0 {
                Text("You're \(Int(balance)) kcal away from your goal!")
                    .foregroundColor(.blue)
            } else if balance < 0 {
                Text("You're \(Int(balance)) kcal over your goal!")
                    .foregroundColor(.orange)
            } else {
                Text("Goal Achieved!")
                    .foregroundColor(.green)
            }
        }
    }
    
    var weeklyLineChart: some View {
        VStack {
            Chart {
                // Line for calories consumed
                ForEach(0..<weeklyCaloricIntake.count, id: \.self) { index in
                    LineMark(
                        x: .value("Day", index + 1),
                        y: .value("Calories Consumed", weeklyCaloricIntake[index] ?? 0.0)
                    )
                    .foregroundStyle(by: .value("Type", "Calories Consumed")) // Group by "Calories Consumed"
                }
                
                // Line for calories burned
                ForEach(0..<weeklyCaloricExpenditure.count, id: \.self) { index in
                    LineMark(
                        x: .value("Day", index + 1),
                        y: .value("Calories Burned", weeklyCaloricExpenditure[index] ?? 0.0)
                    )
                    .foregroundStyle(by: .value("Type", "Calories Burned")) // Group by "Calories Burned"
                }
                
                // Goal line (static value across all days)
                RuleMark(y: .value("Goal", dailyCalorieGoal ?? 0.0))
                    .foregroundStyle(.red)
                    .lineStyle(StrokeStyle(lineWidth: 2, dash: [5, 5]))
                    .annotation(position: .top, alignment: .leading) {
                        Text("Goal: \(Int(dailyCalorieGoal ?? 0.0)) kcal")
                            .foregroundColor(.red)
                            .font(.caption)
                    }
            }
            .chartLegend(position: .bottom)
            .frame(height: 200)
            .padding()
        }
    }
}

#Preview {
    DashboardHome(profile: Profile.default, healthKitStore: HealthKitStore.init())
        .environmentObject(ModelData())
}
