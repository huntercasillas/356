//
//  LoginResult.swift
//  FamilyMap
//
//  Created by Hunter Casillas on 11/21/18.
//  Copyright © 2018 Hunter Casillas. All rights reserved.
//

import Foundation

public class LoginResult: Decodable {
    
    var authToken: String
    var username: String
    var personID: String
    
    init(authToken: String, personID: String, username: String) {
        self.authToken = authToken;
        self.personID = personID;
        self.username = username;
    }
}
