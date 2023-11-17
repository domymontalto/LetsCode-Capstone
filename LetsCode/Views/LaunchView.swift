//
//  LaunchView.swift
//  LetsCode
//
//  Created by Domenico Montalto on 10/28/23.
//

import SwiftUI

struct LaunchView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        if model.loggedIn == false {
            
            ScrollView {
                
                //Show the login view
                LoginView()
                    .onAppear {
                        //Check if the user is logged in or out
                        model.checkLogin()
                        
                    }
                
            }
            .scrollIndicators(.hidden)
            
        } else {
            
            //Show the logged in view
            TabView {
                
                HomeView()
                    .tabItem {
                        
                        VStack {
                            Image(systemName: "book")

                            Text("Learn")
                        }
                    }
                
                AwardsGalleryView()
                    .tabItem {
                        VStack {
                            Image(systemName: "medal")
                            Text("Awards")
                        }
                    }
                
                ProfileView()
                    .tabItem {
                    
                        VStack{
                            Image(systemName: "person")
                            
                            Text("Profile")
                        }
                    }
                    .onAppear {
                        model.isPlaying = false
                    }
                
                
            }
            .onAppear {
                model.getModules()
                model.getAwards()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                
                //Save progress to the database when the app is moving from active to background
                model.saveData(writeToDatabase: true)
            }
            
        }
        
    }
}

#Preview {
    LaunchView()
}
