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
    @State private var animatedCaloricIntake: Double = 0.0

    @State private var weeklyCaloricExpenditure: [Double?] = [nil]
    @State private var weeklyCaloricIntake: [Double?] = [nil]
    
    var profile: Profile
    var healthKitStore: HealthKitStore

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0){
                    Color.indigo
                        .frame(width: .infinity, height: UIScreen.main.bounds.height/2)
                        .ignoresSafeArea()
                    Color.white
                        .frame(width: .infinity, height: UIScreen.main.bounds.height/2)
                }
                
                VStack(spacing: 20) {
                    Spacer()
                    
                    Text("\(modelData.profile.firstName)'s \(genTitle(goal: modelData.profile.goal.rawValue))")
                        .bold()
                        .font(.title)
                        .foregroundStyle(.white)
                    

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
                            .stroke(Color.indigo, lineWidth: 2)
                    )
                    
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
                            .stroke(Color.indigo, lineWidth: 2)
                    )
                    Spacer()
                }
                .padding()
                .frame(maxHeight: .infinity)
            }
            .toolbar(.hidden)
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
                self.dailyCaloricExpenditure = calories
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
                    self.weeklyCaloricIntake = []
                }
            }
        }
        healthKitStore.fetchCaloricExpenditureForWeek { calories in
            DispatchQueue.main.async {
                if let unwrappedCalories = calories {
                    self.weeklyCaloricExpenditure = unwrappedCalories
                } else {
                    self.weeklyCaloricExpenditure = []
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

            ProgressView(value: animatedCaloricIntake, total: dailyCalorieGoal ?? 1.0) // Ensure the total is non-zero
                .animation(.easeIn(duration: 2), value: animatedCaloricIntake)
                .task() {
                    animatedCaloricIntake = dailyCaloricIntake ?? 0.0
                }
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
    DashboardHome(profile: Profile.default, healthKitStore: HealthKitStore.shared)
        .environmentObject(ModelData())
}
