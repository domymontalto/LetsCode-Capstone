//
//  LoginView.swift
//  LetsCode
//
//  Created by Domenico Montalto on 10/28/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct LoginView: View {
    
    @EnvironmentObject var model:ContentModel
    
    @State var loginMode = Constants.LoginMode.login
    @State var email = ""
    @State var name = ""
    @State var password = ""
    @State var errorMessage: String?
    @State var showForgotPassword = false
    
    @State var isEmailValid = true
    let emailPattern = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
    
    @State var isPasswordValid = true
    let passwordParrern = #"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$@$#!%*?&])[A-Za-z\d$@$#!%*?&]{8,}"#
    
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
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 150)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
            //Title
            Text("LetsCode")
                .font(.title2)
                .fontWeight(.bold)
            
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
            Group {
                
                TextField("Email", text: $email)
                
                
                if loginMode == Constants.LoginMode.createAccount {
                    
                    TextField("Name", text: $name)
                }
                
                SecureField("Password", text: $password)
                
                if errorMessage != nil {
                    
                    Text(errorMessage!)
                }
                
                if loginMode == Constants.LoginMode.login {
                    
                    HStack{
                        
                        Spacer()
                        
                        Button {
                            
                            //Put the logic to open the ForgotPasswordView
                            showForgotPassword = true
                            
                        } label: {
                            Text("Forgot Password?")
                                .fontWeight(.bold)
                        }
                    }
                    .padding(7)
                }

            }
            
            //Button
            Button {
                if loginMode == Constants.LoginMode.login{
                    //Log the user in
                    Auth.auth().signIn(withEmail: email, password: password) { result, error in
                        
                            //Check for errors
                        guard error == nil else {
                            
                            self.errorMessage = error!.localizedDescription
                            return
                        }
                        
                        //Clear errom message
                        self.errorMessage = nil
                        
                        //Fetch the user meta data
                        self.model.getUserData()
                        
                        //Change the view to logged in view
                        self.model.checkLogin()
                        
                    }
                } else {
                    
                    //Check if email and password are valid before creating account
                    isEmailValid = model.isEmailOrPasswordValid(emailOrPasswor: email, pattern: emailPattern)
                    
                    isPasswordValid = model.isEmailOrPasswordValid(emailOrPasswor: password, pattern: passwordParrern)
                    
                    if isEmailValid && isPasswordValid {
                    //Create a new account
                        Auth.auth().createUser(withEmail: email, password: password) { result, error in
                            
                            guard error == nil else {
                                
                                self.errorMessage = error!.localizedDescription
                                return
                            }
                            
                            //Clear errom message
                            self.errorMessage = nil
                            
                            //Save the first name
                            let firebaseUser = Auth.auth().currentUser
                            let db = Firestore.firestore()
                            let ref = db.collection("users").document(firebaseUser!.uid)
                            
                            email = email.lowercased()
                            
                            //Create empty erray of awards
                            let awards = [Award]()
                            
                            ref.setData(["name": name, "email":email, "awards":awards], merge: true)
                            
                            //Update the user meta data
                            let user = UserService.shared.user
                            user.name = name
                            user.email = email
                            user.awards = awards
                            
                            //Change the view to logged in view
                            self.model.checkLogin()
                        }
                    
                    } else if !isEmailValid {
                        
                        errorMessage = "Please insert valid email format."
                        email = ""
                        
                    } else if !isPasswordValid {
                        
                        errorMessage = "Password must be 8 characters long and include lowercase, uppercase, digit, and special character."
                        password = ""
                    }
                        
                    
                }
                
                
            } label: {
                
                ZStack{
                    RectangleCard(color: .blue)
                        .frame(height: 40)
                    
                    Text(buttonText)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }
                
            }
            .padding()
            
            
        }
        .padding(.horizontal, 40)
        .textFieldStyle(.roundedBorder)
        .sheet(isPresented: $showForgotPassword) {
            
            ForgotPasswordView(showForgotPassword: $showForgotPassword)
        }
        
        
    }
}

#Preview {
    LoginView()
}
