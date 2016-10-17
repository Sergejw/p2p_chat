
import UIKit
import CoreData

class CoreData: NSObject {
    
    let mOC = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
	
    // Beschreibt Entity in Core Data
    func insert(entityName: String, id: AnyObject?, data: Dictionary<String, AnyObject>) {
        
        // unique leer ODER nicht in Core Data
        if (id == nil ||
            id != nil && get(entityName, format: "id", predicat: id?.description) == nil) {
            
            let eD = NSEntityDescription.entityForName(entityName, inManagedObjectContext: mOC!)
            let mO = NSManagedObject(entity: eD!, insertIntoManagedObjectContext:mOC)
           
            for key in eD!.propertiesByName.keys {
                if  data.indexForKey(key.description) != nil {
                    mO.setValue(data[key.description], forKey: key.description)
                }
            }
        
            mOC!.save(nil)
        }
    }
    
    func updateUser(data: AnyObject) {
        
        var fetchRequest = NSFetchRequest()
        var eD = NSEntityDescription.entityForName("User", inManagedObjectContext: mOC!)
        fetchRequest.entity = eD
        
        var error : NSError?
        var fetchedObjects = mOC!.executeFetchRequest(fetchRequest, error: &error)
        
        //Daten Updaten
        if let fO = fetchedObjects {
            if error == nil {
                for fetchedData in fO {
                    if((data[0].valueForKey("name")) != nil){
                        fetchedData.setValue(data[0].valueForKey("name"), forKey: "name")
                    }
                    if((data[0].valueForKey("mood")) != nil){
                        fetchedData.setValue(data[0].valueForKey("mood"), forKey: "mood")
                    }
                    
                    // TO_DO String in Datum umwandeln und Datum übergeben an CoreData
                    
                    if((data[0].valueForKey("age")) != nil){
                        NSLog("SAVE DATA: Age")
                        fetchedData.setValue(data[0].valueForKey("age"), forKey: "age")
                    }
                    
                    if((data[0].valueForKey("gender")) != nil){
                        fetchedData.setValue(data[0].valueForKey("gender"), forKey: "gender")
                    }
                    if((data[0].valueForKey("interests")) != nil){
                        fetchedData.setValue(data[0].valueForKey("interests"), forKey: "interests")
                    }
                    if((data[0].valueForKey("about_me")) != nil){
                        fetchedData.setValue(data[0].valueForKey("about_me"), forKey: "about_me")
                    }
                    
                }
                
                if !mOC!.save(&error) {
                    NSLog("Unresolved error (error), (error!.userInfo)")
                    abort()
                }
            }
        }
    }
    
  	
    

    func getManagedObject(entityName: String, format: String, predicat: String) -> NSManagedObject {
        let request = NSFetchRequest(entityName: entityName)
        request.predicate = NSPredicate(format: "(\(format) = %@)", predicat)
        let requestResult = mOC?.executeFetchRequest(request, error: nil)
        
        var user: NSManagedObject
        
        if requestResult!.count > 0 {
            for result in requestResult!.generate() {
                return result as! NSManagedObject
        
            }
        }
        
        return NSManagedObject()
    }
    
    func get(entityName: String, predicat: String?) -> Array<Dictionary<String,  AnyObject>> {
        var dic = Dictionary<String, AnyObject>()
        var arr = Array<Dictionary<String, AnyObject>>()
        let request = NSFetchRequest(entityName: entityName)
        
        if (entityName == "Message") {
            let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
            let sortDescriptors = [sortDescriptor]
            request.sortDescriptors = sortDescriptors
        }
        
        if (predicat != nil) {
            request.predicate = NSPredicate(format: "(id = %@)", predicat!)
        }
        
        let result = mOC?.executeFetchRequest(request, error: nil)
        
        if (result!.count > 0) {
            
            for item in result!.generate() {
                
                for key in item.entity.propertiesByName.keys {
                    dic[key.description] = item.valueForKey(key.description)
                }
                
                arr.append(dic)
            }
            
            
        }
        
        return arr
        
    }
    
    func getById(entityName: String, predicat: String) -> Dictionary<String, AnyObject>? {
        let request = NSFetchRequest(entityName: entityName)
        request.predicate = NSPredicate(format: "(id = %@)", predicat)
        let result = mOC?.executeFetchRequest(request, error: nil)

        if (result!.count == 1) {
            var data = Dictionary<String, AnyObject>()
            for key in result!.first!.entity.propertiesByName.keys {
                data[key.description] = result!.first!.valueForKey(key.description)
            }
            
            return data
        }
        
        return nil
    }
    
    func getAll(entityName: String, properties: [AnyObject]?) -> [AnyObject]? {
        let request = NSFetchRequest(entityName: entityName)
        
        if (properties != nil) {
            request.propertiesToFetch = properties
        }
        
        let result = mOC?.executeFetchRequest(request, error: nil)

        if (result?.count > 0) {
            return result
            
        } else {
            return nil
        }
        
        
    }
    
    // Holt Inhalt aus Entity
    func get(entityName: String, format: String?, predicat: String?) -> (Array<Dictionary<String, AnyObject>>, Dictionary<String, AnyObject>)? {
        
        let request = NSFetchRequest(entityName: entityName)
        
        if (format != nil && predicat != nil) {
            request.predicate = NSPredicate(format: "(\(format!) = %@)", predicat!)
        }
        
        let result = mOC?.executeFetchRequest(request, error: nil)
        
        if (result!.count > 0) {
            var data = Dictionary<String, AnyObject>()
            var multiData = Array<Dictionary<String, AnyObject>>()
            
            for item in result!.generate() {
                
                for key in item.entity.propertiesByName.keys {
                    data[key.description] = item.valueForKey(key.description)
                }
                
                multiData.append(data)
            }
            
            return (multiData, data)
        }
        
        return nil
    }
}