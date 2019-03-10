//
//  ViewController.swift
//  FamilyMap
//
//  Created by Hunter Casillas on 11/18/18.
//  Copyright © 2018 Hunter Casillas. All rights reserved.
//
import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.sizeToFit()
        registerButton.sizeToFit()
        serverHostField.delegate = self
        serverPortField.delegate = self
        userNameField.delegate = self
        passwordField.delegate = self
        firstNameField.delegate = self
        lastNameField.delegate = self
        emailField.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    struct Global {
        static var finalPersons = [String: Person]()
        static var finalEvents = [String: Event]()
        static var updatedEvents = [String: Event]()
        static var mainPersonID = ""
        static var serverHost = ""
        static var serverPort = ""
        static var userName = ""
        static var password = ""
    }
    
    var serverHost = ""
    var serverPort = ""
    var userName = ""
    var password = ""
    var firstName = ""
    var lastName = ""
    var email = ""
    var gender = ""
    
    var authToken: String = "auth"
    var mainPersonID: String = "person"
    var mainUserName: String = "name"
    var mainFirstName: String = "first"
    var mainLastName: String = "last"
    var allPersons = Array<Person>()
    var allEvents = Array<Event>()
    
    @IBOutlet var userTextFields: [UITextField]!
    
    @IBOutlet weak var serverHostField: UITextField!
    @IBOutlet weak var serverPortField: UITextField!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var genderField: UISegmentedControl!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    func reset() {
        authToken = "auth"
        mainPersonID = "person"
        mainUserName = "name"
        mainFirstName = "first"
        mainLastName = "last"
        allPersons.removeAll()
        allEvents.removeAll()
        Global.finalPersons.removeAll()
        Global.finalEvents.removeAll()
        Global.updatedEvents.removeAll()
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        loginUser()
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
        registerUser()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func loginUser() {
        
        serverHost = serverHostField.text!
        serverHost = serverHost.trimmingCharacters(in: .whitespacesAndNewlines)
        serverPort = serverPortField.text!
        serverPort = serverPort.trimmingCharacters(in: .whitespacesAndNewlines)
        userName = userNameField.text!
        userName = userName.trimmingCharacters(in: .whitespacesAndNewlines)
        password = passwordField.text!
        password = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (serverHost.count < 1 || serverPort.count < 1 ||
            userName.count < 1 || password.count < 1) {
            loginError()
        } else {
            Global.serverHost = serverHost
            Global.serverPort = serverPort
            Global.userName = userName
            Global.password = password
            loginSuccess()
        }
    }
    
    func registerUser() {
        
        serverHost = serverHostField.text!
        serverHost = serverHost.trimmingCharacters(in: .whitespacesAndNewlines)
        serverPort = serverPortField.text!
        serverPort = serverPort.trimmingCharacters(in: .whitespacesAndNewlines)
        userName = userNameField.text!
        userName = userName.trimmingCharacters(in: .whitespacesAndNewlines)
        password = passwordField.text!
        password = password.trimmingCharacters(in: .whitespacesAndNewlines)
        firstName = firstNameField.text!
        firstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        lastName = lastNameField.text!
        lastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        email = emailField.text!
        email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (genderField.selectedSegmentIndex == 0) {
            gender = "m"
        } else if (genderField.selectedSegmentIndex == 1) {
            gender = "f"
        } else {
            gender = ""
        }
        
        if (serverHost.count < 1 || serverPort.count < 1 || userName.count < 1 ||
            password.count < 1 || firstName.count < 1 || lastName.count < 1 || email.count < 1 ||
            gender.count != 1) {
            registerError()
        } else {
            Global.serverHost = serverHost
            Global.serverPort = serverPort
            Global.userName = userName
            Global.password = password
            registerSuccess()
        }
    }
    
    func registerError() {
        let errorMessage = UIAlertController(title: "Please be sure all required information is filled in.", message: nil, preferredStyle: .alert)
        errorMessage.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { (action) in
        }))
        present(errorMessage, animated: true, completion: nil)
    }
    
    func loginError() {
        let errorMessage = UIAlertController(title: "Please be sure all required information is filled in.", message: nil, preferredStyle: .alert)
        errorMessage.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { (action) in
        }))
        present(errorMessage, animated: true, completion: nil)
    }
    
    func registerSuccess() {
        view.endEditing(true)
        let serverProxy = ServerProxy()
        
        let registerRequest = RegisterRequest.init(userName: userName, password: password, email: email, firstName: firstName, lastName: lastName, gender: gender)
        
        serverProxy.registerUser(serverHost: serverHost, serverPort: serverPort, registerRequest: registerRequest)
        serverProxy.getPersons(serverHost: serverHost, serverPort: serverPort)
        serverProxy.getEvents(serverHost: serverHost, serverPort: serverPort)
        
        authToken = serverProxy.authToken
        mainPersonID = serverProxy.mainPersonID
        Global.mainPersonID = serverProxy.mainPersonID
        mainUserName = serverProxy.mainUserName
        allPersons.removeAll()
        allEvents.removeAll()
        allPersons = serverProxy.allPersons
        allEvents = serverProxy.allEvents
        
        if serverProxy.authToken == "auth" {
            let errorMessage = UIAlertController(title: "Error. \nCould not register the user.", message: nil, preferredStyle: .alert)
            errorMessage.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { (action) in
            }))
            present(errorMessage, animated: true, completion: nil)
        } else {
            Global.finalPersons.removeAll()
            Global.finalEvents.removeAll()
            Global.updatedEvents.removeAll()
            
            for person in allPersons {
                Global.finalPersons.updateValue(person, forKey: person.personID)
                if person.personID == mainPersonID {
                    mainFirstName = person.firstName
                    mainLastName = person.lastName
                }
            }
            for event in allEvents {
                Global.finalEvents.updateValue(event, forKey: event.eventID)
                Global.updatedEvents.updateValue(event, forKey: event.eventID)
            }
            
            performSegue(withIdentifier: "ShowMap", sender: self)
        }
    }
    
    func loginSuccess() {
        let serverProxy = ServerProxy()
        
        let loginRequest = LoginRequest.init(userName: userName, password: password)
        
        serverProxy.loginUser(serverHost: serverHost, serverPort: serverPort, loginRequest: loginRequest)
        serverProxy.getPersons(serverHost: serverHost, serverPort: serverPort)
        serverProxy.getEvents(serverHost: serverHost, serverPort: serverPort)
        
        authToken = serverProxy.authToken
        mainPersonID = serverProxy.mainPersonID
        Global.mainPersonID = serverProxy.mainPersonID
        mainUserName = serverProxy.mainUserName
        allPersons.removeAll()
        allEvents.removeAll()
        allPersons = serverProxy.allPersons
        allEvents = serverProxy.allEvents
        
        if serverProxy.authToken == "auth" {
            let errorMessage = UIAlertController(title: "Error. \nCould not sign in the user.", message: nil, preferredStyle: .alert)
            errorMessage.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { (action) in
            }))
            present(errorMessage, animated: true, completion: nil)
        } else {
            Global.finalPersons.removeAll()
            Global.finalEvents.removeAll()
            Global.updatedEvents.removeAll()
            
            for person in allPersons {
                Global.finalPersons.updateValue(person, forKey: person.personID)
                if person.personID == mainPersonID {
                    mainFirstName = person.firstName
                    mainLastName = person.lastName
                }
            }
            for event in allEvents {
                Global.finalEvents.updateValue(event, forKey: event.eventID)
                Global.updatedEvents.updateValue(event, forKey: event.eventID)
            }
            
            performSegue(withIdentifier: "ShowMap", sender: self)
        }
    }
}
