//
//  PedalShareProducts.swift
//  PedalShare
//
//  Created by Andrew Miller on 06/05/2018.
//  Copyright © 2018 Andrew Miller. All rights reserved.
//

import Foundation

public struct PedalProducts {
    
    public static let tripPurchase_Pedal = "com.andrewmiller167.PedalShare.tripPurchase_Pedal"
    
    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [PedalProducts.tripPurchase_Pedal]
    
    public static let store = IAPHelper(productIds: PedalProducts.productIdentifiers)
    
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
