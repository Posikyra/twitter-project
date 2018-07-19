//
//  ViewController2.swift
//  twitter-project
//
//  Created by Eugene Posikyra on 15.07.2018.
//  Copyright © 2018 Eugene Posikyra. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController {
//
//    
//    
//    
    @IBOutlet weak var textFieldRegister: UITextField!
    
    @IBOutlet weak var textFieldPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
//
    @IBAction func registerDidTouch(_ sender: AnyObject) {
        
    let emailField = textFieldRegister!
    let passwordField = textFieldPassword!
        
    Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) {
            user, error in
            if error != nil {
                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                    switch errorCode {
                    case .weakPassword:
                        print("Please provide a strong password")
                    default:
                        print("There is an error")
                    }
                }
            }
//            if user != nil {
//                user?.sendEmailVerification() {
//                    error in
//                    print(error?.localizedDescription ?? "")
//                }
//                Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!)
//                self.performSegue(withIdentifier: "registered", sender: nil)
//            }
        }
        performSegue(withIdentifier: "registered", sender: sender)
    }
//
//    
//    
//
//    
}
