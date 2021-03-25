//
//  ViewController.swift
//  ToDoList_Firebase
//
//  Created by NIKOLAI BORISOV on 25.03.2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var regButton: UIButton!
    @IBOutlet weak var signButton: UIButton!
    
    var uid: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        regButton.layer.cornerRadius = 10
        signButton.layer.cornerRadius = 10
        
        emailTF.text = ""
        passwordTF.text = ""
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        emailTF.text = ""
        passwordTF.text = ""
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
        
        if emailTF.text != nil && passwordTF.text != nil {
            Auth.auth().createUser(withEmail: emailTF.text!, password: passwordTF.text!) { (result, error) in
                if error != nil {
                    print("Error")
                } else {
                    self.uid = (result?.user.uid)!
                    let ref = Database.database().reference(withPath: "users").child(self.uid)
                    ref.setValue(["email": self.emailTF.text!, "password": self.passwordTF.text!])
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                }
            }
        }
    }
    
    @IBAction func signInAction(_ sender: UIButton) {
        
        if emailTF.text != nil && passwordTF.text != nil {
            Auth.auth().signIn(withEmail: emailTF.text!, password: passwordTF.text!) { (result, error) in
                if error != nil {
                    print("Error")
                } else {
                    self.uid = (result?.user.uid)!
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigation = segue.destination as! UINavigationController
        let todoVC = navigation.topViewController as! ToDoViewController
        todoVC.userId = uid
    }
    

}

