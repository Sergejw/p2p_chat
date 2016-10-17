
import UIKit
import CoreData

class ChatsViewController: UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    let aD = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aD.currentView = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadCollection:", name: "newContact", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)

        // Verbessern: Aktualisierung zur Laufzeit einbauen
        aD.contacts = aD.data.get("Contact", predicat: nil)

        rotated()
    }
    
    
    func rotated() {
        if (UIDevice.currentDevice().orientation.isLandscape) {
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.itemSize = CGSize(width: (self.view.frame.width - 50) / 5, height: 120)
            
            self.collectionView?.collectionViewLayout = layout
        
        } else {
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.itemSize = CGSize(width: (self.view.frame.width - 30) / 3, height: 120)
            
            self.collectionView?.collectionViewLayout = layout
        }
    }
    
    
    func reloadCollection(notification: NSNotification) {
        NSOperationQueue.mainQueue().addOperationWithBlock({
            () -> Void in self.collectionView!.reloadData()
        })
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("chatsCell", forIndexPath: indexPath) as! ChatsCellCollectionViewCell
        
        cell.txt.text = aD.contacts[indexPath.item]["name"] as? String
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        if segue!.identifier == "Conversation" {
            let index = self.collectionView!.indexPathForCell(sender as! UICollectionViewCell)
            let cVC = segue!.destinationViewController as! ConversationViewController
            
            cVC.titel.title = aD.contacts[index!.item]["name"] as? String
            cVC.chatid = aD.contacts[index!.item]["id"] as? String
        }
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return aD.contacts.count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
