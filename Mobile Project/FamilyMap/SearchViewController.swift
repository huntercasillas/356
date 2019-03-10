//
//  SearchViewController.swift
//  FamilyMap
//
//  Created by Hunter Casillas on 11/23/18.
//  Copyright © 2018 Hunter Casillas. All rights reserved.
//

import Foundation
import UIKit
import MapKit

struct foundData {
    var title = String()
    var subtitle = String()
    var itemID = String()
    var year = String()
    var location: MKCoordinateRegion?
    
    init(title: String, subtitle: String, itemID: String, year: String, location: MKCoordinateRegion? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.itemID = itemID
        self.year = year
        self.location = location
    }
}

struct cellData {
    var opened = Bool()
    var title = String()
    var sectionData = [foundData]()
}
/*
class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource,
                            UITabBarControllerDelegate {
    
    var tableID = ""
    var allPersons = Array<Person>()
    var allEvents = Array<Event>()
    var tableViewData = [cellData]()
    weak var delegate: PersonViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchTableResults.delegate = self
        allPersons = ViewController.Global.finalPersons
        allEvents = ViewController.Global.finalEvents
        let searchBarStyle = searchBar.value(forKey: "searchField") as? UITextField
        searchBarStyle?.clearButtonMode = .never
    }
    
    struct Global {
        static var reloadData = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if Global.reloadData {
            Global.reloadData = false
            searchBar.text = ""
            searchBar.endEditing(true)
            tableViewData.removeAll()
            searchTableResults.reloadData()
            allEvents = ViewController.Global.updatedEvents
        }
    }
    
    @IBOutlet weak var searchTableResults: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    func switchToMapsTab() {
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(switchToMapsTabCont), userInfo: nil,repeats: false)
    }
    
    @objc func switchToMapsTabCont() {
        if tabBarController != nil {
            tabBarController!.selectedIndex = 0
        }
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Search") else
            { return UITableViewCell() }
            cell.textLabel?.text = tableViewData[indexPath.section].title
            cell.detailTextLabel?.text = ""
            cell.textLabel?.textColor = .black
            cell.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            
            return cell
            
        } else {
            if tableViewData[indexPath.section].title == "Persons" {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "Search") else
                { return UITableViewCell() }
                cell.textLabel?.text = tableViewData[indexPath.section].sectionData[indexPath.row - 1].title
                cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
                //cell.textLabel?.textColor = .darkGray
                cell.detailTextLabel?.text = ""
                
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "Search") else
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
            if tableViewData[indexPath.section].title == "Persons" {
                // Segue for person
                tableID = tableViewData[indexPath.section].sectionData[indexPath.row - 1].subtitle
                PersonViewController.Global.cameFromSearch = true
                PersonViewController.Global.delegate = self
                performSegue(withIdentifier: "ShowPerson2", sender: self)
                
            } else if tableViewData[indexPath.section].title == "Events" {
                // Segue for event
                //performSegue(withIdentifier: "ShowEvent", sender: self)
                MapsViewController.Global.eventClicked = true
                MapsViewController.Global.zoomChange = true
                MapsViewController.Global.region = tableViewData[indexPath.section].sectionData[indexPath.row - 1].location!
                MapsViewController.Global.eventID = tableViewData[indexPath.section].sectionData[indexPath.row - 1].itemID
                
                //self.dismiss(animated: true, completion: nil)
                switchToMapsTab()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "ShowPerson2" {
            if let destination = segue.destination as? PersonViewController {
                destination.personID = tableID
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_searchBar: UISearchBar) {
        tableViewData.removeAll()
        searchTableResults.reloadData()
        //write other necessary statements
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        tableViewData.removeAll()
        searchTableResults.reloadData()
        // Remove focus from the search bar.
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        var foundPersons = [foundData]()
        foundPersons.removeAll()
        
        var foundEvents = [foundData]()
        foundEvents.removeAll()
        
        tableViewData.removeAll()
        
        var searchText: String = searchBar.text!
        searchText = searchText.lowercased()
        
        for person in allPersons {
            let fullName = person.firstName + " " + person.lastName
            let firstName = person.firstName.lowercased()
            let lastName = person.lastName.lowercased()
            let foundPerson = foundData(title: fullName, subtitle: person.personID, itemID: "")
            
            if firstName.lowercased().contains(searchText) {
                foundPersons.append(foundPerson)
            } else if lastName.contains(searchText) {
                foundPersons.append(foundPerson)
            } else if fullName.contains(searchText) {
                foundPersons.append(foundPerson)
            }
        }
        
        for event in allEvents {
            
            let personID = event.personID
            var personName = ""
            let eventType = event.eventType
            let city = event.city
            let country = event.country
            let year = event.year
            let eventID = event.eventID
            
            for person in allPersons {
                if person.personID == personID {
                    personName = person.firstName + " " + person.lastName
                }
            }
            
            let latitude:CLLocationDegrees = Double(event.latitude)!
            let longitude:CLLocationDegrees = Double(event.longitude)!
            let latDelta:CLLocationDegrees = 20.0
            let lonDelta:CLLocationDegrees = 20.0
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
            let location = CLLocationCoordinate2DMake(latitude, longitude)
            let region = MKCoordinateRegion(center: location, span: span)
            
            var eventTitle = ""
            var eventSubtitle = ""
            eventTitle = eventType + ": " + city + ", " + country + " (" + year + ")"
            eventSubtitle = personName
            
            let foundEvent = foundData(title: eventTitle, subtitle: eventSubtitle, itemID: eventID, location: region)
            
            if personName.lowercased().contains(searchText) {
                foundEvents.append(foundEvent)
            } else if eventType.lowercased().contains(searchText) {
                foundEvents.append(foundEvent)
            } else if city.lowercased().contains(searchText) {
                foundEvents.append(foundEvent)
            } else if country.lowercased().contains(searchText) {
                foundEvents.append(foundEvent)
            } else if year.lowercased().contains(searchText) {
                foundEvents.append(foundEvent)
            }
        }
        
        if foundPersons.count == 0 && foundEvents.count == 0 {
            tableViewData = [cellData(opened: true, title: "No Results Found", sectionData: foundPersons)]
        } else if foundEvents.count == 0 && foundPersons.count > 0 {
            tableViewData = [cellData(opened: true, title: "Persons", sectionData: foundPersons)]
        } else if foundPersons.count == 0 && foundEvents.count > 0 {
            tableViewData = [cellData(opened: true, title: "Events", sectionData: foundEvents)]
        } else {
            //add to tableview here
            tableViewData = [cellData(opened: true, title: "Persons", sectionData: foundPersons), cellData(opened: true, title: "Events", sectionData: foundEvents)]
        }
        
        searchTableResults.reloadData()
        searchBar.endEditing(true)
    }
}

extension SearchViewController: PopupDelegate {
    
    func navigate() {
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(navigateContinued), userInfo: nil,repeats: false)
    }
    
    @objc func navigateContinued() {
        if tabBarController != nil {
            tabBarController!.selectedIndex = 0
        }
    }
}
*/
