//
//  ViewController.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 14/12/2024.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = UINavigationController(rootViewController: TimetableViewController())
        let vc2 = UINavigationController(rootViewController: MapViewController())
        let vc3 = UINavigationController(rootViewController: SearchConnectionViewController())
        let vc4 = UINavigationController(rootViewController: InterruptionsViewController())
        let vc5 = UINavigationController(rootViewController: TicketsViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "tablecells.fill")
        vc2.tabBarItem.image = UIImage(systemName: "map.circle")
        vc3.tabBarItem.image = UIImage(systemName: "location.magnifyingglass")
        vc4.tabBarItem.image = UIImage(systemName: "exclamationmark.triangle")
        vc5.tabBarItem.image = UIImage(systemName: "ticket.fill")
        
        vc1.title = "Rozkłady jazdy"
        vc2.title = "Mapa pojazdów"
        vc3.title = "Wyszukaj połączenie"
        vc4.title = "Zakłócenia"
        vc5.title = "Bilety"
        
        if #available(iOS 13.0, *) {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            tabBarAppearance.backgroundColor = UIColor(red: 30/255, green: 56/255, blue: 140/255, alpha: 1)
            tabBarAppearance.backgroundEffect = nil

            tabBarAppearance.stackedLayoutAppearance.normal.iconColor = .white
            tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]

            let selectedItemColor = UIColor(red: 245/255, green: 27/255, blue: 36/255, alpha: 1)
            tabBarAppearance.stackedLayoutAppearance.selected.iconColor = selectedItemColor
            tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selectedItemColor]

            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
            
            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().tintColor = selectedItemColor 
        }
        setViewControllers([vc1, vc2, vc3, vc4, vc5], animated: true)
        selectedIndex = 2
    }
}

