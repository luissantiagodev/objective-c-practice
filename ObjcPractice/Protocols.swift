//
//  Protocols.swift
//  ObjcPractice
//
//  Created by Luis Santiago on 22/02/21.
//

import Foundation

@objc
protocol CurrencyListener {
    func onCurrencySelected(country : Country)
}
