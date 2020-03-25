//
//  cd-cars.swift
//  IZA-CoreData-1
//
//  Created by Martin Hruby on 18/03/2020.
//  Copyright © 2020 Martin Hruby FIT. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import MHCoreData

// --------------------------------------------------------------------
//
extension Identification {
    // allocCar(), allocCustomer()
    convenience init(initialized context: NSManagedObjectContext) {
        // nejprve designovany init nad entitou
        self.init(context: context)
        
        // ted se doplni par dat
        self.dateCreated = Date()
        self.idCode = UUID().uuidString
    }
}

// --------------------------------------------------------------------
//
let pejsek = UIImage(named:"pejsek.jpg")

// --------------------------------------------------------------------
//
extension Car : MHFetchable {
    // ----------------------------------------------------------------
    //
    var presentType: String { (brand ?? "??") + "-" + (type ?? "??") }
    var presentSPZ: String { numberplate ?? "not-set" }
    var presentPic: UIImage { pejsek! }
    
    //
    public static var frcBasicKey: AttributeName { "numberplate" }
    
    //
    override public var description: String { presentSPZ }
    
    // ----------------------------------------------------------------
    //
    static let _hiredPredicate = NSPredicate(format: "currentHire != nil")
    static let _notHiredPredicate = NSPredicate(format: "currentHire = nil")
}


// --------------------------------------------------------------------
//
extension Customer : MHFetchable {
    //
    public static var frcBasicKey: AttributeName { "name" }
}
