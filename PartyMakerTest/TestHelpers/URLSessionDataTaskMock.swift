//
//  URLSessionDataTaskMock.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-12-02.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

class URLSessionDataTaskMock : URLSessionDataTask {
    private let closure : () -> Void
    
    init(closure: @escaping ()-> Void){
        self.closure = closure
    }
    
    override func resume() {
        closure()
    }
}
