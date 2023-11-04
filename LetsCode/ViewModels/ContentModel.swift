//
//  ContentModel.swift
//  LetsCode
//
//  Created by Domenico Montalto on 10/4/23.
//

import Foundation
import Firebase
import FirebaseAuth

class ContentModel : ObservableObject {
    
    //Authentication
    @Published var loggedIn = false

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
        
        //Get database modules
        //getModules()
    }
    
    //MARK: - Authentication methods
    
    func checkLogin() {
        
        //Check if there's a current user to determine logged in status
        loggedIn = Auth.auth().currentUser != nil ? true : false
        
        //Check if user meta data has been fetched. If the user was already logged in from a previous session, we need to get their data in a separate call
        if UserService.shared.user.name == "" {
            
            getUserData()
        }
        
    }
    
    
    //MARK: - Data Methods
    
    func saveData(writeToDatabase:Bool = false) {
        
        if let loggedInUser = Auth.auth().currentUser {
            
            //Save the progress data locally
            let user = UserService.shared.user
            
            user.lastModule = currentModuleIndex
            user.lastLesson = currentLessonIndex
            user.lastQuestion = currentQuestionIndex
            
            if writeToDatabase {
                
                //Save the progress to the database
                let db = Firestore.firestore()
                let ref = db.collection("users").document(loggedInUser.uid)
                
                ref.setData(["lastModule": user.lastModule ?? NSNull(),
                             "lastLesson": user.lastLesson ?? NSNull(),
                             "lastQuestion": user.lastQuestion ?? NSNull()],merge: true)
            }
            
        }
        
    }
    
    func getUserData() {
        
        //Check that there's a logged in user
        guard Auth.auth().currentUser != nil else {
            
            return
        }
        
        //Get the meta data for that user
        let db = Firestore.firestore()
        let ref = db.collection("users").document(Auth.auth().currentUser!.uid)
        ref.getDocument { snapshot, error in
            
            //Check there is no errors
            guard error == nil, snapshot != nil else {
                
                return
            }
            
            //Parse the data out and set the user meta data
            let data = snapshot!.data()
            let user = UserService.shared.user
            user.name = data?["name"] as? String ?? ""
            user.lastModule = data?["lastModule"] as? Int
            user.lastLesson = data?["lastLesson"] as? Int
            user.lastQuestion = data?["lastQuestion"] as? Int
        }
        
    }
    
    
    func getModules() {
                
        //Parse local style.html
        getLocalStyles()
        
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
    
    func getLessons(_ module: Module, completion: @escaping () -> Void) {
        
        //Specify path
        let collection = db.collection("modules").document(module.id).collection("lessons")
        
        //Get documents
        collection.getDocuments { snapshot, error in
            
            if error == nil && snapshot != nil {
                
                var lessons = [Lesson]()
                
                //Loop through the documents and build array of lessons
                for doc in snapshot!.documents {
                    
                    //New lesson
                    var l = Lesson()
                    
                    l.id = doc["id"] as? String ?? UUID().uuidString
                    l.difficulty = doc["difficulty"] as? String ?? ""
                    l.duration = doc["duration"] as? String ?? ""
                    l.explanation = doc["explanation"] as? String ?? ""
                    l.title = doc["title"] as? String ?? ""
                    l.video = doc["video"] as? String ?? ""
                    
                    //Add the lesson to the array
                    lessons.append(l)
                    
                }
                
                //Setting the lessons to the module
                //Loopt through published modules array and find the one that matches the id of the copy that got passed in
                for (index, m) in self.modules.enumerated() {
                    
                    //Find the module we want
                    if m.id == module.id {
                        
                        //Set the lessons
                        self.modules[index].content.lessons = lessons
                        
                        //Call the complition closure
                        completion()
                        
                    }
                    
                }
                
            }
            
        }
    }
    
    
    
    func getQuestions(_ module: Module, completion: @escaping () -> Void) {
        
        //Specific path
        let collection = db.collection("modules").document(module.id).collection("questions")
        
        //Get documents
        collection.getDocuments{ snapshot,  error in
                        
            if error == nil && snapshot != nil {
                
                //Array to track questions
                var questions = [Question]()
                
                //Loop though the documents and build an array of questions
                for doc in snapshot!.documents {
                    
                    //New question
                    var q = Question()
                    
                    q.id = doc["id"] as? String ?? UUID().uuidString
                    q.answers = doc["answers"] as? [String] ?? [String]()
                    q.content = doc["content"] as? String ?? ""
                    q.correctIndex = doc["correctIndex"] as? Int ?? 0
                    
                    //Add the question to the array
                    questions.append(q)
                }
                
                //Setting the questions to the module
                //Loopt through published modules array and find the one that matches the id of the copy that got passed in
                for (index, m) in self.modules.enumerated() {
                    
                    //Find the module we want
                    if m.id == module.id {
                        
                        //Set the questions
                        self.modules[index].test.questions = questions
                        
                        //Call the completion closure
                        completion()
                        
                    }
                    
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
        
        //Reset the question index since the user is starting lessons now
        currentQuestionIndex = 0
                
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
        
        //Save the progress
        saveData()
    }
    
    func resumeQuestion() {
        
        if currentQuestionIndex < currentModule!.test.totQuestions {
            
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)
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
        
        //Save the progress
        saveData()
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
        
        //Reset the lesson index since the user is starting test now
        currentLessonIndex = 0
        
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
