//
//  SettingsViewController.swift
//  FamilyMap
//
//  Created by Hunter Casillas on 11/24/18.
//  Copyright © 2018 Hunter Casillas. All rights reserved.
//

import Foundation
import UIKit
import MapKit
/*
class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapTypeSelector.selectedSegmentIndex = 0
        lifeStorySelector.selectedSegmentIndex = 0
        spouseSelector.selectedSegmentIndex = 1
        fatherLineageSelector.selectedSegmentIndex = 2
        motherLineageSelector.selectedSegmentIndex = 3
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func switchToMapsTab() {
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(switchToMapsTabCont), userInfo: nil,repeats: false)
    }
    
    @objc func switchToMapsTabCont() {
        if tabBarController != nil {
            tabBarController!.selectedIndex = 0
        }
    }
    
    @IBAction func reloadAction(_ sender: Any) {
        mapTypeSelector.selectedSegmentIndex = 0
        lifeStorySelector.selectedSegmentIndex = 0
        spouseSelector.selectedSegmentIndex = 1
        fatherLineageSelector.selectedSegmentIndex = 2
        motherLineageSelector.selectedSegmentIndex = 3
        
        lifeStorySwitch.setOn(true, animated: false)
        spouseSwitch.setOn(true, animated: false)
        fatherLineageSwitch.setOn(true, animated: false)
        motherLineageSwitch.setOn(true, animated: false)
        
        let serverProxy = ServerProxy()
        let loginRequest = LoginRequest.init(userName: ViewController.Global.userName,
                                             password: ViewController.Global.password)
        
        serverProxy.loginUser(serverHost: ViewController.Global.serverHost,
                              serverPort: ViewController.Global.serverPort, loginRequest: loginRequest)
        serverProxy.getPersons(serverHost: ViewController.Global.serverHost,
                               serverPort: ViewController.Global.serverPort)
        serverProxy.getEvents(serverHost: ViewController.Global.serverHost,
                              serverPort: ViewController.Global.serverPort)
        
        ViewController.Global.finalPersons.removeAll()
        ViewController.Global.finalEvents.removeAll()
        ViewController.Global.updatedEvents.removeAll()
        ViewController.Global.finalPersons = serverProxy.allPersons
        ViewController.Global.finalEvents = serverProxy.allEvents
        ViewController.Global.updatedEvents = serverProxy.allEvents
        
        let span = MKCoordinateSpan(latitudeDelta: 120.0, longitudeDelta: 120.0)
        let location = CLLocationCoordinate2DMake(16.6458, -38.9250)
        let region = MKCoordinateRegion(center: location, span: span)
        MapsViewController.Global.region = region
        MapsViewController.Global.mapType = .standard
        ViewController.Global.updatedEvents = serverProxy.allEvents
        MapsViewController.Global.eventClicked = true
        MapsViewController.Global.typeChange = true
        MapsViewController.Global.filterChange = true
        SearchViewController.Global.reloadData = true
        FilterViewController.Global.reloadData = true
        MapsViewController.Global.showLifeStoryLines = true
        MapsViewController.Global.showFatherLines = true
        MapsViewController.Global.showMotherLines = true
        MapsViewController.Global.showSpouseLines = true
        MapsViewController.Global.lifeStoryColor = .red
        MapsViewController.Global.spouseColor = .blue
        MapsViewController.Global.fatherLineageColor = .green
        MapsViewController.Global.motherLineageColor = .magenta
        
        switchToMapsTab()
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        mapTypeSelector.selectedSegmentIndex = 0
        lifeStorySelector.selectedSegmentIndex = 0
        spouseSelector.selectedSegmentIndex = 1
        fatherLineageSelector.selectedSegmentIndex = 2
        motherLineageSelector.selectedSegmentIndex = 3
        
        lifeStorySwitch.setOn(true, animated: false)
        spouseSwitch.setOn(true, animated: false)
        fatherLineageSwitch.setOn(true, animated: false)
        motherLineageSwitch.setOn(true, animated: false)
        
        ViewController.Global.finalPersons.removeAll()
        ViewController.Global.finalEvents.removeAll()
        ViewController.Global.updatedEvents.removeAll()
        let span = MKCoordinateSpan(latitudeDelta: 120.0, longitudeDelta: 120.0)
        let location = CLLocationCoordinate2DMake(16.6458, -38.9250)
        let region = MKCoordinateRegion(center: location, span: span)
        MapsViewController.Global.region = region
        MapsViewController.Global.mapType = .standard
        MapsViewController.Global.eventClicked = true
        MapsViewController.Global.typeChange = true
        MapsViewController.Global.filterChange = true
        SearchViewController.Global.reloadData = true
        FilterViewController.Global.reloadData = true
        MapsViewController.Global.lineChange = true
        MapsViewController.Global.showLifeStoryLines = true
        MapsViewController.Global.showFatherLines = true
        MapsViewController.Global.showMotherLines = true
        MapsViewController.Global.showSpouseLines = true
        MapsViewController.Global.lifeStoryColor = .red
        MapsViewController.Global.spouseColor = .blue
        MapsViewController.Global.fatherLineageColor = .green
        MapsViewController.Global.motherLineageColor = .magenta
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func mapSelector(_ sender: Any) {
        if (mapTypeSelector.selectedSegmentIndex == 0) {
            MapsViewController.Global.typeChange = true
            MapsViewController.Global.mapType = .standard
        } else if (mapTypeSelector.selectedSegmentIndex == 1) {
            MapsViewController.Global.typeChange = true
            MapsViewController.Global.mapType = .satellite
        } else if (mapTypeSelector.selectedSegmentIndex == 2) {
            MapsViewController.Global.typeChange = true
            MapsViewController.Global.mapType = .hybrid
        }
    }
    
    @IBAction func lifeStoryButton(_ sender: Any) {
        MapsViewController.Global.lineChange = true
        
        if lifeStorySwitch.isOn {
            MapsViewController.Global.showLifeStoryLines = true
        } else {
            MapsViewController.Global.showLifeStoryLines = false
        }
    }
    
    @IBAction func fatherLineageButton(_ sender: Any) {
        MapsViewController.Global.lineChange = true
        
        if fatherLineageSwitch.isOn {
            MapsViewController.Global.showFatherLines = true
        } else {
            MapsViewController.Global.showFatherLines = false
        }
    }
    
    
    @IBAction func motherLineageButton(_ sender: Any) {
        MapsViewController.Global.lineChange = true
        
        if motherLineageSwitch.isOn {
            MapsViewController.Global.showMotherLines = true
        } else {
            MapsViewController.Global.showMotherLines = false
        }
    }
    
    @IBAction func spouseButton(_ sender: Any) {
        MapsViewController.Global.lineChange = true
        
        if spouseSwitch.isOn {
            MapsViewController.Global.showSpouseLines = true
        } else {
            MapsViewController.Global.showSpouseLines = false
        }
    }
    
    @IBAction func lifeStoryColor(_ sender: Any) {
        MapsViewController.Global.lineChange = true
        
        if lifeStorySelector.selectedSegmentIndex == 0 {
            MapsViewController.Global.lifeStoryColor = .red
            
        } else if lifeStorySelector.selectedSegmentIndex == 1 {
            MapsViewController.Global.lifeStoryColor = .blue
            
        } else if lifeStorySelector.selectedSegmentIndex == 2 {
            MapsViewController.Global.lifeStoryColor = .green
            
        } else if lifeStorySelector.selectedSegmentIndex == 3 {
            MapsViewController.Global.lifeStoryColor = .magenta
        }
    }
    
    
    
    @IBAction func fatherLineageColor(_ sender: Any) {
        MapsViewController.Global.lineChange = true
        
        if fatherLineageSelector.selectedSegmentIndex == 0 {
            MapsViewController.Global.fatherLineageColor = .red
            
        } else if fatherLineageSelector.selectedSegmentIndex == 1 {
            MapsViewController.Global.fatherLineageColor = .blue
            
        } else if fatherLineageSelector.selectedSegmentIndex == 2 {
            MapsViewController.Global.fatherLineageColor = .green
            
        } else if fatherLineageSelector.selectedSegmentIndex == 3 {
            MapsViewController.Global.fatherLineageColor = .magenta
        }
    }
    
    @IBAction func motherLineageColor(_ sender: Any) {
        MapsViewController.Global.lineChange = true
        
        if motherLineageSelector.selectedSegmentIndex == 0 {
            MapsViewController.Global.motherLineageColor = .red
            
        } else if motherLineageSelector.selectedSegmentIndex == 1 {
            MapsViewController.Global.motherLineageColor = .blue
            
        } else if motherLineageSelector.selectedSegmentIndex == 2 {
            MapsViewController.Global.motherLineageColor = .green
            
        } else if motherLineageSelector.selectedSegmentIndex == 3 {
            MapsViewController.Global.motherLineageColor = .magenta
        }
    }
    
    
    @IBAction func spouseColor(_ sender: Any) {
        MapsViewController.Global.lineChange = true
        
        if spouseSelector.selectedSegmentIndex == 0 {
            MapsViewController.Global.spouseColor = .red
            
        } else if spouseSelector.selectedSegmentIndex == 1 {
            MapsViewController.Global.spouseColor = .blue
            
        } else if spouseSelector.selectedSegmentIndex == 2 {
            MapsViewController.Global.spouseColor = .green
            
        } else if spouseSelector.selectedSegmentIndex == 3 {
            MapsViewController.Global.spouseColor = .magenta
        }
    }
    
    
    @IBOutlet weak var logoutButton: RoundButton!
    @IBOutlet weak var reloadButton: RoundButton!
    @IBOutlet weak var mapTypeSelector: UISegmentedControl!

    @IBOutlet weak var spouseSwitch: UISwitch!
    @IBOutlet weak var fatherLineageSwitch: UISwitch!
    @IBOutlet weak var motherLineageSwitch: UISwitch!
    @IBOutlet weak var lifeStorySwitch: UISwitch!
    
    @IBOutlet weak var spouseSelector: UISegmentedControl!
    @IBOutlet weak var fatherLineageSelector: UISegmentedControl!
    @IBOutlet weak var motherLineageSelector: UISegmentedControl!
    @IBOutlet weak var lifeStorySelector: UISegmentedControl!
}
*/
