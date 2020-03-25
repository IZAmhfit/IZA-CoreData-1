//
//  SceneDelegate.swift
//  IZA-CoreData-1
//
//  Created by Martin Hruby on 18/03/2020.
//  Copyright © 2020 Martin Hruby FIT. All rights reserved.
//

import UIKit

// --------------------------------------------------------------------
// SceneDelegate je nove (od ios13???) rozsireni AppDelegate
// --------------------------------------------------------------------
// jeste o tom nemam moc prehled, zrejme souvislost na SwiftUI mozna...
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // ----------------------------------------------------------------
    // Takze, hlavni UIWindow aplikace je vlastneno z tohoto mista
    // (byval to AppDelegate)
    var window: UIWindow?


    // ----------------------------------------------------------------
    // dozvidame se, ze scena zahajila svou cinnost, na to reagujeme nize...
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions)
    {
        //
        guard let _windowScene = (scene as? UIWindowScene) else { return }
        
        // alokace okynka...
        window = UIWindow()
                
        // napojeni na scenu, ok...
        window?.windowScene = _windowScene
        
        // dulezite: okno ma svuj ROOT-VC, ktery se ted instancuje
        window?.rootViewController = MainVC()
        
        // okno prebira kontrolu, prebira udalosti (Key)
        // a jde videt (Visible)
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        //
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        //
    }

    func sceneWillResignActive(_ scene: UIScene) {
        //
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        //
    }

    // predvyplneno z XCode...
    // ulozeni rozpracovaneho MOC se deje PO PRECHODU do background,
    // kde aplikace dostava poslednich par milisekund na procesoru
    // (tak snad to stihne ;)
    // Predpokladame, ze kdyz OS zhazuje aplikaci pozadi, tak na
    // to beztak specha...
    func sceneDidEnterBackground(_ scene: UIScene) {
        //
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

