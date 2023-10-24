//
//  Test.swift
//  LetsCode
//
//  Created by Domenico Montalto on 10/4/23.
//

import Foundation

struct Test: Decodable, Identifiable {
    
    var id: String = ""
    var image: String = ""
    var time: String = ""
    var description: String = ""
    var totQuestions: Int = 0
    var questions: [Question] = [Question]()
}
