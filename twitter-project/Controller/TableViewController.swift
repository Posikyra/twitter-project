//
//  ViewController.swift
//  twitter-project
//
//  Created by Eugene Posikyra on 04.07.2018.
//  Copyright © 2018 Eugene Posikyra. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase
import FirebaseDatabase

class TableViewController: UITableViewController {
    var realm = try! Realm()
    var allMessages: Results<Messages>?
    var ref: DatabaseReference!
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        allMessages = realm.objects(Messages.self)
        self.allMessages = self.allMessages?.sorted(byKeyPath: "id", ascending:false)
        
        self.tableView.setEditing(false, animated: true)
        self.tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uploadRemoteData()
        realm = try! Realm()
        if !UserDefaults.standard.bool(forKey: "db_install") {
        
        loadMessages()
        tableView.reloadData()
    }
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        ref = Database.database().reference(withPath: "New messages")
        
    }
    @IBAction func addButton(_ sender: Any?) {
        let alertController = UIAlertController(title: "New message", message: "Enter message", preferredStyle: .alert)
        var alertTextField: UITextField!
        alertController.addTextField { textField in
            alertTextField = textField
            textField.placeholder = "Message"
    }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            guard let text = alertTextField.text , !text.isEmpty else { return }
            let message = Messages()
            message.text = text
            message.id = message.IncrementaID()
            try! self.realm.write {
                self.realm.add(message)
                self.allMessages = self.allMessages?.sorted(byKeyPath: "id", ascending:false)
            }
            let message1 = MessagesFireBase(messageText: text, messageId: message.id)
            let taskRef = self.ref.child("Message \(message.id)")
            taskRef.setValue(message1.convertToDictionary())
            self.tableView.reloadData()
            self.realm.refresh()
        })
        present(alertController, animated: true, completion: nil)
    }
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
            let alertController = UIAlertController(title: "Edit message", message: nil, preferredStyle: .alert)
            let messageObj = self.allMessages?[indexPath.row]
            var alertTextField: UITextField!
            alertController.addTextField { textField in
                alertTextField = textField
                textField.text = messageObj?.text
            }
            alertController.addAction(UIAlertAction(title: "Edit", style: .default) { _ in
                try! self.realm.write({
                    messageObj?.text = alertTextField.text!
                    messageObj?.date = Date()
                    self.realm.add(messageObj!, update: true)})
                self.ref.child("Message \(messageObj?.id)").updateChildValues(["messageText" : alertTextField.text!])
                self.allMessages = self.allMessages?.sorted(byKeyPath: "date", ascending: false)
                self.tableView.reloadData()
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancel)
            self.present(alertController, animated: true, completion: nil)
        }
        edit.backgroundColor = .purple
        delete.backgroundColor = .red
        return [delete, edit]
    }
    func loadMessages() {
        allMessages = realm.objects(Messages.self)
        allMessages = allMessages?.sorted(byKeyPath: "id", ascending: false)
        self.tableView.setEditing(false, animated: true)
        tableView.reloadData()
    }


func uploadRemoteData() {
    
    ref = Database.database().reference(withPath: "Messages")
    
    ref.observe(.value, with: {[weak self] (snapshot) in
        self?.realm = try! Realm()
        for item in snapshot.children {
            let messangeBase = MessagesFireBase(snapshot: item as! DataSnapshot)
            messagesFirebase.append(messangeBase)
            let messageForRealm = Messages()
            messageForRealm.text = messangeBase.messageText
            messageForRealm.id = messangeBase.messageId
            try! self?.realm.write({
                self?.realm.add(messageForRealm)
            })
            
        }
        self?.tableView.reloadData()
        self?.realm.refresh()
    })
    
    UserDefaults.standard.set(true, forKey: "db_install")
}
}
//func grabFirebaseData(data: String) {
//    let databaseRef = Database.database().reference()
//    databaseRef.child("Messages").observe(.value, with: {
//        snapshot in
//        print(snapshot)
//        for snap in snapshot.children.allObjects as! [DataSnapshot] {
//            guard let dictionary = snap.value as? [String: AnyObject] else {
//                return
//            }
//            let text = dictionary[data] as? String
//            let item = Messages()
//            item.text = text!
//            item.date = Date()
//            item.id = item.IncrementaID()
//            self.save(category: item)
//            self.loadMessages()
//        }
//    })
//}
//    let realm = try! Realm()
//    let message = Messages()
//    var itemToEdit: Messages?
//    var newMessages: Results<Messages>?
//    var itemToDelete = Messages()
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//    weak var delegate: SecondTableViewControllerDelegate?
//    @IBOutlet weak var cellTextField: UITextField!
//    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
//        saveOrEdit()
//    }
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        saveOrEdit()
//        return true
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        cellTextField.becomeFirstResponder()
//        cellTextField.placeholder = "Create new item"
//        if let item = itemToEdit {
//            title = "Edit Item"
//            cellTextField.text = item.text
//        }
//    }
//    func saveOrEdit() {
//        if let itemToEdit = itemToEdit {
//            title = "Edit Item"
//            do {
//                try realm.write {
//                    itemToEdit.text = cellTextField.text!
//                }
//            } catch {
//                print(error)
//            }
//            delegate?.SecondTableViewController(self, didFinishEditing: itemToEdit)
//        } else {
//            let item = Messages()
//            item.text = cellTextField.text!
//            item.date = Date()
//            // item.id = item.date!.description
//            item.id = item.IncrementaID()
//            self.save(category: item)
//            tableView.reloadData()
//            delegate?.SecondTableViewController(self, didFinishAdding: item)
//        }
//    }
//    func save(category: Messages) {
//        do {
//            try realm.write {
//                realm.add(category)
//            }
//        } catch {
//            print("Error saving category \(error)")
//        }
//        load()
//    }

//    func save(category: Messages) {
//        do {
//            try realm.write {
//                realm.add(category)
//            }
//        } catch {
//            print("Error saving category \(error)")
//        }
//        loadMessages()
//    }



//
//
