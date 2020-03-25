//
//  Hire-VC.swift
//  IZA-CoreData-1
//
//  Created by Martin Hruby on 25/03/2020.
//  Copyright © 2020 Martin Hruby FIT. All rights reserved.
//

import Foundation
import UIKit
import MHCoreData


// --------------------------------------------------------------------
// Modul(tab) pro zadani pronajmu auta
// 1) vybere se auto
// 2) vybere se zakaznik
// 3) provede se datova operace
class CarHire: MHDetailTable {
    //
    static let _empty = "---"
    
    // ----------------------------------------------------------------
    // z tehle polozek budu generovat staticke bunky tabulky
    @MHPublished(label: "Vyber zákazníka", defaultValue: _empty)
    var selectedCustomer
    
    //
    @MHPublished(label: "Vyber auto", defaultValue: _empty)
    var selectedCar
    
    @MHPublished(label: "Pronajmi", defaultValue: "")
    var dohire
    
    // ----------------------------------------------------------------
    // stav nacitani informaci
    var __selectedCar: Car?
    var __selectedCustomer: Customer?
    
    // ----------------------------------------------------------------
    // konfigurace sekci pro MHTable
    override var definedSections: [MHSectionDriver] {
        //
        [
            //
            MHSectionDriver(staticCells: [_selectedCustomer.asRow],
                            header: "Volba zákazníka"),
            //
            MHSectionDriver(staticCells: [_selectedCar.asRow],
                            header: "Volba auta"),
            //
            MHSectionDriver(staticCells: [_dohire.asRow],
                            header: "Akce")
        ]
    }
    
    // ----------------------------------------------------------------
    // tuto zpravu dostavam od spustenych VC na vyber car/customer
    override func vcDelegationMessage(from: MHVCDelegation,
                                      arg: MHVCDelegationReturn)
    {
        // pokud je zprava o tom, ze doslo k vyberu...
        // do _X vcucni obsah case(Any)
        if case let .selected(_X) = arg {
            // lze pretypovat na ...
            if let _car = _X as? Car {
                // zapise se do bunky, rightside
                selectedCar = _car.presentSPZ
                // ...
                __selectedCar = _car
            }
            
            // ... podobne
            if let _customer = _X as? Customer {
                // ...
                selectedCustomer = _customer.name!
                // ...
                __selectedCustomer = _customer
            }
        }
    }
    
    // ----------------------------------------------------------------
    // spust vc
    func run(_ vc: MHTable) {
        // nastavuju sebe na vcdelegata, tj pak dostanu zpravu
        // o vybrane polozce
        vc.vcDelegate = self
        
        // spusteni vc pres navigation-vc
        // slo by i modalne
        // present(vc, animated: true)
        // pak je treba ale nejak zajistit moznost ukoncit VC bez
        // navratove hodnoty
        push(vc)
    }
    
    // ----------------------------------------------------------------
    // akce....
    func doHireNow() {
        // je vsechno definovano, pak
        if let _aCar = __selectedCar, let _aCust = __selectedCustomer {
            // proved akci v modelu. Pokud vyjde, pak
            if MOC().hireACar(car: _aCar, by: _aCust) != nil {
                // uloz db
                APP().saveContext()
                
                // resetuj
                __selectedCustomer = nil; __selectedCar = nil
                selectedCustomer = CarHire._empty; selectedCar = CarHire._empty
            }
        }
    }
    
    // ----------------------------------------------------------------
    // zprava od MHTable
    override func event(selected: MHSectionDriver, ip: IndexPath) {
        //
        switch ip.section {
        case 0:
            run(Customer.selectVC)
        case 1:
            run(Car.selectVCAvailable)
        case 2:
            doHireNow()
        default:
            ()
        }
    }
    
    //
    static func hire() -> CarHire {
        //
        return CarHire(sections: [])
    }
}


// --------------------------------------------------------------------
// Modul vraceni auta
class CarDrop: MHTable {
    // ----------------------------------------------------------------
    // zprava od MHTable, zvolil jsem nejaky objekt
    override func event(selectedObject: Any?, section: MHSectionDriver,
                        ip: IndexPath)
    {
        // ...
        guard let _car = selectedObject as? Car else {
            //
            return
        }
        
        // zichr je zichr, ma auto skutecne nastaveno ...
        guard let _hired = _car.currentHire else {
            //
            return ;
        }
        
        // operace v modelu
        if MOC().dropACar(car: _car, hired: _hired) {
            //
            APP().saveContext()
        }
    }
    
    // ----------------------------------------------------------------
    // konfigurace VC
    static func List() -> CarDrop
    {
        // sestavim fetch-req
        let fetchRequest = Car.basicFRCFetch
        
        // ... pouze pronajata auta
        fetchRequest.predicate = Car._hiredPredicate
        
        // konfigurace FRC section driveru
        let frc = MHFRC<Car>(moc: MOC(), fetchRequest)
        let frcDatasource = MHFRCSectionDriver(frc, cellPrototype: "car")!
        
        // tabulka
        let table = CarDrop(sections: [frcDatasource])
        
        // registrace cell prototype
        table.tableView.register(CarBasicCell.self,
                                 forCellReuseIdentifier: "car")
        
        //
        return table
    }
}
