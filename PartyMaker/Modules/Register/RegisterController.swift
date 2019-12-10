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
    var loader : FillableLoader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        NicknameTextField.returnKeyType = .next
        FirstNameTextField.returnKeyType = .next
        LastNameTextField.returnKeyType = .next
        EmailTextField.returnKeyType = .next
        PasswordTextField.returnKeyType = .next
        ConfirmPasswordTextField.returnKeyType = .done
    }
    
    
    @IBAction func registerButtonOnTouch(_ sender: UIButton) {
        presenter.nicknameValueChanged(to: NicknameTextField.text)
        presenter.firstNameValueChanged(to: FirstNameTextField.text)
        presenter.lastNameValueChanged(to: LastNameTextField.text)
        presenter.emailValueChanged(to: EmailTextField.text)
        presenter.passwordValueChanged(to: PasswordTextField.text)
        presenter.passwordConfirmValueChanged(to: ConfirmPasswordTextField.text)
        presenter.pictureValueChanged(to: ProfileImageView.image)
        
        presenter.registerButtonClicked()
        
    }
    
    
    @IBAction func profilePhotoOnTouched(_ sender: UITapGestureRecognizer) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true) { }
    }
    
    @IBAction func screenOnTouch(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
}

extension RegisterController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
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
    
    
    // Implementation of UIImagePickerDelegate. This function triggers when user has selected an image
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           // Use guard let to get a reference to selected image
           guard let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
           // Save a reference to that image
           ProfileImageView.image = photo
           // Dismiss UIImagePickerController
           self.dismiss(animated: true)
       }
}

extension RegisterController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField:
        UITextField) -> Bool {
        
       if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            return true;
        }
        return false
    }
}
