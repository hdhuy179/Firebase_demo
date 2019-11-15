//
//  LoginViewController.swift
//  Firebase_demo
//
//  Created by Hoang Dinh Huy on 10/14/19.
//  Copyright © 2019 Hoang Dinh Huy. All rights reserved.
//

import UIKit
import FirebaseAuth

final class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configView()
    }
    
    deinit {
        logger()
    }
    
    private func configView() {
        addEndEditingTapGuesture()
        errorLabel.alpha = 0
        
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
        Utilities.styleFilledButton(cancelButton)
    }
    
    private func validateField() -> String?{
            if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill all the fields"
        }
        
        return nil
    }
    
    @IBAction func tappedLogin(_ sender: Any) {
        if let error = validateField() {
            showError(error)
            return
        } else {
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().signIn(withEmail: email, password: password) {[weak self] result, err in
                guard let strongSelf = self else { return }
                if let err = err {
                    strongSelf.showError("\(err.localizedDescription)")
                    return
                } else {
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
