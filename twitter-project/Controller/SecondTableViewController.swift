//
//  SecondTableViewController.swift
//  twitter-project
//
//  Created by Eugene Posikyra on 05.07.2018.
//  Copyright © 2018 Eugene Posikyra. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseDatabase
protocol SecondTableViewControllerDelegate: class {
    func SecondTableViewControllerDidCancel(_controller: SecondTableViewController)
    func SecondTableViewController(_ controller: SecondTableViewController, didFinishAdding item: Messages)
    func SecondTableViewController(_ controller: SecondTableViewController, didFinishEditing item: Messages)
}
class SecondTableViewController: UITableViewController, UITextFieldDelegate {
    
    var ref: DatabaseReference!

    
    let realm = try! Realm()
    let message = Messages()
    var itemToEdit: Messages?
    var newMessages: Results<Messages>?
    var itemToDelete = Messages()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    weak var delegate: SecondTableViewControllerDelegate?
    @IBOutlet weak var cellTextField: UITextField!
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        saveOrEdit()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveOrEdit()
        return true
    }
    override func viewWillAppear(_ animated: Bool) {
        cellTextField.becomeFirstResponder()
        cellTextField.placeholder = "Create new item"
        if let item = itemToEdit {
            title = "Edit Item"
            cellTextField.text = item.text
        }
    }
    func saveOrEdit() {
        if let itemToEdit = itemToEdit {
            title = "Edit Item"
            do {
                try realm.write {
                    itemToEdit.text = cellTextField.text!
                }
            } catch {
                print(error)
            }
            delegate?.SecondTableViewController(self, didFinishEditing: itemToEdit)
        } else {
            let item = Messages()
            item.text = cellTextField.text!
            item.date = Date()
           // item.id = item.date!.description
            item.id = item.IncrementaID()
            self.save(category: item)
            tableView.reloadData()
            delegate?.SecondTableViewController(self, didFinishAdding: item)
        }
    }
    func save(category: Messages) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        load()
    }
    func load() {
        newMessages = realm.objects(Messages.self)
        newMessages = newMessages?.sorted(byKeyPath: "date", ascending: false)
        tableView.reloadData()
    }
}
