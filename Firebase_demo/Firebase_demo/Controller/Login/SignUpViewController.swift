//
//  SigninViewController.swift
//  Firebase_demo
//
//  Created by Hoang Dinh Huy on 10/14/19.
//  Copyright © 2019 Hoang Dinh Huy. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

final class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configView()
        // Do any additional setup after loading the view.
    }
    
    deinit {
        logger()
    }
    
    private func configView() {
        addEndEditingTapGuesture()
        errorLabel.alpha = 0
        
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleFilledButton(cancelButton)
    }
    
    private func validateField() -> String?{
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill all the fields"
        }
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        
        return nil
    }
    @IBAction func tappedSignUp(_ sender: Any) {
        if let error = validateField() {
            showError(error)
        } else {
            let firstName = firstNameTextField.text!
            let lastName = lastNameTextField.text!
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                if err != nil {
                    self.errorLabel.text = "Creating new user unsuccessful. Error: \(err!.localizedDescription)"
                    return
                } else {
                    if let uid = result?.user.uid {
                        let db = Firestore.firestore()
                        db.collection("users").document(uid).setData(["first_name": firstName, "last_name": lastName])
                    }
                    UserDefaults.standard.isLoggedIn = true
                    App.shared.transitionToTableView()
                }
            }
            
        }
    }
    
    @IBAction func tappedCancel(_ sender: Any) {
//        App.shared.switchToMain()
        dismiss(animated: true, completion: nil)
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
