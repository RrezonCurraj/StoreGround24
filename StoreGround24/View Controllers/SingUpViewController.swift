//
//  SingUpViewController.swift
//  StoreGround24
//
//  Created by rrezon on 23.9.22.
//

import UIKit
import FirebaseAuth
import Firebase

class SingUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var singUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        
    }
    
    func   setUpElements() {
        errorLabel.alpha = 0
        
        //stilet e textev
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(singUpButton)
    }
    
    //sigurojm texfifilds a jan te plotsume edhe a jan te dhenat e sakta , nese gjithqka eshte mir ,metoda kthehet ne nil , perndryshe shfaq error mesazhin
    func validateFields() -> String? {
        
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            
        {
            return "Please fill in all fields."
        }
        //sigurojm a asht passwordi u sigurum 
        let cleanPassword = passwordTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanPassword) == false {
            //passwordi nuk asht i sigurum mire
            return "please make sure your password is at least 8 characters, contains a special character and a number ."
        }
        
        return nil
    }

    @IBAction func signUpTapped(_ sender: Any) {
        let error = validateFields()
        
        if error != nil {
            //diqka asht gabim me textfields, shfaq errorin
            
           showError(error!)
            
        } else {
            
            let firstname  = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastname = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            
            Auth.auth().createUser(withEmail: email, password: password) {(result, err) in
                //sigurojm a ka errore
                if err != nil {
                    showError("Error creating user ")
                } else {
                    // useri u krijua me sukses
                    let db = Firestore.firestore()
                    
                    
                    db.collection("users").addDocument(data: ["first_name": firstname, "last_name": lastname , "uid": result!.user.uid ]) { (error) in
                        
                        if error != nil {
                            //shfaqim error mesazhin
                         showError("error saving user data")
                        }
                    }
                    //
                    transitionToHome()
                     
                }
            }
        }
        func showError(_ message:String){
            errorLabel.text = message
            errorLabel.alpha = 1
        }
        
        func transitionToHome(){

            let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
    
            self.view.window?.rootViewController = homeViewController
            self.view.window?.makeKeyAndVisible()
            
        }
        
    }
    
}
