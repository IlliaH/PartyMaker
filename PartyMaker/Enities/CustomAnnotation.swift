//
//  CustomAnnotation.swift
//  UserLocation
//
//  Created by  Ilia Goncharenko on 2019-12-01.
//  Copyright © 2019  Ilia Goncharenko. All rights reserved.
//

import Foundation
import MapKit

class CustomAnnotation : NSObject, MKAnnotation {
    var id : Int?
    var title : String?
    var coordinate: CLLocationCoordinate2D
    var image : UIImage?
    
    init(id : Int, title : String, image : UIImage, coordinate : CLLocationCoordinate2D) {
        self.id = id
        self.coordinate = coordinate
        self.title = title
        self.image = image
        super.init()
    }
    
}
