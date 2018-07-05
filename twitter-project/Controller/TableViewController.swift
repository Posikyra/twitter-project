//
//  ViewController.swift
//  twitter-project
//
//  Created by Eugene Posikyra on 04.07.2018.
//  Copyright © 2018 Eugene Posikyra. All rights reserved.
//

import UIKit
import RealmSwift

class TableViewController: UITableViewController, SecondTableViewControllerDelegate {
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMessages()
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addItem", sender: Any?.self)
    }
    let realm = try! Realm()
    var allMessages: Results<Messages>?

    //MARK: - Table view data source
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

