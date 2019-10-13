//
//  ViewController.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-10-07.
//  Copyright © 2019 711Development. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginController: UIViewController, LoginViewProtocol {

    
    @IBOutlet weak var LoginTextField: UITextField!
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
    var presenter: LoginPresenterProtocol!
    var configurator: LoginConfiguratorProtocol = LoginConfigurator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configurator.configure(with: self)
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        AppDelegate.visibleViewController = self
        
        // Autimatically sign in the user
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
    }

    
    @IBAction func LoginButtonOnTapped(_ sender: UIButton) {
        presenter.emailValueChanged(to: LoginTextField.text)
        presenter.passwordValueChanged(to: PasswordTextField.text)
        presenter.loginButtonClicked()
       
    }
    
    
    

}

