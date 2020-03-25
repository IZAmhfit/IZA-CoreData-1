//
//  Cars-viewcontrollers.swift
//  IZA-CoreData-1
//
//  Created by Martin Hruby on 24/03/2020.
//  Copyright © 2020 Martin Hruby FIT. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MHCoreData

// --------------------------------------------------------------------
// Pred-definovane VC nad tabulkou aut
extension Car {
    // detail
    var detailVC: CarDetailTable { CarDetailTable.Detail(forCar: self) }
    
    // normalni seznam s moznosti +, editace detailu
    static var listVC: CarsEvidence { CarsEvidence.List(.listOfElements) }
    
    // seznam pro vyber objektu, explicitni predicate
    static var selectVCAvailable: CarsEvidence {
        //
        CarsEvidence.List(.selectionFromElements, predicate: Car._notHiredPredicate)
    }
}


// --------------------------------------------------------------------
// programem generovana bunka
class CarBasicCell: MHTableCell {
    //
    override func selfConfig(with: Any) {
        //
        guard let _obj = with as? Car else { fatalError() }
        
        //
        textLabel?.text = _obj.presentType
        detailTextLabel?.text = _obj.presentSPZ
    }
}

// --------------------------------------------------------------------
// bunka stylizovana v Interface-builderu
class CarNIBCell: MHTableCell {
    // a klasicky, jeji outlety
    @IBOutlet var vyrobce: UILabel!
    @IBOutlet var model: UILabel!
    @IBOutlet var SPZ: UILabel!
    @IBOutlet var najeto: UILabel!
    @IBOutlet var pronajato: UILabel!
    
    //
    @IBOutlet var pic: UIImageView!
    
    // metadata o strukture bunky v NIB a jeji reuse-id
    static let NIB = UINib(nibName: "CarNIBCell", bundle: nil)
    static let cellPrototype = "cellCar"
    
    //
    override func selfConfig(with: Any) {
        //
        guard let _obj = with as? Car else { fatalError() }
        
        //
        let __vyrobce = _obj.brand ?? ""
        let __model = _obj.type ?? ""
        let __spz = _obj.numberplate ?? ""
        let __kms = String(_obj.kms)
        let __hired = (_obj.currentHire == nil) ? "volné" : _obj.currentHire!.customer!.name!
        
        //
        vyrobce.text = "Výrobce: \(__vyrobce)"
        model.text = "Model: \(__model)"
        SPZ.text = "SPZ: \(__spz)"
        najeto.text = "Km: \(__kms)"
        pronajato.text = "Stav: \(__hired)"
        
        //
        pic.image = pejsek
    }
}


// --------------------------------------------------------------------
// Tabulka pro zobrazeni detailu nad Car
class CarDetailTable : MHDetailTable {
    // ... to je on
    var car: Car!
    
    // konstrukce
    static func Detail(forCar: Car) -> CarDetailTable {
        //
        let table = CarDetailTable(sections: [])
        
        //
        table.car = forCar
        
        //
        return table
    }
    
    // z toho se budou generovat bunky pro statickou tabulku
    @MHPublished(label: "Výrobce", defaultValue: "vyrobce") var brand
    @MHPublished(label: "Model", defaultValue: "model") var type
    @MHPublished(label: "SPZ", defaultValue: "1B1-1234") var spz
    
    // jedna sekce
    override var definedSections: [MHSectionDriver] {
        //
        [MHSectionDriver(staticCells:  [_brand.asERow, _type.asERow, _spz.asERow])]
    }
    
    // zprava od MHTable, kdyz VC konci, aktualizace objektu
    override func buttonOKAction() {
        //
        car.brand = brand
        car.type = type
        car.numberplate = spz
        
        APP().saveContext()
    }
    
    // inicializace obsahu bunek
    override func detailStarted() {
        //
        brand = car.brand ?? ""
        type = car.type ?? ""
        spz = car.numberplate ?? ""
    }
}


// --------------------------------------------------------------------
// vice-ucelova tabulka pro seznam aut
class CarsEvidence: MHTable {
    // ----------------------------------------------------------------
    //
    override func event(selectedObject: Any?, section: MHSectionDriver,
                        ip: IndexPath)
    {
        //
        guard let _car = selectedObject as? Car else {
            //
            return
        }
        
        // podle ucelu tabulky, bud se ukoncim s predanim vysledku
        if config.purpose == .selectionFromElements {
            //
            quitMe(responseToDelegate: .selected(_car))
        } else {
            // nebo zanorim VC s detailem
            push(_car.detailVC)
        }
    }
    
    // ----------------------------------------------------------------
    // obsluha tlacitka +
    override func buttonAddAction() {
        // alokuju novy objet
        let nc = MOC().allocCar()
        
        //
        nc.brand = "neznama znacka"
        nc.type = "neznamy model"
        nc.numberplate = "dddd"
        nc.kms = 0
        
        // a hned zanorim VC s detailem
        push(nc.detailVC);
    }
    
    // ----------------------------------------------------------------
    // konstrukce tabulky
    static func List(_ purpose: MHTablePurpose,
                     predicate: NSPredicate? = nil) -> CarsEvidence
    {
        //
        let fetchRequest = Car.basicFRCFetch
        
        // se zadanym predikatem (bez, hired, notHired)
        fetchRequest.predicate = predicate
        
        // volba typu bunky...
        let __CELL = CarNIBCell.cellPrototype
        
        // FRC
        let frc = MHFRC<Car>(moc: MOC(), fetchRequest)
        let frcDatasource = MHFRCSectionDriver(frc, cellPrototype: __CELL)!
        
        //
        var cfg = MHTableConfig(forPurpose: purpose)
        
        // poznamka pro MHTable, aby bunkam s timto prototypem
        // daval vetsi vysku bunky
        cfg.cellHeight[CarNIBCell.cellPrototype] = 120
    
        //
        let table = CarsEvidence(sections: [frcDatasource], cfg: cfg)
        
        // jeden typ bunky
        table.tableView.register(CarBasicCell.self,
                                 forCellReuseIdentifier: "car")
        
        // druhy ...
        table.tableView.register(CarNIBCell.NIB,
                                 forCellReuseIdentifier: CarNIBCell.cellPrototype)
        
        
        //
        return table
    }
}
