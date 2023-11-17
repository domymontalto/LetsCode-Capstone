//
//  ForgotPasswordView.swift
//  LetsCode
//
//  Created by Domenico Montalto on 11/14/23.
//

import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
    
    @Binding var showForgotPassword: Bool
    
    @State var email = ""
    @State var errorMessage: String?
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading) {
                
                HStack {
                    
                    Spacer()
                    
                    Button {
                        
                        showForgotPassword = false
                        
                    } label: {
                        
                        Image(systemName: "x.circle")
                            .scaleEffect(2)
                            .foregroundStyle(Color(.black))
                    }
                }
                
                Text("Reset Password")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
                
                TextField("Email", text: $email)
                
                if errorMessage != nil {
                    
                    Text(errorMessage!)
                        .padding(10)
                }
                
                Button {
                    
                    Auth.auth().sendPasswordReset(withEmail: email.lowercased()) { error in
                        
                        if let error = error {
                            
                            print(error.localizedDescription)
                        }
                        
                        errorMessage = "You will receive an email to reset your pasword"
                    }
                    
                } label: {
                    
                    ZStack {
                        
                        RectangleCard(color: .blue)
                            .frame(height: 48)
                        
                        Text("Send Password Reset")
                            .fontWeight(.bold)
                            .foregroundStyle(Color(.white))
                    }
                }
                .padding(.top, 20)
                
                Spacer()
                
            }
            .textFieldStyle(.roundedBorder)
            .padding()
            
        }
        .scrollIndicators(.hidden)
        
    }
}

//#Preview {
//    ForgotPasswordView()
//}
