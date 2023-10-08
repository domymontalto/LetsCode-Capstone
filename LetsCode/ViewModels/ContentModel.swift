//
//  ContentModel.swift
//  LetsCode
//
//  Created by Domenico Montalto on 10/4/23.
//

import Foundation

class ContentModel : ObservableObject {
    
    @Published var modules = [Module]()
    
    @Published var currentModule: Module?
    @Published var currentModuleIndex = 0
    
    init() {
        
        getLocalData()
    }
    
    //MARK: - Data Methods
    
    func getLocalData() {
        
        //Get url to the json file
        let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")
        
        do {
            
            //Read the file into a data object
            let jsonData = try Data(contentsOf: jsonUrl!)
            
            //Decode the json into an array of modules
            let jsonDecoder = JSONDecoder()
            
            let modules = try jsonDecoder.decode([Module].self, from: jsonData)
            
            //Assign parsed modules to modules property
            self.modules = modules
        }
        catch {
            
            print("Error: " + error.localizedDescription)
        }
        
    }
    
    //MARK: - Lesson navigation methods
    
    func beginModule(_ moduleid: Int) {
        
        for index in 0..<modules.count {
            
            if modules[index].id == index {
                
                currentModuleIndex = index
                break
            }
            
        }
        
        currentModule = modules[currentModuleIndex]
        
    }
    
    
    
    
}
