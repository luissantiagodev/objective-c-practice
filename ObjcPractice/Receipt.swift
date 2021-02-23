//
//  Course.swift
//  ObjcPractice
//
//  Created by Luis Santiago on 20/02/21.
//

import Foundation
import class Foundation.NSNumber


@objc(Receipt)
class Receipt: NSObject{
    
    @objc
    var provider : String?
    
    @objc
    var amount : NSNumber?
    
    @objc
    var comment : String?
    
    @objc
    var emission_date : String?
    
    @objc
    var currency_code : String?
    

    @objc
    func parse(data : NSDictionary)-> Receipt {
        
        provider = data["provider"] as? String ?? "No provider"
        comment = data["comment"] as? String ?? "No comment"
        emission_date = data["emission_date"] as? String ?? "No Emission date"
        currency_code = data["currency_code"] as? String ?? "No Currency Code"
        return self
    }
}

