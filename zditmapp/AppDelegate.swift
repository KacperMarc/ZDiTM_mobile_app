//
//  AppDelegate.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 14/12/2024.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    override init(){
        Environment.shared.register(MapViewModel())
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        deleteData()
        preloadDataIfNeeded()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    // MARK: - Core Data stack

    func applicationWillTerminate(_ application: UIApplication) {
            // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
            // Saves changes in the application's managed object context before the application terminates.
            self.saveContext()
        }

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "StopsDatabase")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    func deleteData() {
        let context = persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Stops> = Stops.fetchRequest()
        
        do {
            let stopsToDelete = try context.fetch(fetchRequest)
            for stop in stopsToDelete {
                context.delete(stop)
            }
        }
        catch {
            print("Błąd usuwania produktów: \(error)")
        }
    }
    func preloadDataIfNeeded() {
            let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Stops> = Stops.fetchRequest()

            do {
                let count = try context.count(for: fetchRequest) // Sprawdzamy, ile jest produktów w bazie
                if count == 0 {
                    addDefaultProducts(context: context)
                }
            } catch {
                print("Błąd sprawdzania liczby produktów: \(error)")
            }
        }

        func addDefaultProducts(context: NSManagedObjectContext) {
            let defaultStops: [String: Int] = ["Gocław": 1, "Niebuszewo": 2, "Gumieńce": 3, "Police": 4, "Gemunde": 5, "Gownience" : 6, "Wysokie Młyny": 7, "Golęcino":8]

            for (name, id) in defaultStops {
                let newProduct = Stops(context: context)
                    newProduct.name = name
                    newProduct.id = Int32(id)
                    newProduct.latitude = 0
                    newProduct.longitude = 0
                    newProduct.request_stop = false
            }

            do {
                try context.save()
                print("Domyślne produkty dodane do bazy")
            } catch {
                print("Błąd zapisu: \(error)")
            }
        }
    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


}

