//
//  LoginRequest.swift
//  FamilyMap
//
//  Created by Hunter Casillas on 11/21/18.
//  Copyright © 2018 Hunter Casillas. All rights reserved.
//

import Foundation

public class LoginRequest: Encodable {
    
    private var userName: String
    private var password: String
    
    init(userName: String, password: String) {
        self.userName = userName
        self.password = password
    }
}
