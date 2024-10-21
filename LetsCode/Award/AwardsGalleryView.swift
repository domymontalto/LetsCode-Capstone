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
            
            VStack {
                
                Text("Awards")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                    .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 50)
            .background(Color(red: 40/255.0, green: 143/255.0, blue: 181/255.0))
            
            //Tell user what to do to earn Awards if they don't have any
            if model.userHasAwards == false {
                
                Spacer()
                
                Text("To start earning Awards, learn and complete the test for a language with at least 80%!")
                    .multilineTextAlignment(.center)
                    .padding(20)
                    .font(.title)
                    .fontWeight(.semibold)
                    .lineSpacing(15)
                
                Spacer()
                
                
            } else {
                
                //Show all the earned Awards
                VStack(alignment: .leading) {
                    
                    Text("Awards Earned")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    AwardsGallerySubview(awardsToDisplay: $earnedAwards, clickable: .constant(true))
                }
                .padding(.top)
                .padding(.leading)
                
                //Show all the unearned Awards
                VStack(alignment: .leading) {
                    
                    Text("Awards Not Earned")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    AwardsGallerySubview(awardsToDisplay: $unearnedAwards, clickable: .constant(false))
                }
                .padding(.top)
                .padding(.leading)
                 
            }
            
        }
        .frame(maxWidth: .infinity)
        .onAppear(perform: {
            self.populateAwards()
        })
    }
    
    func populateAwards() {
        
        // Reset arrays and flag
        earnedAwards = []
        unearnedAwards = []
        model.userHasAwards = false

        for modelAward in model.awards {
            // Check if the user has earned this award
            if user.awards.contains(where: { $0.name == modelAward.name }) {
                earnedAwards.append(modelAward.earnedImage)
                model.userHasAwards = true
            } else {
                unearnedAwards.append(modelAward.unearnedImage)
            }
        }
    }
    
}

#Preview {
    AwardsGalleryView()
}
