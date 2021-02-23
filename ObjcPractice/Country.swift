//
//  Country.swift
//  ObjcPractice
//
//  Created by Luis Santiago on 22/02/21.
//

import Foundation



class Country : NSObject{
    
    @objc
    var currency: String?
    
    @objc
    var name: String?
    
    init(currency: String, name: String) {
        self.currency = currency
        self.name = name
    }
}
