//
//  ContentModel.swift
//  LetsCode
//
//  Created by Domenico Montalto on 10/4/23.
//

import Foundation
import Firebase

class ContentModel : ObservableObject {
    
    let db = Firestore.firestore()
    
    //List of Module
    @Published var modules = [Module]()
    
    //Current Module
    @Published var currentModule: Module?
    @Published var currentModuleIndex = 0
    
    //Current Lesson
    @Published var currentLesson: Lesson?
    @Published var currentLessonIndex = 0
    
    //Current Question
    @Published var currentQuestion: Question?
    @Published var currentQuestionIndex = 0
    
    //Current Lesson explanation
    @Published var codeText = NSAttributedString()
    var styleData: Data?
    
    //Current selected content and test
    @Published var currentContentSelected:Int?
    @Published var currentTestSelected:Int?
    
    init() {
        
        
        //Parse local style.html
        getLocalStyles()
        
        //Get database modules
        getDatabaseModules()
    }
    
    //MARK: - Data Methods
    
    func getDatabaseModules() {
        
        //Specify path
        let collection = db.collection("modules")
        
        //Get documents
        collection.getDocuments { snapshot, error in
            
            if error == nil && snapshot != nil {
                
                //Create an array for the modules
                var modules = [Module]()
                
                //Loop through the documents returned
                
                for doc in snapshot!.documents {
                    
                    //Create a new module instance
                    var m = Module()
                    
                    //Parse out the values from the document into the module instance
                    m.id = doc["id"] as? String ?? UUID().uuidString
                    m.category = doc["category"] as? String ?? ""
                    
                    //Parse the lesson content
                    let contentMap = doc["content"] as! [String:Any]
                    
                    m.content.id = contentMap["id"] as? String ?? ""
                    m.content.description = contentMap["description"] as? String ?? ""
                    m.content.image = contentMap["image"] as? String ?? ""
                    m.content.time = contentMap["time"] as? String ?? ""
                    m.content.totLessons = contentMap["totLessons"] as? Int ?? 0
                    
                    //Parse the test content
                    let testMap = doc["test"] as! [String:Any]
                    
                    m.test.id = testMap["id"] as? String ?? ""
                    m.test.description = testMap["description"] as? String ?? ""
                    m.test.image = testMap["image"] as? String ?? ""
                    m.test.time = testMap["time"] as? String ?? ""
                    m.test.totQuestions = testMap["totQuestions"] as? Int ?? 0
                    
                    //Add it to our array
                    modules.append(m)
                    
                    
                }
                
                //Assign our modules to the published property
                DispatchQueue.main.async {
                    
                    self.modules = modules
                    
                }
                
            }
            
            
        }
        
        
    }
    
    
    func getLocalStyles() {
        
        // Parse the style data
        let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")
        
        do {
            
            // Read the file into data object
            let styleData = try Data(contentsOf: styleUrl!)
            
            self.styleData = styleData
            
        }
        catch {
            // Log error
            print("Could't parse style data")
        }
        
    }
    
    //MARK: - Module navigation methods
    
    func beginModule(_ moduleId: String) {
        
        //Find the index for this module id
        for index in 0..<modules.count {
            
            if modules[index].id == moduleId {
                
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
        
        codeText = addStyling(currentLesson!.explanation)
    }
    
    func nextLesson() {
        
        //Advance the lesson index
        currentLessonIndex += 1
        
        //Check tha it is within range
        if currentLessonIndex < currentModule!.content.totLessons{
            
            //Set the current lesson property
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            
            //Adds the lesson description
            codeText = addStyling(currentLesson!.explanation)
            
        } else {
            
            //Reset the lesson state
            currentLessonIndex = 0
            currentLesson = nil
            
        }
        
    }
    
    func nextQuestion() {
        
        //Advance the question index
        currentQuestionIndex += 1
        
        //Check that it's within the range
        if currentQuestionIndex < currentModule!.test.totQuestions {
            
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)

        } else {
            
            //If not, then reset the properties
            currentQuestionIndex = 0
            currentQuestion = nil
            
        }
        
    }
    
    func hasNextLesson() -> Bool {
        
        guard currentModule != nil else {
            return false
        }
        
        if currentLessonIndex + 1 < currentModule!.content.lessons.count {
            
            return true
            
        } else {
            
            return false
        }
        
    }
    
    
    func beginTest(_ moduleId: String) {
        
        //Set current module
        beginModule(moduleId)
        
        //Set current question
        currentQuestionIndex = 0
        
        //If there are questions, set the current question to the first one
        if currentModule?.test.questions.count ?? 0 > 0 {
            
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            
            //Set the question content
            codeText = addStyling(currentQuestion!.content)
            
        }
        
    }
    
    
    // MARK: Code Styling
    private func addStyling(_ htmlString: String) -> NSAttributedString {
        
        var resultString = NSAttributedString()
        
        var data = Data()
        
        // Add the styling data
        if styleData != nil {
            data.append(self.styleData!)
        }
        
        // Add the html data
        data.append(Data(htmlString.utf8))
        
        // Convert to attributed string
        do {
            let attributedString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                
                resultString = attributedString
            
        }
        catch {
            print("Could't turn html into attributed string")
        }
        
        return resultString
    }
    
    
    
    
}
