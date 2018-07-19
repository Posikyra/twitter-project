//
//  ViewController3.swift
//  twitter-project
//
//  Created by Eugene Posikyra on 15.07.2018.
//  Copyright © 2018 Eugene Posikyra. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LogOutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func updateLoginDataButton(_ sender: Any) {
        let login =  emailTextField.text
        let password =  passwordTextField.text
        if  login == "" && password == ""   {
            //displayWarningLable(with: "Incorrect Info")
            return
        } else  if  login != "" && password == "" {
            changeLog(with: emailTextField.text!)
            alertController(with: "Login has been changed")
        }
        else if login == "" && password != "" {
            changePass(with: passwordTextField.text!)
            alertController(with: "Password has been changed")
        } else {
            changeLog(with: emailTextField.text!)
            changePass(with: passwordTextField.text!)
            alertController(with: "Login and password have been changed")
        }
    }
    func alertController (with text:String){
        let alertController = UIAlertController(title: "Success", message: "\(text)", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel) { _ in
        }
        alertController.addAction(ok)
        present(alertController, animated: true, completion: nil)
    }
    func changePass (with pass:String){
        Auth.auth().currentUser?.updatePassword(to: pass) { (error) in
            return
        }
    }
    func changeLog (with login:String){
        Auth.auth().currentUser?.updateEmail(to: login) { (error) in
            return
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOutDidTouch(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            print("digra")
            //displayWarningLable(with: error.localizedDescription)
        }
        self.navigationController?.popToRootViewController(animated: true)
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
