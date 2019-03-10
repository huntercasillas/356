//
//  ServerProxy.swift
//  FamilyMap
//
//  Created by Hunter Casillas on 11/21/18.
//  Copyright © 2018 Hunter Casillas. All rights reserved.
//

import Foundation

public class ServerProxy {
    
    var authToken: String = "auth"
    var mainPersonID: String = "person"
    var mainUserName: String = "name"
    var allPersons = Array<Person>()
    var allEvents = Array<Event>()
    
    func registerUser(serverHost: String, serverPort: String, registerRequest: RegisterRequest) {
    
        authToken = "auth"
        var registerResult = RegisterResult(authToken: "auth", personID: "person", username: "user")
  
        let stringURL = "http://" + serverHost + ":" + serverPort + "/user/registerUser"
        guard let url = URL(string: stringURL) else { return }
        
        let config = URLSessionConfiguration.default
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "applicatoin/json"
        request.allHTTPHeaderFields = headers
        
        let jsonData = try! JSONEncoder().encode(registerRequest)
        let requestData = String(data: jsonData, encoding: String.Encoding.utf8)
        
        request.httpBody = requestData?.data(using: String.Encoding.utf8);
        
        let session = URLSession(configuration: config)
        
        var done = false
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print(error as Any)
                done = true
                return
            }
            guard let data = data else { done = true; return }
            
            do {
                registerResult = try JSONDecoder().decode(RegisterResult.self, from: data)
                self.authToken = registerResult.authToken
                self.mainPersonID = registerResult.personID
                self.mainUserName = registerResult.username
                done = true
                
            } catch let jsonError as NSError {
                print("There was an error registering the user.")
                print(jsonError)
                done = true
            }
            done = true
        }
        task.resume()
        
        repeat {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        } while !done
    }
    
    func loginUser(serverHost: String, serverPort: String, loginRequest: LoginRequest) {
    
        authToken = "auth"
        var loginResult = LoginResult(authToken: "auth", personID: "person", username: "user")
        
        let stringURL = "http://" + serverHost + ":" + serverPort + "/user/loginUser"
        guard let url = URL(string: stringURL) else { return }
        
        let config = URLSessionConfiguration.default
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "applicatoin/json"
        request.allHTTPHeaderFields = headers
        
        let jsonData = try! JSONEncoder().encode(loginRequest)
        let requestData = String(data: jsonData, encoding: String.Encoding.utf8)
        
        request.httpBody = requestData?.data(using: String.Encoding.utf8);
        
        let session = URLSession(configuration: config)
        
        var done = false
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print(error as Any)
                done = true
                return
            }
            guard let data = data else { done = true; return }
            
            do {
                loginResult = try JSONDecoder().decode(LoginResult.self, from: data)
                self.authToken = loginResult.authToken
                self.mainPersonID = loginResult.personID
                self.mainUserName = loginResult.username
                done = true
                
            } catch let jsonError as NSError {
                print("There was an error logging in the user.")
                print(jsonError)
                done = true
            }
            done = true
        }
        task.resume()
        
        repeat {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        } while !done
    }
    
    func getPersons(serverHost: String, serverPort: String) {
        
        let stringURL = "http://" + serverHost + ":" + serverPort + "/person"
        guard let url = URL(string: stringURL) else { return }
        
        let config = URLSessionConfiguration.default
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "applicatoin/json"
        request.allHTTPHeaderFields = headers
        request.addValue(authToken, forHTTPHeaderField: "Authorization")
        
        let session = URLSession(configuration: config)
        
        var done = false
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print(error as Any)
                done = true
                return
            }
            guard let data = data else { done = true; return }
            
            do {
                let personsResult = try JSONDecoder().decode(PersonsResult.self, from: data)
                self.allPersons = personsResult.data
                done = true
                
            } catch let jsonError as NSError {
                print("There was an error getting all persons.")
                print(jsonError)
                done = true
            }
            done = true
        }
        task.resume()
        
        repeat {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        } while !done
    }
    
    func getEvents(serverHost: String, serverPort: String) {
    
        let stringURL = "http://" + serverHost + ":" + serverPort + "/event"
        guard let url = URL(string: stringURL) else { return }
        
        let config = URLSessionConfiguration.default
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "applicatoin/json"
        request.allHTTPHeaderFields = headers
        request.addValue(authToken, forHTTPHeaderField: "Authorization")
        
        let session = URLSession(configuration: config)
        
        var done = false
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print(error as Any)
                done = true
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                
                if (statusCode != 200) {
                    print ("dataTaskWithRequest HTTP status code:", statusCode)
                    done = true
                    return
                }
            }
            guard let data = data else { done = true; return }
            
            do {
                let eventsResult = try JSONDecoder().decode(EventsResult.self, from: data)
                self.allEvents = eventsResult.data
                done = true
                
            } catch let jsonError as NSError {
                print("There was an error getting all events.")
                print(jsonError)
                done = true
            }
            done = true
        }
        task.resume()
        
        repeat {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        } while !done
    }
}
