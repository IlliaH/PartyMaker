//
//  RegisterController.swift
//  PartyMaker
//
//  Created by 8teRnity on 10/21/19.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation
import UIKit

class RegisterController : UIViewController, RegisterViewProtocol {
    
    @IBOutlet weak var ProfileImageView: RoundImageView!
    
    @IBOutlet weak var NicknameTextField: CustomHoshiTextField!
    
    @IBOutlet weak var FirstNameTextField: CustomHoshiTextField!
    
    @IBOutlet weak var LastNameTextField: CustomHoshiTextField!
    
    @IBOutlet weak var EmailTextField: CustomHoshiTextField!
    
    @IBOutlet weak var PasswordTextField: CustomHoshiTextField!
    
    @IBOutlet weak var ConfirmPasswordTextField: CustomHoshiTextField!
    
    var presenter: RegisterPresenterProtocol!
    var configurator: RegisterConfiguratorProtocol = RegisterConfigurator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
    }
    
    
    @IBAction func registerButtonOnTouch(_ sender: UIButton) {
        /*presenter.nicknameValueChanged(to: NicknameTextField.text)
        presenter.firstNameValueChanged(to: FirstNameTextField.text)
        presenter.lastNameValueChanged(to: LastNameTextField.text)
        presenter.emailValueChanged(to: EmailTextField.text)
        presenter.passwordValueChanged(to: PasswordTextField.text)
        presenter.passwordConfirmValueChanged(to: ConfirmPasswordTextField.text)
        presenter.pictureValueChanged(to: ProfileImageView.image)
        
        presenter.registerButtonClicked()*/
        
        let storageService: StorageServiceProtocol = StorageService()
        
        storageService.uploadFile(picture: ProfileImageView.image!.pngData()!) { (url, error) in
            print(url as Any)
        }
    }
}
