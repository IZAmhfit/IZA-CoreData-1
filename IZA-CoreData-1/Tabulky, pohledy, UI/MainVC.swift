//
//  MainVC.swift
//  IZA-CoreData-1
//
//  Created by Martin Hruby on 19/03/2020.
//  Copyright © 2020 Martin Hruby FIT. All rights reserved.
//

import Foundation
import UIKit
import MHCoreData


// --------------------------------------------------------------------
// si tu odlozim takovou zkratku....
extension UIViewController {
    //
    func push(_ vc: UIViewController) {
        //
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// --------------------------------------------------------------------
// Kody pro jednotlive obrazovky (tabs) aplikace
enum AppTabs : Int {
    //
    case cars = 0
    case customers = 1
    case hireACar = 2
    case dropACar = 3
}

// --------------------------------------------------------------------
// Hlavni VC aplikace. Je to TabBar - rozdelovnik vsech funkci
// --------------------------------------------------------------------
class MainVC: UITabBarController {
    // ----------------------------------------------------------------
    //
    override func viewDidLoad() {
        // alokace VC pro taby. Hned se zapouzdri do NAV
        let tabCustomers = Customer.listVC.embedInNav()
        let tabCars = Car.listVC.embedInNav()
        let tabHire = CarHire.hire().embedInNav()
        let tabDrop = CarDrop.List().embedInNav()
        
        // NAV(tab) dostanou zaznamy o tabBarItem
        tabCustomers.add(tabBarItem: "Zákazníci", tag: AppTabs.customers.rawValue)
        tabCars.add(tabBarItem: "Auta", tag: AppTabs.cars.rawValue)
        tabHire.add(tabBarItem: "Pronajmout", tag: AppTabs.hireACar.rawValue)
        tabDrop.add(tabBarItem: "Vrátit", tag: AppTabs.dropACar.rawValue)
        
        // konfigurace TabBar, definuju jeho taby
        viewControllers = [tabCars, tabCustomers, tabHire, tabDrop]
    }
}
