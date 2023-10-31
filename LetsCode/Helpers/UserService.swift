//
//  UserService.swift
//  LetsCode
//
//  Created by Domenico Montalto on 10/31/23.
//

import Foundation

class UserService {
    
    var user = User()
    
    static var shared = UserService()
    
    private init() {
        
    }
    
}
