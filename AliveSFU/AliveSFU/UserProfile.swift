//
//  UserProfile.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-11-19.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import Foundation

protocol UserProfile {
    
}

class PersonalDetails: UserProfile {
    internal var firstName: String = ""
    internal var lastName: String = ""
    internal var phoneNumber: String = ""
    internal var gender: Int = -1
    internal var email: String = ""

    required init(firstName: String, lastName: String, gender: Int, phoneNumber: String?, email: String) {
        
    }
}
    
class FitnessDetails: UserProfile {
    internal var heightFeet: Int = -1
    internal var heightInches: Int = -1
    internal var weight: Int = -1
    internal var ageGroup: Int = -1
    internal var fitnessFreq: Int = -1
    internal var personalGoals: Int = -1
    
    required init(heightFeet: Int, heightInches: Int, weight: Double, ageGroup: Int, fitnessFreq: Int, personalGoals: Int) {
        
    }
}
