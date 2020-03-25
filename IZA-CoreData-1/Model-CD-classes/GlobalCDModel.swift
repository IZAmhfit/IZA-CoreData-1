//
//  GlobalCDModel.swift
//  IZA-CoreData-1
//
//  Created by Martin Hruby on 19/03/2020.
//  Copyright © 2020 Martin Hruby FIT. All rights reserved.
//

import Foundation
import CoreData

// --------------------------------------------------------------------
// Datove operace provadime nad MOC, tak celkem dava smysl si o ne
// rozsirit MOC.
// --------------------------------------------------------------------
// Zasada 1: snazte se objekty alokovat na jednom miste v programu
// tj. system metod allocXY()
// Zasada 2: stoji za uvahu uplne nepovazovat MOC() za globalni prvek
// (muzeme obecne uvazovat praci viewcontrolleru v ruznych MOC)
// (lze zatim ignorovat...)
// Zasada 3: ...
extension NSManagedObjectContext {
    // ----------------------------------------------------------------
    // alokace MO a nejake zakladni nastaveni
    func allocCar() -> Car {
        // ted vznika managed-object, FRCy budou reagovat...
        let _car = Car(initialized: self)
        
        // ted SMIME predpokladat, ze kms je vzdy != nil
        _car.kms = 0
        
        //
        _car.numberplate = "not-assigned-yet"
        
        //
        return _car
    }
    
    // ----------------------------------------------------------------
    //
    func allocCustomer() -> Customer {
        //
        let _cust = Customer(initialized: self)
        
        //
        return _cust
    }
    
    // ----------------------------------------------------------------
    //
    func allocHire(car: Car, customer: Customer) -> Hire {
        //
        let _hire = Hire(context: self)
        
        // bez techto atributu objekt nedava prilis smysl
        _hire.car = car
        _hire.customer = customer
        
        //
        return _hire
    }
    
    // ----------------------------------------------------------------
    // operace zabrani auta. Opet se hodi uvaha o vice-vlaknovosti
    // 1) bud jedu v MainThread, nebo 2) zamykam
    func hireACar(car: Car, by: Customer) -> Hire? {
        // pokud je auto zabrano, asi nekdo udelal chybu v UI
        if car.currentHire != nil { return nil }
        
        // ...
        let _hire = allocHire(car: car, customer: by)
        
        // ...
        _hire.dateStarting = Date()
        _hire.kmsStarting = car.kms
        
        // modifikuji "car", nejaky FRC bude reagovat
        car.currentHire = _hire
        
        //
        return car.currentHire
    }
    
    // ----------------------------------------------------------------
    // vrat auto...
    func dropACar(car: Car, hired: Hire) -> Bool {
        // kontrola konzistence pokynu
        assert(car.currentHire == hired)
        
        //
        hired.dateEnding = Date()
        
        // kolik se asi najelo km...
        let _hiredSec = hired.dateStarting!.distance(to: hired.dateEnding!)
        let _kms = Int32(_hiredSec * 1)
        
        //
        hired.kmsEnding = hired.kmsStarting + _kms
        
        // zapis do objektu car, FRCy...
        car.currentHire = nil
        car.kms = hired.kmsEnding
        
        //
        return true
    }
}
