//
//  ProfileView.swift
//  LetsCode
//
//  Created by Domenico Montalto on 10/28/23.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    
    @EnvironmentObject var model:ContentModel
    
    var body: some View {
        
        Button {
            
            //Sign out the user
            try! Auth.auth().signOut()
            
            //Change to logged out view
            model.checkLogin()
            
        } label: {
            
            Text("Sign Out")
        }
        
    }
}

#Preview {
    ProfileView()
}
