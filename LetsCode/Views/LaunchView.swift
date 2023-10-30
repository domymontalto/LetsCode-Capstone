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
            
            //Show the login view
            LoginView()
                .onAppear {
                    //Check if the user is logged in or out
                    model.checkLogin()
                    
                }
            
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
                
                ProfileView()
                    .tabItem {
                    
                        VStack{
                            Image(systemName: "person")
                            
                            Text("Profile")
                        }
                    }
                
                
            }
            
        }
        
    }
}

#Preview {
    LaunchView()
}