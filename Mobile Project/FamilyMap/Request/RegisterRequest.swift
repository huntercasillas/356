//
//  RegisterRequest.swift
//  FamilyMap
//
//  Created by Hunter Casillas on 11/21/18.
//  Copyright © 2018 Hunter Casillas. All rights reserved.
//

import Foundation

public class RegisterRequest: Encodable {
    
    private var userName: String
    private var password: String
    private var email: String
    private var firstName: String
    private var lastName: String
    private var gender: String
    
    init(userName: String, password: String, email: String, firstName: String,
         lastName: String, gender: String) {
        self.userName = userName
        self.password = password
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
    }
}
