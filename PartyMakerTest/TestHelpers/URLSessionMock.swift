//
//  URLSessionMock.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-12-02.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

class URLSessionMock : URLSession {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    var data : Data?
    var error : Error?
    
    override func dataTask(with url : URL, completionHandler: @escaping CompletionHandler) -> URLSessionDataTask{
        let data = self.data
        let error = self.error
        
        return URLSessionDataTaskMock {
            completionHandler(data, nil, error)
        }
    }
}
