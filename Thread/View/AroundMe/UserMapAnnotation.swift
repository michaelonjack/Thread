//
//  UserMapAnnotation.swift
//  Thread
//
//  Created by Michael Onjack on 2/20/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import MapKit

class UserMapAnnotation: NSObject, MKAnnotation {
    var user: User
    var coordinate: CLLocationCoordinate2D
    
    init(user: User) {
        self.user = user
        coordinate = user.location!.coordinate
    }
}
