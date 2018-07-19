//
//  ViewController.swift
//  twitter-project
//
//  Created by Eugene Posikyra on 15.07.2018.
//  Copyright © 2018 Eugene Posikyra. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD
class ProfileViewController: UIViewController {

    // MARK: - Constraints
    let loginTwitter = "loginToList"
    
    // MARK: - Outlets
    
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let rootRef = Database.database().reference()
//        let childRef = Database.database().reference(withPath: "New messages")
//        let messagesRef = rootRef.child("New messages")
//        let milkRef = messagesRef.child("milk")
//        print(rootRef.key)
//        print(childRef.key)
//        print(messagesRef.key)
//        print(milkRef.key)
        
        
        // Это наблюдатель, следит за тем, чтобы пользователь уже был зарегистрирован
        
//        let listener = Auth.auth().addStateDidChangeListener {
//            auth, user in
//            if user != nil {
//                //self.navigationController?.popViewController(animated: true)
//                //self.performSegue(withIdentifier: self.loginTwitter, sender: nil)
//            }
//        }
//        Auth.auth().removeStateDidChangeListener(listener)
   }
    


    @IBAction func loginDidTouch(_ sender: AnyObject) {
        
        SVProgressHUD.show()
        
        Auth.auth().signIn(withEmail: textFieldLoginEmail.text!, password: textFieldLoginPassword.text!) { (user, error) in
            
            if error != nil {
                print(error!)
            } else {
                print("Log in successful!")
                
                SVProgressHUD.dismiss()
                
            }
            self.navigationController?.popViewController(animated: true)
        }
        
    }
//    func displayWarningLable (with text: String){
//        alertLable.text = text
//        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations:{[weak self] in self?.alertLable.alpha = 1}, completion: {[weak self] complete in self?.alertLable.alpha = 0}
//        )
//    }
    
    
    @IBAction func logOutDidTouch(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            print("digra")
            //displayWarningLable(with: error.localizedDescription)
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    


    

}
