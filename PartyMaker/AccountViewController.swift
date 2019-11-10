//
//  AccountViewController.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-11-09.
//  Copyright © 2019 711Development. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var profileImageView: RoundImageView!
    @IBOutlet weak var firstNameTextField: CustomHoshiTextField!
    @IBOutlet weak var lastNameTextField: CustomHoshiTextField!
    @IBOutlet weak var emailTextField: CustomHoshiTextField!
    @IBOutlet weak var nicknameTextField: CustomHoshiTextField!
    @IBOutlet weak var isPasswordChangedSwitch: UISwitch!
    
    @IBOutlet weak var oldPasswordTextField: CustomHoshiTextField!
    @IBOutlet weak var newPasswordTextField: CustomHoshiTextField!
    
    var presenter : AccountPresenterProtocol!
    var configurator : AccountConfiguratorProtocol = AccountConfigurator()
    
    var loader : FillableLoader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        profileImageView.downloadImageFrom(link: AppDelegate.currentUser!.pictureUrl!, contentMode: .scaleAspectFit)
        firstNameTextField.text = AppDelegate.currentUser?.firstName
        lastNameTextField.text = AppDelegate.currentUser?.lastName
        emailTextField.text = AppDelegate.currentUser?.email
        nicknameTextField.text = AppDelegate.currentUser?.nickname
        
    }
    
    
    @IBAction func saveChangesButtonClicked(_ sender: UIButton) {
        presenter.nicknameValueChanged(to: nicknameTextField.text)
        presenter.emailValueChanged(to: emailTextField.text)
        presenter.oldPasswordValueChanged(to: oldPasswordTextField.text)
        presenter.newPasswordConfirmValueChanged(to: newPasswordTextField.text)
        presenter.pictureValueChanged(to: profileImageView.image)
        
        presenter.saveButtonClicked()
    }
    
    
    @IBAction func passwordSwitchValueChanged(_ sender: UISwitch) {
        presenter.editPassword(isPasswordChanged: sender.isOn)
    }
    
}

extension AccountViewController : AccountViewProtocol {
    func showPassword() {
            oldPasswordTextField.alpha = 1
            newPasswordTextField.alpha = 1
    }
    
    func hidePassword() {
        oldPasswordTextField.alpha = 0
        newPasswordTextField.alpha = 0
    }
    
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
