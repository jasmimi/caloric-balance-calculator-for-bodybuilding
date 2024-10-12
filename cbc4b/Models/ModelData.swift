//
//  ModelData.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 22/08/2024.
//
import Foundation
import Combine
import Firebase
import SwiftUI

class ModelData: ObservableObject {
    // Use @Published to allow SwiftUI to observe changes to this property
    @Published var profile = Profile.default
    @Published var meal = Meal.default
    
    func loadProfile(uid: String){
        let db = Firestore.firestore()
        let userDocRef = db.collection("users").document(uid)
        
        userDocRef.getDocument { document, error in
            if let error = error {
                print("Error fetching profile: \(error)")
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                
                // Update the profile with Firestore data
                self.profile = Profile(
                    email: data?["email"] as? String ?? "",
                    password: "",  // You might not store the password in Firestore for security
                    firstName: data?["firstName"] as? String ?? "",
                    lastName: data?["lastName"] as? String ?? "",
                    prefersNotifications: data?["prefersNotifications"] as? Bool ?? true,
                    age: data?["age"] as? Double ?? 0,
                    height: Profile.Height(rawValue: data?["height"] as? String ?? "") ?? .unspecified,
                    weight: data?["weight"] as? Double ?? 0,
                    sex: Profile.Sex(rawValue: data?["sex"] as? String ?? "") ?? .unspecified,
                    fitnessActivityLevel: Profile.FitnessActivityLevel(rawValue: data?["fitnessActivityLevel"] as? String ?? "") ?? .unspecified,
                    goal: Profile.Goal(rawValue: data?["goal"] as? String ?? "") ?? .unspecified,
                    goalCalories: data?["goalCalories"] as? Double ?? 0
                )
            } else {
                print("Profile document does not exist")
            }
        }
    }
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
