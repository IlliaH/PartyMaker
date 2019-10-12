//
//  ViewController.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-10-07.
//  Copyright © 2019 711Development. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    let apiUrl = "https://partymakerbhm.azurewebsites.net/api/auth/login"
    
    @IBOutlet weak var LoginTextField: UITextField!
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func LoginButtonOnTapped(_ sender: UIButton) {
        
       guard let url = URL(string: apiUrl) else {return}
       var request = URLRequest(url: url)
       request.httpMethod = "POST"
       request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
       request.httpBody = "email=\(LoginTextField.text!)&password=\(PasswordTextField.text!)&remember_me=false".data(using: .utf8)
       
       let session = URLSession.shared
       session.dataTask(with: request, completionHandler: {(data, response, error) in
           if let response = response {
               print(response)
           }
           
        // Parse JSON and print in console
           if let data = data {
               do {
                   let json = try JSONSerialization.jsonObject(with: data, options: [])
                   print(json)
               } catch {
                   print(error)
               }
           }
       }).resume()
        
    }
    
    
    

}

