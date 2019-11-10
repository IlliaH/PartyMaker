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
    
    var presenter: LoginPresenterProtocol!
    var configurator: LoginConfiguratorProtocol = LoginConfigurator()
    var loader : FillableLoader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configurator.configure(with: self)
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        AppDelegate.visibleViewController = self
        
        // Autimatically sign in the user
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    
    @IBAction func LoginButtonOnTapped(_ sender: UIButton) {
        
        presenter.emailValueChanged(to: LoginTextField.text)
        presenter.passwordValueChanged(to: PasswordTextField.text)
        presenter.loginButtonClicked()
       //TODO: fix this
        performSegue(withIdentifier: "goToTabBar", sender: sender)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func registerButtonOnTapped(_ sender: UIButton) {
        presenter.router.showRegisterView()
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
}
