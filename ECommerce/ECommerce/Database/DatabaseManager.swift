//
//  DatabaseManager.swift
//  ECommerce
//
//  Created by Ashwin Gattani on 01/03/19.
//  Copyright © 2019 Example. All rights reserved.
//

import Foundation
import CoreData

let EntityProductData = "ProductData"

class DatabaseManager: NSObject {
    static let sharedInstance = DatabaseManager()
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ECommerce")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MARK:- Save Data In Database
    func saveProductDataInDatabase(model : Product) -> Void {
        
        let managedContext =
            self.persistentContainer.viewContext
        
        let data = ProductData(context: managedContext)
        data.id                  = Int64(model.id)
        data.name                = model.name
        data.date_added          = model.date_added
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func getProductName(with productId:Int) -> String {
        
        let managedContext =
            self.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: EntityProductData)
        
        let predicate = NSPredicate(format: "id = %i",Int64(productId))
        fetchRequest.predicate = predicate
        
        var productName = ""
        
        do {
            let manageObjectContext = try managedContext.fetch(fetchRequest)
            if (manageObjectContext.count) > 0 {
                for manageObject in manageObjectContext {
                    productName = manageObject.value(forKeyPath: "name") as! String
                }
                return productName
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return productName
            
        }
        return productName
    }
    
    //MARK:- Clear Database With Entity Name
    func clearDatabaseWithEntityName(_ entity:String) -> Void {
        
        let context =
            self.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            try self.persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: context)
        } catch let error as NSError {
            print(error.description)
        }
    }
}
