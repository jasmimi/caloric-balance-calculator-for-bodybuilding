//
//  cbc4bApp.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 20/08/2024.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestoreInternal
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct cbc4bApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    // Create an instance of ModelData as a StateObject
    @StateObject var modelData = ModelData()

    var body: some Scene {
        WindowGroup {
            // Inject the ModelData instance into the environment for use in views
            ContentView()
                .environmentObject(modelData)
        }
    }
}
