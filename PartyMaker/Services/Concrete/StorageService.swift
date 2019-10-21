//
//  StorageService.swift
//  PartyMaker
//
//  Created by 8teRnity on 10/21/19.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

class StorageService : StorageServiceProtocol {
    func uploadFile(picture: Data, completion: @escaping (String?, Error?) -> Void) {
        guard let url = URL(string: "\(AppConstant.API_URL)storage/upload") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let filename = "user-profile.jpg"

        let mimetype = "image/jpg"
        
        let boundary = "Boundary-\(NSUUID().uuidString)"
        
        let body = NSMutableData();

        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendString(picture.base64EncodedString())
        body.appendString("\r\n")

        body.appendString("--\(boundary)--\r\n")

        request.httpBody = body as Data
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
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
                    
                    if let dictionary = json as? [String: Any] {
                        if let message = dictionary["message"] as? String {
                            completion(nil, ServiceError.ServerMessage(message))
                        }
                        else {
                            completion(nil, ServiceError.NoResponseFromServer)
                        }
                    }
                    else {
                        if let pictureUrl = json as? String {
                            completion(pictureUrl, nil)
                        }
                    }
                } catch {
                    print(error)
                    completion(nil, error)
                }
            }
        }).resume()
    }
}

extension NSMutableData {

    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
