//
//  LetsCodeApp.swift
//  LetsCode
//
//  Created by Domenico Montalto on 10/2/23.
//

import SwiftUI
import Firebase

@main
struct LetsCodeApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(ContentModel())
        }
    }
}
