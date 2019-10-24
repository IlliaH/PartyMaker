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
        
        // TO DO: read token from user defaults
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IjEiLCJuYmYiOjE1NzE4ODg2MDgsImV4cCI6MTU3MTg5MjIwOCwiaWF0IjoxNTcxODg4NjA4fQ.uMfGW-THRRAkUoy97BOlNVaxWMHYUkbnRbx6Zf5fYZk"

        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString
        
        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        
        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"profilePicture.png\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(picture)
        
        // End the raw http request data, note that there is 2 extra dash ("-") at the end, this is to indicate the end of the data
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = data
        
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
                        if let url = dictionary["url"] as? String, !url.isEmpty {
                            completion(url, nil)
                        }
                        if let message = dictionary["message"] as? String {
                            completion(nil, ServiceError.ServerMessage(message))
                        }
                        else {
                            completion(nil, ServiceError.NoResponseFromServer)
                        }
                    }
                    else {
                        completion(nil, ServiceError.NoResponseFromServer)
                    }
                } catch {
                    print(error)
                    completion(nil, error)
                }
            }
        }).resume()
    }
}

extension Data {

    /// Append string to Data
    ///
    /// Rather than littering my code with calls to `data(using: .utf8)` to convert `String` values to `Data`, this wraps it in a nice convenient little extension to Data. This defaults to converting using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `Data`.

    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
