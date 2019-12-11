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
    @IBOutlet weak var LoginTextField: CustomHoshiTextField!
    
    @IBOutlet weak var PasswordTextField: CustomHoshiTextField!
    
    @IBOutlet weak var RememberMeSwitch: UISwitch!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    var presenter: LoginPresenterProtocol!
    var configurator: LoginConfiguratorProtocol = LoginConfigurator()
    var loader : FillableLoader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.LoginTextField.delegate = self
        self.PasswordTextField.delegate = self
        self.LoginTextField.tag = 0
        self.PasswordTextField.tag = 1
        self.LoginTextField.returnKeyType = .next
        self.PasswordTextField.returnKeyType = .done
        // Do any additional setup after loading the view.
        configurator.configure(with: self)
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        AppDelegate.visibleViewController = self
        
        // Autimatically sign in the user
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
    }
    
    @IBAction func LoginButtonOnTapped(_ sender: UIButton) {
        view.endEditing(true)
        presenter.emailValueChanged(to: LoginTextField.text)
        presenter.passwordValueChanged(to: PasswordTextField.text)
        presenter.loginButtonClicked()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        LoginTextField.center.x -= view.bounds.width
        PasswordTextField.center.x += view.bounds.width
        profileImageView.alpha = 0
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, delay: 0.4, options: [], animations: {
            self.LoginTextField.center.x += self.view.bounds.width
            self.PasswordTextField.center.x -= self.view.bounds.width
            self.profileImageView.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func registerButtonOnTapped(_ sender: UIButton) {
        presenter.router.showRegisterView()
    }
    
    
    @IBAction func onScreenTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}

extension LoginController {
    
    func showLoader() {
        DispatchQueue.main.async {
            self.loader = WavesLoader.createLoader(with: LoaderPath.glassPath(), on: self.view)
            guard let loader = self.loader else {return}
                   loader.loaderColor = UIColor.systemPink
                   loader.showLoader()
        }
       }
       
       func hideLoader() {
        DispatchQueue.main.async {
            guard let loader = self.loader else {return}
        loader.removeLoader()
       }
    }
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = Alert.createAlert(title: title, message: message)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension LoginController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            return true;
        }
        return false
    }
}
