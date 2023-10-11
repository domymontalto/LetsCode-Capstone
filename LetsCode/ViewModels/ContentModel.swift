//
//  ContentModel.swift
//  LetsCode
//
//  Created by Domenico Montalto on 10/4/23.
//

import Foundation

class ContentModel : ObservableObject {
    
    //List of Module
    @Published var modules = [Module]()
    
    //Current Module
    @Published var currentModule: Module?
    @Published var currentModuleIndex = 0
    
    //Current Lesson
    @Published var currentLesson: Lesson?
    @Published var currentLessonIndex = 0
    
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
    
    //MARK: - Module navigation methods
    
    func beginModule(_ moduleid: Int) {
        
        //Find the index for this module id
        for index in 0..<modules.count {
            
            if modules[index].id == index {
                
                //Found the matching module
                currentModuleIndex = index
                break
            }
            
        }
        
        //Set the current module
        currentModule = modules[currentModuleIndex]
        
    }
    
    func beginLesson(_ lessonIndex: Int) {
        
        //Check that the lesson index is within range of module lessons
        if lessonIndex < currentModule!.content.lessons.count {
            
            currentLessonIndex = lessonIndex
            
        } else {
            currentLessonIndex = 0
        }
        
        //Set the current lesson
        currentLesson = currentModule!.content.lessons[currentLessonIndex]
        
    }
    
    func nextLesson() {
        
        //Advance the lesson index
        currentLessonIndex += 1
        
        //Check tha it is within range
        if currentLessonIndex < currentModule!.content.lessons.count{
            
            //Set the current lesson property
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            
        } else {
            
            //Reset the lesson state
            currentLessonIndex = 0
            currentLesson = nil
            
        }
        
    }
    
    func hasNextLesson() -> Bool {
        
        if currentLessonIndex + 1 < currentModule!.content.lessons.count {
            
            return true
            
        } else {
            
            return false
        }
        
    }
    
    
    
    
}
