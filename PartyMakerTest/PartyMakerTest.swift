//
//  PartyMakerTests.swift
//  PartyMakerTests
//
//  Created by  Ilia Goncharenko on 2019-12-02.
//  Copyright © 2019 711Development. All rights reserved.
//

import XCTest
 
@testable import PartyMaker

class PartyMakerTests: XCTestCase {
    
    func testGetEventsPositive() {
        // Setup our objects
        let session = URLSessionMock()
        let manager = EventServiceTest(session: session)

        var eventShort = [EventShort]()
        eventShort.append(EventShort())
        eventShort.append(EventShort())
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        let eventShortSerialized = try! jsonEncoder.encode(eventShort)
        // Create data and tell the session to always return it
        
        session.data = eventShortSerialized

        // Create a URL (using the file path API to avoid optionals)
        let url = URL(fileURLWithPath: "url")
        
        let expectedResult = ServiceError.ServerMessage("Success")

        // Perform the request and verify the result
        var result: ServiceError?
        manager.getEvents(from: url) { (events, error) in
            if let error = error {
                result = .NoResponseFromServer
            }else if events?.first == nil {
                result = .NoResponseFromServer
            } else {
                result = .ServerMessage("Success")
            }
        }
        XCTAssertEqual(expectedResult, result)
    }
    
    func testGetEventsNegative() {
        // Setup our objects
        let session = URLSessionMock()
        let manager = EventServiceTest(session: session)

        // Create a URL (using the file path API to avoid optionals)
        let url = URL(fileURLWithPath: "url")
        
        let expectedResult = ServiceError.NoResponseFromServer

        // Perform the request and verify the result
        var result: ServiceError?
        manager.getEvents(from: url) { (events, error) in
            if let error = error {
                result = .NoResponseFromServer
            }else if events?.first == nil {
                result = .NoResponseFromServer
            } else {
                result = .ServerMessage("Success")
            }
        }
        XCTAssertEqual(expectedResult, result)
    }
    
    func testCreateEventPositive() {
        // Setup our objects
        let session = URLSessionMock()
        let manager = EventServiceTest(session: session)
        
        let event = Event()
        event.id = 1
        event.name = "Commons"
        event.description = "Cool party"
        event.startDate = "07/11/2019"
        event.endDate = "08/11/2019"
        event.pictureUrl = "url"
        event.latitude = 37.363949
        event.longitude = -121.928940
        event.isPrivate = false
        event.ageCategoryId = 2
        event.eventTypeId = 3
        event.numberOfPeople = 10
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        let eventSerialized = try! jsonEncoder.encode(event)
        // Create data and tell the session to always return it
        
        session.data = eventSerialized
        // Create a URL (using the file path API to avoid optionals)
        let url = URL(fileURLWithPath: "url")
        
        let expectedResult = event
        var result : Event?
        manager.createEvent(from: url, event: event) { (event, error) in
            if event != nil {
                result = event
            }else {
                result = Event()
            }
        }
        XCTAssertEqual(expectedResult, result)
    }
    
    func testCreateEventNegative() {
        // Setup our objects
        let session = URLSessionMock()
        let manager = EventServiceTest(session: session)
        
        let event = Event()
        event.id = 1
        event.name = "Commons"
        event.description = "Cool party"
        event.startDate = "07/11/2019"
        event.endDate = "08/11/2019"
        event.pictureUrl = "url"
        event.latitude = 37.363949
        event.longitude = -121.928940
        event.isPrivate = false
        event.ageCategoryId = 2
        event.eventTypeId = 3
        event.numberOfPeople = 10

        // Create a URL (using the file path API to avoid optionals)
        let url = URL(fileURLWithPath: "url")
        
        let expectedResult = Event()
        var result : Event?
        manager.createEvent(from: url, event: event) { (event, error) in
            if event != nil {
                result = event
            }else {
                result = Event()
            }
        }
        XCTAssertEqual(expectedResult, result)
    }
    
    func testGetAgeCategoriesPositive() {
        // Setup our objects
        let session = URLSessionMock()
        let manager = CategoryServiceTest(session: session)
        
        var ageCategoryOne = AgeCategory()
        ageCategoryOne.id = 1
        ageCategoryOne.name = "Adults"
        var ageCategoryTwo = AgeCategory()
        ageCategoryTwo.id = 2
        ageCategoryTwo.name = "Teenagers"
        
        let ageCategories = [ageCategoryOne, ageCategoryTwo]
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        let ageCategoriesSerialized = try! jsonEncoder.encode(ageCategories)
        // Create data and tell the session to always return it
        session.data = ageCategoriesSerialized
        // Create a URL (using the file path API to avoid optionals)
        let url = URL(fileURLWithPath: "url")
        let expectedResult = ageCategories
        var result = [AgeCategory]()
        manager.getAgeCategories(from: url) { (ageCategories, error) in
            if let ageCategories = ageCategories {
                result = ageCategories
            }
        }
        XCTAssertEqual(expectedResult, result)
    }
    
    func testGetAgeCategoriesNegative() {
        // Setup our objects
        let session = URLSessionMock()
        let manager = CategoryServiceTest(session: session)
        
        var ageCategoryOne = AgeCategory()
        ageCategoryOne.id = 1
        ageCategoryOne.name = "Adults"
        var ageCategoryTwo = AgeCategory()
        ageCategoryTwo.id = 2
        ageCategoryTwo.name = "Teenagers"
        
        // Create a URL (using the file path API to avoid optionals)
        let url = URL(fileURLWithPath: "url")
        let expectedResult = [AgeCategory]()
        var result = [AgeCategory]()
        manager.getAgeCategories(from: url) { (ageCategories, error) in
            if let ageCategories = ageCategories {
                result = ageCategories
            }
        }
        XCTAssertEqual(expectedResult, result)
    }
    
    func testGetEventTypesPositive() {
        // Setup our objects
        let session = URLSessionMock()
        let manager = CategoryServiceTest(session: session)
        
        var eventTypeOne = EventType()
        eventTypeOne.id = 1
        eventTypeOne.name = "Cocktails"
        var eventTypeTwo = EventType()
        eventTypeTwo.id = 2
        eventTypeTwo.name = "Dancing"
        
        let eventTypes = [eventTypeOne, eventTypeTwo]
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        let eventTypesSerialized = try! jsonEncoder.encode(eventTypes)
        session.data = eventTypesSerialized
        let url = URL(fileURLWithPath: "url")
        
        let expectedResult = eventTypes
        var result = [EventType]()
        manager.getEventTypes(from: url) { (eventTypes, error) in
            if let eventTypes = eventTypes {
                result = eventTypes
            }
        }
        XCTAssertEqual(expectedResult, result)
    }
    
    func testGetEventTypesNegative() {
        // Setup our objects
        let session = URLSessionMock()
        let manager = CategoryServiceTest(session: session)
        
        var eventTypeOne = EventType()
        eventTypeOne.id = 1
        eventTypeOne.name = "Cocktails"
        var eventTypeTwo = EventType()
        eventTypeTwo.id = 2
        eventTypeTwo.name = "Dancing"
        
        let eventTypes = [eventTypeOne, eventTypeTwo]

        let url = URL(fileURLWithPath: "url")
        
        let expectedResult = [EventType]()
        var result = [EventType]()
        manager.getEventTypes(from: url) { (eventTypes, error) in
            if let eventTypes = eventTypes {
                result = eventTypes
            }
        }
        XCTAssertEqual(expectedResult, result)
    }
    
    func testRegisterPositive() {
        // Setup our objects
        let session = URLSessionMock()
        let manager = UserServiceTest(session: session)
        
        let user = User()
        user.id = 1
        user.firstName = "FirstName"
        user.lastName = "LastName"
        user.nickname = "Nickname"
        user.email = "Email"
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        let userSerialized = try! jsonEncoder.encode(user)
        session.data = userSerialized
        let url = URL(fileURLWithPath: "url")
        
        var result : Error?
        
        manager.register(from: url, nickname: user.nickname!, firstName: user.firstName!, lastName: user.lastName!, email: user.email!, password: "******", passwordConfirm: "******") { (error) in
            if let error = error {
                result = error
            }
        }
        // if nil test succeeded
        XCTAssertNil(result)
    }
    
    func testRegisterNegative() {
        // Setup our objects
        let session = URLSessionMock()
        let manager = UserServiceTest(session: session)
        
        let user = User()
        user.id = 1
        user.firstName = "FirstName"
        user.lastName = "LastName"
        user.nickname = "Nickname"
        user.email = "Email"
        
        let url = URL(fileURLWithPath: "url")
        
        var result : Error?
        
        manager.register(from: url, nickname: user.nickname!, firstName: user.firstName!, lastName: user.lastName!, email: user.email!, password: "******", passwordConfirm: "******") { (error) in
            if let error = error {
                result = error
            }
        }
        // if not nil test succeeded
        XCTAssertNotNil(result)
    }
    
    func testUpdatePositive(){
        // Setup our objects
        let session = URLSessionMock()
        let manager = UserServiceTest(session: session)
        
        let user = User()
        user.id = 1
        user.firstName = "FirstName"
        user.lastName = "LastName"
        user.nickname = "Nickname"
        user.email = "Email"
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        let userSerialized = try! jsonEncoder.encode(user)
        session.data = userSerialized
        let url = URL(fileURLWithPath: "url")
        var result : Error?
        
        manager.update(from: url, email: user.email!, nickname: user.nickname!, pictureUrl: "pictureUrl") { (error) in
            if let error = error {
                result = error
            }
        }
        // if nil test succeeded
        XCTAssertNil(result)
    }
    
    func testUpdateNegative(){
        // Setup our objects
        let session = URLSessionMock()
        let manager = UserServiceTest(session: session)
        
        let user = User()
        user.id = 1
        user.firstName = "FirstName"
        user.lastName = "LastName"
        user.nickname = "Nickname"
        user.email = "Email"

        let url = URL(fileURLWithPath: "url")
        var result : Error?
        
        manager.update(from: url, email: user.email!, nickname: user.nickname!, pictureUrl: "pictureUrl") { (error) in
            if let error = error {
                result = error
            }
        }
        // if not nil test succeeded
        XCTAssertNotNil(result)
    }
    
    func testUpdatePasswordPositive() {
        // Setup our objects
        let session = URLSessionMock()
        let manager = UserServiceTest(session: session)
        
        let user = User()
        user.id = 1
        user.firstName = "FirstName"
        user.lastName = "LastName"
        user.nickname = "Nickname"
        user.email = "Email"
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        let userSerialized = try! jsonEncoder.encode(user)
        session.data = userSerialized
        let url = URL(fileURLWithPath: "url")
        var result : Error?
        
        manager.updatePassword(from: url, newPassword: "******", oldPassword: "******") { (error) in
            if let error = error {
                result = error
            }
        }
        // if nil test succeeded
        XCTAssertNil(result)
    }
    
    func testUpdatePasswordNegative() {
        // Setup our objects
        let session = URLSessionMock()
        let manager = UserServiceTest(session: session)
        
        let user = User()
        user.id = 1
        user.firstName = "FirstName"
        user.lastName = "LastName"
        user.nickname = "Nickname"
        user.email = "Email"
 
        let url = URL(fileURLWithPath: "url")
        var result : Error?
        
        manager.updatePassword(from: url, newPassword: "******", oldPassword: "******") { (error) in
            if let error = error {
                result = error
            }
        }
        // if not nil test succeeded
        XCTAssertNotNil(result)
    }
    
    func testGetCurrentUserPositive() {
        // Setup our objects
        let session = URLSessionMock()
        let manager = UserServiceTest(session: session)
        
        let user = User()
        user.id = 1
        user.firstName = "FirstName"
        user.lastName = "LastName"
        user.nickname = "Nickname"
        user.email = "Email"
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        let userSerialized = try! jsonEncoder.encode(user)
        session.data = userSerialized
        let url = URL(fileURLWithPath: "url")
        var result : ServiceError?
        let expectedResult = ServiceError.ServerMessage("Success")
        
        manager.getCurrentUser(from: url) { (user, error) in
            if let error = error {
                result = ServiceError.NoResponseFromServer
            }
            if let user = user {
                if user == user {
                    result = ServiceError.ServerMessage("Success")
                }
            }else {
                result = ServiceError.NoResponseFromServer
            }
        }
        XCTAssertEqual(expectedResult, result)
    }
    
    func testGetCurrentUserNegative() {
        // Setup our objects
        let session = URLSessionMock()
        let manager = UserServiceTest(session: session)
        
        let user = User()
        user.id = 1
        user.firstName = "FirstName"
        user.lastName = "LastName"
        user.nickname = "Nickname"
        user.email = "Email"
        
        let url = URL(fileURLWithPath: "url")
        var result : ServiceError?
        let expectedResult = ServiceError.NoResponseFromServer
        
        manager.getCurrentUser(from: url) { (user, error) in
            if let error = error {
                result = ServiceError.NoResponseFromServer
            }
            if let user = user {
                if user == user {
                    result = ServiceError.ServerMessage("Success")
                }
            }else {
                result = ServiceError.NoResponseFromServer
            }
        }
        XCTAssertEqual(expectedResult, result)
    }
    
    func testLoginPositive() {
        // Setup our objects
        let session = URLSessionMock()
        let manager = AuthServiceTest(session: session)
        let url = URL(fileURLWithPath: "url")
        let jsonEncoder = JSONEncoder()
        let accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IjEiLCJuYmYiOjE1NzA0ODI5ODAsImV4cCI6MTU3MDQ4NjU4MCwiaWF"
        let serverResponseImitated : [String : String] = ["access_token" : accessToken]
        jsonEncoder.outputFormatting = .prettyPrinted
        let accessTokenSerialized = try! jsonEncoder.encode(serverResponseImitated)
        session.data = accessTokenSerialized
        
        var user = User()
        user.email = "email"
        
        let expectedResult = ServiceError.ServerMessage("Success")
        var result : ServiceError?
        
        manager.Login(from: url, email: user.email!, password: "*****", remember_me: true) { (token, error) in
            if let token = token {
                result = ServiceError.ServerMessage("Success")
            }else {
                result = ServiceError.TokenNotFound
            }
        }
        XCTAssertEqual(expectedResult, result)
    }
    
    func testLoginNegative() {
        // Setup our objects
        let session = URLSessionMock()
        let manager = AuthServiceTest(session: session)
        let url = URL(fileURLWithPath: "url")
        
        var user = User()
        user.email = "email"
        
        let expectedResult = ServiceError.TokenNotFound
        var result : ServiceError?
        
        manager.Login(from: url, email: user.email!, password: "*****", remember_me: true) { (token, error) in
            if let token = token {
                result = ServiceError.ServerMessage("Success")
            }else {
                result = ServiceError.TokenNotFound
            }
        }
        XCTAssertEqual(expectedResult, result)
    }
    
    func testGoogleLoginPositive() {
        // Setup our objects
        let session = URLSessionMock()
        let manager = AuthServiceTest(session: session)
        let url = URL(fileURLWithPath: "url")
        let jsonEncoder = JSONEncoder()
        let googleToken = "aegljnkwgvnmp4o3nvmnlmlewmknevkwINEvlewobvra"
        let accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IjEiLCJuYmYiOjE1NzA0ODI5ODAsImV4cCI6MTU3MDQ4NjU4MCwiaWF"
        let serverResponseImitated : [String : String] = ["access_token" : accessToken]
        jsonEncoder.outputFormatting = .prettyPrinted
        let accessTokenSerialized = try! jsonEncoder.encode(serverResponseImitated)
        session.data = accessTokenSerialized
        
        let expectedResult = ServiceError.ServerMessage("Success")
        var result : ServiceError?
        
        manager.GoogleLogin(from: url, token: googleToken) { (token, error) in
            if let token = token {
                result = ServiceError.ServerMessage("Success")
            }else {
                result = ServiceError.TokenNotFound
            }
        }
        XCTAssertEqual(expectedResult, result)
    }
    
    func testGoogleLoginNegative() {
        // Setup our objects
        let session = URLSessionMock()
        let manager = AuthServiceTest(session: session)
        let url = URL(fileURLWithPath: "url")
        let jsonEncoder = JSONEncoder()
        let googleToken = "aegljnkwgvnmp4o3nvmnlmlewmknevkwINEvlewobvra"
        
        let expectedResult = ServiceError.TokenNotFound
        var result : ServiceError?
        
        manager.GoogleLogin(from: url, token: googleToken) { (token, error) in
            if let token = token {
                result = ServiceError.ServerMessage("Success")
            }else {
                result = ServiceError.TokenNotFound
            }
        }
        XCTAssertEqual(expectedResult, result)
    }
    
    func testUploadFilePositive() {
        // Setup our objects
        let session = URLSessionMock()
        let manager = StorageServiceTest(session: session)
        let url = URL(fileURLWithPath: "url")
        let image = UIImage(named: "PartyMaker")?.pngData()
        let pictureUrl = "testUrl"
        let serverResponseImitated : [String : String] = ["url" : pictureUrl]
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        let pictureUrlSerialized = try! jsonEncoder.encode(serverResponseImitated)
        session.data = pictureUrlSerialized
        
        let expectedResult = ServiceError.ServerMessage("Success")
        var result : ServiceError?
        
        manager.uploadFile(from: url, picture: image!) { (pictureUrl, error) in
            if let error = error {
                result = ServiceError.ServerMessage("Unexpected error")
            }
            if let pictureUrl = pictureUrl{
                result = ServiceError.ServerMessage("Success")
            } else {
                result = ServiceError.NoResponseFromServer
            }
        }
        XCTAssertEqual(expectedResult, result)
    }
    
    func testUploadFileNegative() {
        // Setup our objects
        let session = URLSessionMock()
        let manager = StorageServiceTest(session: session)
        let url = URL(fileURLWithPath: "url")
        let image = UIImage(named: "PartyMaker")?.pngData()
        
        let expectedResult = ServiceError.NoResponseFromServer
        var result : ServiceError?
        
        manager.uploadFile(from: url, picture: image!) { (pictureUrl, error) in
            if let error = error {
                result = ServiceError.ServerMessage("Unexpected error")
            }
            if let pictureUrl = pictureUrl{
                result = ServiceError.ServerMessage("Success")
            } else {
                result = ServiceError.NoResponseFromServer
            }
        }
        XCTAssertEqual(expectedResult, result)
    }
    
    func testDownloadFilePositive() {
        // Setup our objects
        let session = URLSessionMock()
        let manager = StorageServiceTest(session: session)
        let url = URL(fileURLWithPath: "url")
        let pictureUrl = "testUrl"
        let imageData = UIImage(named: "PartyMaker")?.pngData()
        session.data = imageData
        
        let expectedResult = ServiceError.ServerMessage("Success")
        var result : ServiceError?
        
        manager.downloadFile(from: url, pictureUrl: pictureUrl) { (data, error) in
            if let error = error {
                result = ServiceError.NoResponseFromServer
            }
            if let data = data {
                result = ServiceError.ServerMessage("Success")
            } else {
                result = ServiceError.NoResponseFromServer
            }
            XCTAssertEqual(expectedResult, result)
        }
    }
    
    func testDownloadFileNegative() {
        // Setup our objects
        let session = URLSessionMock()
        let manager = StorageServiceTest(session: session)
        let url = URL(fileURLWithPath: "url")
        let pictureUrl = "testUrl"
        
        let expectedResult = ServiceError.NoResponseFromServer
        var result : ServiceError?
        
        manager.downloadFile(from: url, pictureUrl: pictureUrl) { (data, error) in
            if let error = error {
                result = ServiceError.NoResponseFromServer
            }
            if let data = data {
                result = ServiceError.ServerMessage("Success")
            } else {
                result = ServiceError.NoResponseFromServer
            }
            XCTAssertEqual(expectedResult, result)
        }
    }

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}
