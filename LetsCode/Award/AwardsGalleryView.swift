//
//  AwardGalleryView.swift
//  LetsCode
//
//  Created by Domenico Montalto on 11/10/23.
//

import SwiftUI

struct AwardsGalleryView: View {
    
    @EnvironmentObject var model: ContentModel
    
    @State var user = UserService.shared.user
    @State var earnedAwards: [String] = []
    @State var unearnedAwards: [String] = []
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text("Awards")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)
                .padding(.horizontal)
            
            //Tell user what to do to earn Awards if they don't have any
            if model.userHasAwards == false {
                
                Spacer()
                
                Text("To start earning Awards, learn and complete the test for a language with at least 80%!")
                    .multilineTextAlignment(.center)
                    .padding()
                    .font(.title)
                    .fontWeight(.semibold)
                    .lineSpacing(15)

                
                Spacer()
                
                Spacer()
                
                
            } else {
                
                //Show all the earned Awards
                VStack(alignment: .leading) {
                    
                    Text("Awards Earned")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    AwardsGallerySubview(awardsToDisplay: $earnedAwards)
                }
                .padding(.top)
                
                //Show all the unearned Awards
                VStack(alignment: .leading) {
                    
                    Text("Awards Not Earned")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    AwardsGallerySubview(awardsToDisplay: $unearnedAwards)
                    
                }
                .padding(.top)
                 
            }
            
        }
        .onAppear(perform: {
            self.populateAwards()
        })
        .padding(.horizontal)
    }
    
    
    func populateAwards() {
        
        for modelAward in model.awards {
            
            for userAward in user.awards {
                
                //If user has a specific Award add it to earnedAwards array
                if userAward.name == modelAward.name {
                    
                    earnedAwards.append(userAward.earnedImage)
                    model.userHasAwards = true
                    
                } else {
                    
                    //If user does not have a specific Award add it to unearnedAwards array
                    unearnedAwards.append(modelAward.unearnedImage)
                }
            }
        }
    }
    
}

#Preview {
    AwardsGalleryView()
}
