//
//  Customers-viewcontrollers.swift
//  IZA-CoreData-1
//
//  Created by Martin Hruby on 24/03/2020.
//  Copyright © 2020 Martin Hruby FIT. All rights reserved.
//

import Foundation
import CoreData
import MHCoreData

// --------------------------------------------------------------------
//
extension Customer {
    //
    var detailVC: CustomerDetailTable {
        //
        CustomerDetailTable.Detail(forCustomer: self)
    }
    
    //
    static var listVC: CustomersEvidence {
        //
        CustomersEvidence.List(.listOfElements)
    }
    
    //
    static var selectVC: CustomersEvidence {
        //
        CustomersEvidence.List(.selectionFromElements)
    }
}


// --------------------------------------------------------------------
//
class CustomerBasicCell: MHTableCell {
    //
    override func selfConfig(with: Any) {
        //
        guard let _obj = with as? Customer else { fatalError() }
        
        //
        textLabel?.text = _obj.name ?? "???"
    }
}

// --------------------------------------------------------------------
//
class CustomerDetailTable : MHDetailTable {
    //
    var customer: Customer!
    
    //
    static func Detail(forCustomer: Customer) -> CustomerDetailTable {
        //
        let table = CustomerDetailTable(sections: [])
        
        //
        table.customer = forCustomer
        
        //
        return table
    }
    
    //
    @MHPublished(label: "Jméno", defaultValue: "Jan Novák") var name
    
    //
    override var definedSections: [MHSectionDriver] {
        //
        [MHSectionDriver(staticCells:  [_name.asERow])]
    }
    
    //
    override func buttonOKAction() {
        //
        customer.name = name
        
        APP().saveContext()
    }
    
    override func detailStarted() {
        //
        name = customer.name ?? "asi jan novak"
    }
}



// --------------------------------------------------------------------
//
class CustomersEvidence: MHTable {
    //
    override func event(selectedObject: Any?, section: MHSectionDriver,
                        ip: IndexPath)
    {
        //
        guard let _customer = selectedObject as? Customer else {
            //
            return
        }
        
        //
        if config.purpose == .selectionFromElements {
            //
            quitMe(responseToDelegate: .selected(_customer))
        } else {
            //
            push(_customer.detailVC)
        }
    }
    
    //
    override func buttonAddAction() {
        //
        let nc = MOC().allocCustomer()
        
        //
        nc.name = "Noname"
        
        //
        push(nc.detailVC);
    }
    
    //
    static func List(_ purpose: MHTablePurpose) -> CustomersEvidence {
        //
        let frc = MHFRC<Customer>(moc: MOC())
        let frcDatasource = MHFRCSectionDriver(frc, cellPrototype: "customer")!
        
        //
        let cfg = MHTableConfig(forPurpose: purpose)
        
        //
        let table = CustomersEvidence(sections: [frcDatasource], cfg: cfg)
        
        //
        table.tableView.register(CustomerBasicCell.self,
                                 forCellReuseIdentifier: "customer")
        
        //
        return table
    }
}

