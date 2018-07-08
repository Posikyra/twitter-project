//
//  ViewController.swift
//  twitter-project
//
//  Created by Eugene Posikyra on 04.07.2018.
//  Copyright © 2018 Eugene Posikyra. All rights reserved.
//

import UIKit
import RealmSwift
import ForecastIOClient
import Firebase
import FirebaseDatabase

class TableViewController: UITableViewController, SecondTableViewControllerDelegate {
    //MARK: - SecondTableViewController protocol methods
    func SecondTableViewControllerDidCancel(_controller: SecondTableViewController) {
        navigationController?.popViewController(animated: true)
    }
    func SecondTableViewController(_ controller: SecondTableViewController, didFinishEditing item: Messages) {
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    func SecondTableViewController(_ controller: SecondTableViewController, didFinishAdding item: Messages) {
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    func grabFirebaseData(data: String) {
        let databaseRef = Database.database().reference()
        databaseRef.child("Messages").observe(.value, with: {
            snapshot in
            print(snapshot)
            for snap in snapshot.children.allObjects as! [DataSnapshot] {
                guard let dictionary = snap.value as? [String: AnyObject] else {
                    return
                }
                let text = dictionary[data] as? String
                let item = Messages()
                item.text = text!
                item.date = Date()
                item.id = item.IncrementaID()
                self.save(category: item)
                self.loadMessages()
            }
        })
    }
    
    //MARK: - TableView methods and datasource
    override func viewDidLoad() {
        super.viewDidLoad()
        grabFirebaseData(data: "message1")
        grabFirebaseData(data: "message2")
        grabFirebaseData(data: "message3")
        loadMessages()
        //////////////////////////////////////////
//        ForecastIOClient.apiKey = "dc43852eb8671f793e9ba0502535d754"  //////////API
//        ForecastIOClient.units = Units.Uk
//        ForecastIOClient.sharedInstance.forecast(55.751244, longitude: 37.618423) { (forecast, forecastAPICalls) -> Void in
//            var temperature = String?((forecast.currently?.summary)!)
//            let item = Messages()
//            item.text = "moscow " + temperature!
//            item.date = Date()
//            item.id = item.IncrementaID()
//            self.save(category: item)
//            super.viewDidLoad()
//            self.loadMessages()
//        }
//        ForecastIOClient.sharedInstance.forecast(51.509865, longitude: -0.118092) { (forecast, forecastAPICalls) -> Void in
//            var temperature = String?((forecast.currently?.summary)!)
//            let item = Messages()
//            item.text = "london " + temperature!
//            item.date = Date()
//            item.id = item.IncrementaID()
//            self.save(category: item)
//            super.viewDidLoad()
//            self.loadMessages()
//        }
//        ForecastIOClient.sharedInstance.forecast(50.431782, longitude: 30.516382) { (forecast, forecastAPICalls) -> Void in
//            var temperature = String?((forecast.currently?.summary)!)
//            let item = Messages()
//            item.text = "kyiv " + temperature!
//            item.date = Date()
//            item.id = item.IncrementaID()
//            self.save(category: item)
//            super.viewDidLoad()
//            self.loadMessages()
//        }
        /////////////////////////////////////////
        tableView.reloadData()
    }
    
    func save(category: Messages) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        loadMessages()
    }
    
    
    

    @IBAction func addButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addItem", sender: Any?.self)
    }
    let realm = try! Realm()
    var allMessages: Results<Messages>?
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMessages?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
        if let item = allMessages?[indexPath.row] {
        cell.textLabel?.text = item.text
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            let item = self.allMessages?[indexPath.row]
            try! self.realm.write({
                self.realm.delete(item!)
            })
            tableView.deleteRows(at:[indexPath], with: .automatic)
        }
        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            let toBeUpdated = self.allMessages![indexPath.row]
            self.performSegue(withIdentifier: "editItem", sender: toBeUpdated)
        }
        edit.backgroundColor = .purple
        delete.backgroundColor = .red
        return [delete, edit]
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addItem" {
            let controller = segue.destination as! SecondTableViewController
            controller.delegate = self
        }
        if segue.identifier == "editItem" {
            let controller = segue.destination as! SecondTableViewController
            controller.delegate = self
            if let item = sender as? Messages {
                controller.itemToEdit = item
            }
            let object = sender as! Messages
            controller.itemToDelete = object
        }
    }
    func loadMessages() {
        allMessages = realm.objects(Messages.self)
        allMessages = allMessages?.sorted(byKeyPath: "date", ascending: false)
        self.tableView.setEditing(false, animated: true)
        tableView.reloadData()
    }
}

