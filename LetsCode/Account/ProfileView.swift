//
//  ProfileView.swift
//  LetsCode
//
//  Created by Domenico Montalto on 10/28/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct ProfileView: View {
    
    @EnvironmentObject var model: ContentModel
    
    @State var username = ""
    @State var newUsername = ""
    
    @State var email = ""
    @State var newEmail = ""
    @State var isEmailValid = true
    let emailPattern = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
    
    @State var currentPassword = ""
    @State var newPassword = ""
    @State var isPasswordValid = true
    let passwordParrern = #"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$@$#!%*?&])[A-Za-z\d$@$#!%*?&]{8,}"#
    
    @State var errorMessage: String?
    
    let firebaseUser = Auth.auth().currentUser
    let db = Firestore.firestore()
    let user = UserService.shared.user
    
    var body: some View {
        
        //Get username and email from Firestore database
        if Auth.auth().currentUser != nil {
            
            let ref = db.collection("users").document(firebaseUser!.uid).getDocument { snapshot, error in
                
                //Check there's no errors
                guard error == nil, snapshot != nil else {
                    return
                }
                
                let data = snapshot!.data()
                username = data?["name"] as? String ?? ""
                email = data?["email"] as? String ?? ""
            }
            
            GeometryReader { geometry in
                                    
                VStack(spacing: 10) {
                                              
                        VStack {
                            
                            Text("Hi, " + user.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding(.top, 40)
                                .padding(.bottom, 50)
                                .padding(.leading, 15)
                                
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(red: 40/255.0, green: 143/255.0, blue: 181/255.0))
                        .padding(.top, geometry.safeAreaInsets.top)
                        
                        Spacer()
                        
                        ScrollView {
                        
                        VStack(alignment: .leading) {
                            
                            Text("User Name:")
                            TextField(username, text: $newUsername)
                                .textFieldStyle(.roundedBorder)
                            
                            Text("Email:")
                            TextField(email, text: $newEmail)
                                .textFieldStyle(.roundedBorder)
                            
                            Text("Current Password:")
                            SecureField("",text: $currentPassword)
                                .textFieldStyle(.roundedBorder)
                            
                            Text("New Password:")
                            SecureField("",text: $newPassword)
                                .textFieldStyle(.roundedBorder)
                            
                            if errorMessage != nil {
                                Text(errorMessage!)
                                    .padding(10)
                            }
                            
                        }
                        
                        
                        
                        Spacer()
                        
                        
                        
                        Button {
                            //Removing whitespaces from newUsername, newEmail, currentPassword, and newPassword
                            let trimmedNewUsername = newUsername.trimmingCharacters(in: .whitespacesAndNewlines)
                            var trimmedNewEmail = newEmail.trimmingCharacters(in: .whitespacesAndNewlines)
                            let trimmedCurrentPassword = currentPassword.trimmingCharacters(in: .whitespacesAndNewlines)
                            let trimmedNewPassword = newPassword.trimmingCharacters(in: .whitespacesAndNewlines)
                            
                            //Checking if user is modifying at least one field
                            if trimmedNewUsername.isEmpty && trimmedNewEmail.isEmpty && trimmedCurrentPassword.isEmpty && trimmedNewPassword.isEmpty {
                                
                                errorMessage = "Please change info."
                            }
                            
                            //Checking if a user is inserting a new username before modifying the existing one
                            if !trimmedNewUsername.isEmpty && trimmedNewUsername != username {
                                
                                //Changing name both locally and on Firestore database
                                user.name = trimmedNewUsername
                                let ref = db.collection("users").document(firebaseUser!.uid)
                                ref.setData(["name": user.name], merge: true)
                                
                                newUsername = ""
                                
                                // Clear error message
                                self.errorMessage = nil
                            }
                            
                            
                            //Check if email is in form of at least a@a.it
                            isEmailValid = model.isEmailOrPasswordValid(emailOrPasswor: trimmedNewEmail, pattern: emailPattern)
                            
                            if isEmailValid {
                                
                                //Checking if a user is inserting a new email before modifying the existing one
                                if !trimmedNewEmail.isEmpty && trimmedNewEmail != email {
                                    
                                    trimmedNewEmail = trimmedNewEmail.lowercased()
                                    
                                    //Changing email in FirebaseAuth
                                    firebaseUser!.updateEmail(to: trimmedNewEmail) { error in
                                        
                                        if let error = error {
                                            
                                            print(error.localizedDescription)
                                            
                                            errorMessage = "You need to Log in again with your current email before changing your email."
                                            newEmail = ""
                                            
                                        } else {
                                            
                                            //Changing email both locally and on Firestore database
                                            user.email = trimmedNewEmail
                                            let ref = db.collection("users").document(firebaseUser!.uid)
                                            ref.setData(["email": user.email], merge: true)
                                            
                                            newEmail = ""
                                            
                                            // Clear error message
                                            self.errorMessage = nil
                                        }
                                        
                                    }
                                    
                                    
                                }
                            } else if !trimmedNewEmail.isEmpty  {
                                errorMessage = "Please insert valid email"
                                newEmail = ""
                            }
                            
                            //Checking if a user is inserting both currentPassword and newPassword
                            if !trimmedCurrentPassword.isEmpty && !trimmedNewPassword.isEmpty {
                                
                                // Clear error message
                                self.errorMessage = nil
                                
                                //Check if password is secured
                                isPasswordValid = model.isEmailOrPasswordValid(emailOrPasswor: trimmedNewPassword, pattern: passwordParrern)
                                
                                if isPasswordValid {
                                    
                                    changePassword(email: email, currentPassword: trimmedCurrentPassword, newPassword: trimmedNewPassword) { error in
                                        
                                        if error != nil {
                                            errorMessage = "Error " + (error?.localizedDescription ?? "").lowercased()
                                            
                                        }
                                        else {
                                            
                                            errorMessage = "Password change successfully."
                                            currentPassword = ""
                                            newPassword = ""
                                        }
                                    }
                                    
                                } else {
                                    
                                    errorMessage = "New password must be 8 characters long and include lowercase, uppercase, digit, and special character."
                                    currentPassword = ""
                                    newPassword = ""
                                }
                                
                            } else if !trimmedNewPassword.isEmpty && trimmedCurrentPassword.isEmpty {
                                
                                errorMessage = "Please insert Current Password"
                                
                            } else if !trimmedCurrentPassword.isEmpty && trimmedNewEmail.isEmpty {
                                
                                errorMessage = "Please insert New Password"
                                
                            }
                            
                            
                        } label: {
                            ZStack {
                                RectangleCard(color: .blue)
                                    .frame(height: 40)
                                
                                Text("Change Info")
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color(.white))
                            }
                            .padding(.top, 20)
                            .padding(.horizontal, 10)
                        }
                        
                        
                        //Sign out the user
                        Button {
                            
                            //Save data to database before sign out
                            model.saveData(writeToDatabase: true)
                            
                            try! Auth.auth().signOut()
                            
                            //Change to logged out view
                            model.checkLogin()
                            
                        } label: {
                            
                            ZStack {
                                
                                RectangleCard(color: .white)
                                    .frame(height: 40)
                                
                                Text("Sign Out")
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color(.red))
                            }
                        }
                        .padding(.horizontal, 10)
                        
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 20)
                    
                }
                    
                .scrollIndicators(.hidden)
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.inline)
                .edgesIgnoringSafeArea(.top)
            }
            
            
        }
        
    }
    
    func changePassword(email: String, currentPassword: String, newPassword: String, completion: @escaping (Error?) -> Void) {
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        firebaseUser?.reauthenticate(with: credential, completion: { (result, error) in
            if let error = error {
                completion(error)
            }
            else {
                firebaseUser?.updatePassword(to: newPassword, completion: { (error) in
                    completion(error)
                })
            }
        })
    }
    
}

#Preview {
    ProfileView()
}
