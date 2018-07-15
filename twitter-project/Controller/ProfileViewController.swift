//
//  ViewController.swift
//  twitter-project
//
//  Created by Eugene Posikyra on 15.07.2018.
//  Copyright © 2018 Eugene Posikyra. All rights reserved.
//

import UIKit
import Firebase
class ProfileViewController: UIViewController {

    // MARK: - Constraints
    let loginTwitter = "LoginTwitter"
    
    // MARK: - Outlets
    
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    

    @IBAction func loginDidTouch(_ sender: AnyObject) {
        
    }
    
    
    
    override func viewDidLoad() {
        //super.viewDidLoad()
        let rootRef = Database.database().reference()
        let childRef = Database.database().reference(withPath: "messages")
        let messagesRef = rootRef.child("messages")
        let milkRef = messagesRef.child("milk")
        print(rootRef.key)
        print(childRef.key)
        print(messagesRef.key)
        print(milkRef.key)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
