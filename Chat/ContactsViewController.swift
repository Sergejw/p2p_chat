//
//  ContactsViewController.swift
//  Chat
//
//  Created by zerg on 08.07.15.
//  Copyright (c) 2015 zerg. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let aD = UIApplication.sharedApplication().delegate as! AppDelegate
    var con: Array<Dictionary<String, AnyObject>>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aD.currentView = self
        con = aD.contacts
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //  Liefert horizontale Anzahl der Zellen.
    //
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    //  Liefert vertikale Anzahl der Zellen.
    //
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return con.count
    }
    
    
    //  Liefert eine Zelle mit Inhalt.
    //
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("contactsCell") as! ContactsTableViewCell
        
        cell.name.text = con[indexPath.item]["name"]?.description
        
        if (con[indexPath.item]["is_friend"] as! Bool) {
            cell.buddy.text = "buddy"
        
        } else {
            cell.buddy.text = "contact"
        }
        
        let user = [aD.session.getPeerById(con[indexPath.item]["id"] as! String)]
        
        if (user[0] != nil) {
            cell.online.textColor = UIColor(red: 0.0, green: 0.8, blue: 0.3, alpha: 0.5)
            cell.online.text = "online"
            
        } else {
            cell.online.text = "offline"
        }
        
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
