//
//  RegisterResult.swift
//  FamilyMap
//
//  Created by Hunter Casillas on 11/21/18.
//  Copyright © 2018 Hunter Casillas. All rights reserved.
//

import Foundation

public class RegisterResult: Decodable {
    
    public var authToken: String
    public var username: String
    public var personID: String
    
    init(authToken: String, personID: String, username: String) {
        self.authToken = authToken;
        self.personID = personID;
        self.username = username;
    }
}
