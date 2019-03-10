//
//  FilterViewController.swift
//  FamilyMap
//
//  Created by Hunter Casillas on 11/24/18.
//  Copyright © 2018 Hunter Casillas. All rights reserved.
//

import Foundation
import UIKit
import MapKit
/*
class FilterViewController: UIViewController {
    
    var mainPersonID = ""
    var allPersons = [Person]()
    var allEvents = [Event]()
    var motherSide = [Person]()
    var fatherSide = [Person]()
    var filteredEvents = [Event]()
    var filteredEventsTemp = [Event]()
    var finalFilteredEvents = [Event]()
    var filterList = [String]()
    var parentSideList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        allPersons = ViewController.Global.finalPersons
        allEvents = ViewController.Global.finalEvents
        mainPersonID = ViewController.Global.mainPersonID
        
        for person in allPersons {
            if mainPersonID == person.personID {
                let fatherID = person.father
                let motherID = person.mother
                fatherSide.append(person)
                motherSide.append(person)
                
                if fatherID != nil {
                    findFatherSide(fatherID: fatherID!)
                }
                if motherID != nil {
                    findMotherSide(motherID: motherID!)
                }
            }
        }
    }
    
    func findFatherSide(fatherID: String) {
        for person in allPersons {
            if fatherID == person.personID {
                let fatherID = person.father
                fatherSide.append(person)
                
                if fatherID != nil {
                    findFatherSide(fatherID: fatherID!)
                }
            }
        }
    }
    
    func findMotherSide(motherID: String) {
        for person in allPersons {
            if motherID == person.personID {
                let motherID = person.mother
                motherSide.append(person)
                
                if motherID != nil {
                    findMotherSide(motherID: motherID!)
                }
            }
        }
    }
    
    struct Global {
        static var reloadData = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Global.reloadData {
            Global.reloadData = false
            filterList.removeAll()
            parentSideList.removeAll()
            filteredEventsTemp = ViewController.Global.finalEvents
            maleFilter.setOn(true, animated: false)
            femaleFilter.setOn(true, animated: false)
            fatherFilter.setOn(true, animated: false)
            motherFilter.setOn(true, animated: false)
            birthFilter.setOn(true, animated: false)
            baptismFilter.setOn(true, animated: false)
            graduationFilter.setOn(true, animated: false)
            marriageFilter.setOn(true, animated: false)
            deathFilter.setOn(true, animated: false)
        }
    }
    
    @IBOutlet weak var maleFilter: UISwitch!
    @IBOutlet weak var femaleFilter: UISwitch!
    @IBOutlet weak var fatherFilter: UISwitch!
    @IBOutlet weak var motherFilter: UISwitch!
    @IBOutlet weak var birthFilter: UISwitch!
    @IBOutlet weak var baptismFilter: UISwitch!
    @IBOutlet weak var graduationFilter: UISwitch!
    @IBOutlet weak var marriageFilter: UISwitch!
    @IBOutlet weak var deathFilter: UISwitch!
    
    
    @IBAction func maleFilter(_ sender: UISwitch) {
        setFilters()
        MapsViewController.Global.filterChange = true
        PersonViewController.Global.reloadData = true
        ViewController.Global.updatedEvents = finalFilteredEvents
        SearchViewController.Global.reloadData = true
    }
    @IBAction func femaleFilter(_ sender: UISwitch) {
        setFilters()
        MapsViewController.Global.filterChange = true
        PersonViewController.Global.reloadData = true
        ViewController.Global.updatedEvents = finalFilteredEvents
        SearchViewController.Global.reloadData = true
    }
    @IBAction func fatherFilter(_ sender: UISwitch) {
        setFilters()
        MapsViewController.Global.filterChange = true
        PersonViewController.Global.reloadData = true
        ViewController.Global.updatedEvents = finalFilteredEvents
        SearchViewController.Global.reloadData = true
    }
    @IBAction func motherFilter(_ sender: UISwitch) {
        setFilters()
        MapsViewController.Global.filterChange = true
        PersonViewController.Global.reloadData = true
        ViewController.Global.updatedEvents = finalFilteredEvents
        SearchViewController.Global.reloadData = true
    }
    @IBAction func birthFilter(_ sender: UISwitch) {
        setFilters()
        MapsViewController.Global.filterChange = true
        PersonViewController.Global.reloadData = true
        ViewController.Global.updatedEvents = finalFilteredEvents
        SearchViewController.Global.reloadData = true
    }
    @IBAction func baptismFilter(_ sender: UISwitch) {
        setFilters()
        MapsViewController.Global.filterChange = true
        PersonViewController.Global.reloadData = true
        ViewController.Global.updatedEvents = finalFilteredEvents
        SearchViewController.Global.reloadData = true
    }
    @IBAction func graduationFilter(_ sender: UISwitch) {
        setFilters()
        MapsViewController.Global.filterChange = true
        PersonViewController.Global.reloadData = true
        ViewController.Global.updatedEvents = finalFilteredEvents
        SearchViewController.Global.reloadData = true
    }
    @IBAction func marriageFilter(_ sender: UISwitch) {
        setFilters()
        MapsViewController.Global.filterChange = true
        PersonViewController.Global.reloadData = true
        ViewController.Global.updatedEvents = finalFilteredEvents
        SearchViewController.Global.reloadData = true
    }
    @IBAction func deathFilter(_ sender: UISwitch) {
        setFilters()
        MapsViewController.Global.filterChange = true
        PersonViewController.Global.reloadData = true
        ViewController.Global.updatedEvents = finalFilteredEvents
        SearchViewController.Global.reloadData = true
    }
    
    func setFilters() {
        
        filterList.removeAll()
        parentSideList.removeAll()
        filteredEvents.removeAll()
        filteredEventsTemp.removeAll()
        finalFilteredEvents.removeAll()
        
        if maleFilter.isOn {
            filterList.append("Male")
        }
        if femaleFilter.isOn {
            filterList.append("Female")
        }
        if fatherFilter.isOn {
            parentSideList.append("Father")
        }
        if motherFilter.isOn {
            parentSideList.append("Mother")
        }
        if birthFilter.isOn {
            filterList.append("Birth")
        }
        if baptismFilter.isOn {
            filterList.append("Baptism")
        }
        if graduationFilter.isOn {
            filterList.append("Graduation")
        }
        if marriageFilter.isOn {
            filterList.append("Marriage")
        }
        if deathFilter.isOn {
            filterList.append("Death")
        }
        
        for event in allEvents {
            for filter in filterList {
                if filter == "Birth" {
                    if event.eventType == "Birth" {
                        filteredEvents.append(event)
                    }
                }
                if filter == "Baptism" {
                    if event.eventType == "Baptism" {
                        filteredEvents.append(event)
                    }
                }
                if filter == "Graduation" {
                    if event.eventType == "Graduation" {
                        filteredEvents.append(event)
                    }
                }
                if filter == "Marriage" {
                    if event.eventType == "Marriage" {
                        filteredEvents.append(event)
                    }
                }
                if filter == "Death" {
                    if event.eventType == "Death" {
                        filteredEvents.append(event)
                    }
                }
            }
        }
        
        for event in filteredEvents {
            let personID = event.personID
            let gender = getPersonGender(personID: personID)
            for filter in filterList {
                if filter == "Male" {
                    if gender == "m" {
                        filteredEventsTemp.append(event)
                    }
                }
                if filter == "Female" {
                    if gender == "f" {
                        filteredEventsTemp.append(event)
                    }
                }
            }
        }
        
        if parentSideList.count == 0 {
            for event in filteredEventsTemp {
                let personID = event.personID
                if personID == mainPersonID {
                    finalFilteredEvents.append(event)
                }
            }
        } else if parentSideList.count == 1 {
            for filter in parentSideList {
                if filter == "Father" {
                    for event in filteredEventsTemp {
                        let personID = event.personID
                        for person in fatherSide {
                            if person.personID == personID {
                                finalFilteredEvents.append(event)
                            }
                        }
                    }
                } else if filter == "Mother" {
                    for event in filteredEventsTemp {
                        let personID = event.personID
                        for person in motherSide {
                            if person.personID == personID {
                                finalFilteredEvents.append(event)
                            }
                        }
                    }
                }
            }
        } else if parentSideList.count == 2 {
            finalFilteredEvents = filteredEventsTemp
        }
    }
    
    func getPersonGender(personID: String) -> String {
        var gender = ""
        for person in allPersons {
            if person.personID == personID {
                gender = person.gender
            }
        }
        return gender
    }
}
*/
