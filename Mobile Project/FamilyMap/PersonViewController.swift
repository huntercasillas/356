//
//  PersonViewController.swift
//  FamilyMap
//
//  Created by Hunter Casillas on 11/23/18.
//  Copyright © 2018 Hunter Casillas. All rights reserved.
//
import Foundation
import UIKit
import MapKit

class PersonViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate {
    
    var eventID = ""
    var personID = ""
    var gender = ""
    var personName = ""
    var genderTransition = false
    var allPersons = [String: Person]()
    var allEvents = [String: Event]()
    var tableViewData = [cellData]()
    
    struct Global {
        static var cameFromSearch = false
        static var delegate: PopupDelegate?
        static var reloadData = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        allPersons = ViewController.Global.finalPersons
        allEvents = ViewController.Global.finalEvents
        
        findData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Global.reloadData {
            Global.reloadData = false
            allPersons = ViewController.Global.finalPersons
            allEvents = ViewController.Global.updatedEvents
            findData()
        } else {
            allEvents = ViewController.Global.updatedEvents
            findData()
        }
    }
    
    @IBOutlet var genderImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].opened == true {
            return tableViewData[section].sectionData.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PersonDetail") else
            { return UITableViewCell() }
            cell.textLabel?.text = tableViewData[indexPath.section].title
            cell.detailTextLabel?.text = ""
            cell.textLabel?.textColor = .black
            cell.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            
            return cell
            
        } else {
            if tableViewData[indexPath.section].title == "Persons" {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "PersonDetail") else
                { return UITableViewCell() }
                cell.textLabel?.text = tableViewData[indexPath.section].sectionData[indexPath.row - 1].title
                cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
                //cell.textLabel?.textColor = .darkGray
                cell.detailTextLabel?.text = ""
                
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "PersonDetail") else
                { return UITableViewCell() }
                cell.textLabel?.text = tableViewData[indexPath.section].sectionData[indexPath.row - 1].title
                cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
                //cell.textLabel?.textColor = .darkGray
                cell.detailTextLabel?.text = tableViewData[indexPath.section].sectionData[indexPath.row - 1].subtitle
                //cell.detailTextLabel?.textColor = .darkGray
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            if tableViewData[indexPath.section].opened == true {
                tableViewData[indexPath.section].opened = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            } else {
                tableViewData[indexPath.section].opened = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
        } else {
            if tableViewData[indexPath.section].title == "Family" {
                // Segue for person
                personID = tableViewData[indexPath.section].sectionData[indexPath.row - 1].itemID
                findData()
                
            } else if tableViewData[indexPath.section].title == "Life Events" {
                // Segue for event
                MapsViewController.Global.eventClicked = true
                MapsViewController.Global.zoomChange = true
                MapsViewController.Global.region = tableViewData[indexPath.section].sectionData[indexPath.row - 1].location!
                MapsViewController.Global.eventID = tableViewData[indexPath.section].sectionData[indexPath.row - 1].itemID
                self.dismiss(animated: true, completion: nil)
                
                if Global.cameFromSearch {
                    Global.cameFromSearch = false
                    Global.delegate?.navigate()
                } else {
                    switchToMapsTab()
                }
            }
        }
    }
    
    func switchToMapsTab() {
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(switchToMapsTabCont), userInfo: nil,repeats: false)
    }
    
    @objc func switchToMapsTabCont() {
        if tabBarController != nil {
            tabBarController!.selectedIndex = 0
        }
    }
    
    func findData() {
        
        var foundPersons = [foundData]()
        foundPersons.removeAll()
        
        var foundEvents = [foundData]()
        foundEvents.removeAll()
        
        tableViewData.removeAll()
        
        let currentPerson = allPersons[personID]
        var fatherID = ""
        var motherID = ""
        var spouseID = ""
        
        if currentPerson != nil {
            personName = currentPerson!.firstName + " " + currentPerson!.lastName
            UIView.transition(with: nameLabel, duration: 0.5, options: .transitionFlipFromBottom, animations: { self.nameLabel.text = currentPerson!.firstName + " " + currentPerson!.lastName }, completion: nil)
            
            if gender != currentPerson!.gender {
                genderTransition = true
            }
            gender = currentPerson!.gender
        }
        if currentPerson!.spouse != nil {
            spouseID = currentPerson!.spouse!
            let currentSpouse = allPersons[spouseID]
            let fullName = currentSpouse!.firstName + " " + currentSpouse!.lastName
            let foundPerson = foundData(title: fullName, subtitle: "Spouse", itemID: spouseID, year: "")
            foundPersons.append(foundPerson)
        }
        if currentPerson!.father != nil {
            fatherID = currentPerson!.father!
            let currentFather = allPersons[fatherID]
            let fullName = currentFather!.firstName + " " + currentFather!.lastName
            let foundPerson = foundData(title: fullName, subtitle: "Father", itemID: fatherID, year: "")
            foundPersons.append(foundPerson)
        }
        if currentPerson!.mother != nil {
            motherID = currentPerson!.mother!
            let currentMother = allPersons[motherID]
            let fullName = currentMother!.firstName + " " + currentMother!.lastName
            let foundPerson = foundData(title: fullName, subtitle: "Mother", itemID: motherID, year: "")
            foundPersons.append(foundPerson)
        }
        
        for (_, person) in allPersons {
            if personID == person.father || personID == person.mother {
                let fullName = person.firstName + " " + person.lastName
                let foundPerson = foundData(title: fullName, subtitle: "Child", itemID: person.personID, year: "")
                foundPersons.append(foundPerson)
            }
        }

        if genderTransition {
            genderTransition = false
            if (gender == "m") {
                let image : UIImage = UIImage(named:"Male")!
                UIView.transition(with: genderImage, duration: 0.5, options: .transitionFlipFromTop, animations: { self.genderImage.image = image }, completion: nil)
            } else {
                let image : UIImage = UIImage(named:"Female")!
                UIView.transition(with: genderImage, duration: 0.5, options: .transitionFlipFromTop, animations: { self.genderImage.image = image }, completion: nil)
            }
        }
        
        for (eventID, event) in allEvents {
            if personID == event.personID {
                let eventType = event.eventType
                let city = event.city
                let country = event.country
                let year = event.year
                var eventTitle = ""
                var eventSubtitle = ""
                let latitude:CLLocationDegrees = Double(event.latitude)!
                let longitude:CLLocationDegrees = Double(event.longitude)!
                let latDelta:CLLocationDegrees = 20.0
                let lonDelta:CLLocationDegrees = 20.0
                let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
                let location = CLLocationCoordinate2DMake(latitude, longitude)
                let region = MKCoordinateRegion(center: location, span: span)
                eventTitle = eventType + ": " + city + ", " + country + " (" + year + ")"
                eventSubtitle = personName
                let foundEvent = foundData(title: eventTitle, subtitle: eventSubtitle, itemID: eventID, year: year, location: region)
                foundEvents.append(foundEvent)
            }
        }
        
        foundEvents = foundEvents.sorted(by: {$0.year < $1.year})

        
        if foundPersons.count == 0 && foundEvents.count == 0 {
            tableViewData = [cellData(opened: true, title: "No Results Found", sectionData: foundPersons)]
        } else if foundEvents.count == 0 && foundPersons.count > 0 {
            tableViewData = [cellData(opened: true, title: "Family", sectionData: foundPersons)]
        } else if foundPersons.count == 0 && foundEvents.count > 0 {
            tableViewData = [cellData(opened: true, title: "Life Events", sectionData: foundEvents)]
        } else {
            //add to tableview here
            tableViewData = [cellData(opened: true, title: "Family", sectionData: foundPersons), cellData(opened: true, title: "Life Events", sectionData: foundEvents)]
        }
        // Reload details in person view
        UIView.transition(with: tableView, duration: 1.5, options: .curveEaseInOut, animations: { self.tableView.reloadData()}, completion: nil)
    }
}
