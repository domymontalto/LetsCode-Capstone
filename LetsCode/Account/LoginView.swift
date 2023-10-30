//
//  LoginView.swift
//  LetsCode
//
//  Created by Domenico Montalto on 10/28/23.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var model:ContentModel
    
    @State var loginMode = Constants.LoginMode.login
    @State var email = ""
    @State var name = ""
    @State var password = ""
    
    var buttonText: String {
        
        if loginMode == Constants.LoginMode.login {
            
            return "Login"
            
        } else {
            
            return "Sign Up"
        }
    }
    
    var body: some View {
        
        VStack(spacing: 10) {
            
            Spacer()
            
            //Logo
            Image(systemName: "book")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 150)
            
            //Title
            Text("LetsCode")
            
            Spacer()
            
            //Picker
            Picker(selection: $loginMode, label: Text("test")) {
                
                Text("Login")
                    .tag(Constants.LoginMode.login)
                
                Text("Sign Up")
                    .tag(Constants.LoginMode.createAccount)
            }
            .pickerStyle(.segmented)
            
            //Form
            TextField("Email", text: $email)
            
            
            if loginMode == Constants.LoginMode.createAccount {
                
                TextField("Name", text: $name)
            }
            
            SecureField("Password", text: $password)
            
            //Button
            Button {
                if loginMode == Constants.LoginMode.login{
                    //Log the user in
                    
                    
                } else {
                    //Create a new account
                    
                    
                }
                
                
            } label: {
                
                ZStack{
                    RectangleCard(color: .blue)
                        .frame(height: 40)
                    
                    Text(buttonText)
                        .foregroundStyle(.white)
                }
                
            }
            
            Spacer()
            
            
            
        }
        .padding(.horizontal, 40)
        .textFieldStyle(.roundedBorder)
        
        
    }
}

#Preview {
    LoginView()
}
