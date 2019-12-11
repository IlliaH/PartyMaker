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
    @IBOutlet weak var scrollView: UIScrollView!
    
    var presenter : AccountPresenterProtocol!
    var configurator : AccountConfiguratorProtocol = AccountConfigurator()
    
    var loader : FillableLoader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        profileImageView.downloadImageFrom(link: AppDelegate.currentUser!.pictureUrl!, contentMode: .scaleAspectFill)
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
    
    
    @IBAction func profileImageOnTouch(_ sender: UITapGestureRecognizer) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true) { }
    }
    
    
    @IBAction func screenOnTouch(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + CGFloat(AppConstant.tabBarInset)
        self.scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
}

extension AccountViewController : AccountViewProtocol {
    func showPassword() {
        view.endEditing(true)
        oldPasswordTextField.isHidden = false
        oldPasswordTextField.drawViewsForRect(oldPasswordTextField.bounds)
        newPasswordTextField.isHidden = false
        newPasswordTextField.drawViewsForRect(newPasswordTextField.bounds)
    }
    
    func hidePassword() {
        view.endEditing(true)
        oldPasswordTextField.isHidden = true
        newPasswordTextField.isHidden = true
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
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = Alert.createAlert(title: title, message: message)
            self.present(alert, animated: true, completion: nil)
        }
    }
}


extension AccountViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    // Implementation of UIImagePickerDelegate. This function triggers when user has selected an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Use guard let to get a reference to selected image
        guard let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        // Save a reference to that image
        profileImageView.image = photo
        // Dismiss UIImagePickerController
        self.dismiss(animated: true)
    }
}

extension AccountViewController : UITextFieldDelegate {
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
