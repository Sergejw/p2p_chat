
import UIKit
import MultipeerConnectivity

class ConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    let aD = UIApplication.sharedApplication().delegate as! AppDelegate
    let statusbarHeight = UIApplication.sharedApplication().statusBarFrame.height
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var fieldVertical: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var titel: UINavigationItem!
    @IBOutlet var offLabel: UILabel!
    @IBOutlet var topSpace: NSLayoutConstraint!
    @IBOutlet var hSpaceRight: NSLayoutConstraint!
    @IBOutlet var hSpaceLeft: NSLayoutConstraint!
    
    var chatid: String!
    var conversation: Array<Dictionary<String,  AnyObject>>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aD.currentView = self
        
        conversation = aD.data.get("Message", predicat: chatid)
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.Send
        textField.autocorrectionType = UITextAutocorrectionType.No
        
        if (aD.IOS8 == nil) {
            tableView.separatorInset = UIEdgeInsetsMake(0, 22, 0, 22)
            hSpaceRight.constant += 5
            hSpaceLeft.constant += 5
        }
        
        setTopSpace()
        
        if (aD.session.getPeerById(chatid) == nil) {
            textField.hidden = true
            offLabel.hidden = false
            offLabel.text = "Dieser Benutzer ist offline."
            
        } else {
            offLabel.hidden = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeConstraints:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeConstraints:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadTableView:", name: "didReceiveData", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        scrollTableToBottom()
    }
    
    //  Verschiebt die Tabelle um Navigation- und Statusbarhoehe nach unten.
    //
    func setTopSpace() {
        topSpace.constant = statusbarHeight + navigationController!.navigationBar.frame.height
    }
    
    
    //  Passt die Anzeige der neuen Groesse an (Portrait oder Landscape)
    //
    func rotated() {
        setTopSpace()
        
        NSOperationQueue.mainQueue().addOperationWithBlock({
            self.tableView.reloadData()
            self.scrollTableToBottom()
        })
    }
    
    
    //  Scrollt Tabelle nach unten.
    //
    private func scrollTableToBottom() {
        let y = tableView.contentSize.height - tableView.frame.size.height
        
        if (y > 0) {
            let offset = CGPointMake(0, y)
            tableView.setContentOffset(offset, animated: true)
        }
    }
    
    
    //  Aktualisiert Tabelleninhalt.
    //
    func reloadTableView(notification: NSNotification) {
        if (notification.userInfo != nil) { // Noch prüfen ob richtige CHatid
            conversation.append(notification.userInfo as! Dictionary<String, AnyObject>)
        }
        
        NSOperationQueue.mainQueue().addOperationWithBlock({
            self.tableView.reloadData()
            self.scrollTableToBottom()
        })
    }
    
    
    //  Liefert horizontale Anzahl der Zellen.
    //
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    //  Liefert vertikale Anzahl der Zellen.
    //
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversation.count
    }
    
    
    //  Liefert eine Zelle mit Inhalt.
    //
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("conversationCell") as! ConversationCellTableViewCell
        
        cell.message.text = conversation[indexPath.item]["text"]?.description
        cell.datum.text = aD.dateFormatter.stringFromDate(conversation[indexPath.item]["date"] as! NSDate)
        
        if (conversation[indexPath.item]["from"] as? String == aD.name) {
            cell.name.text = ""
            
        } else {
            cell.name.text = self.titel.title
        }
        
        return cell
    }
    
    //  TODO: Groesse in Core Data speichern und nicht jedes Mal neu berechnen
    //  Liefert passende Groesse fuer Tabellenzelle.
    //
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, textField.frame.width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = UIFont.systemFontOfSize(17)
        label.text = conversation[indexPath.item]["text"]?.description
        label.sizeToFit()
        
        return 44 + label.frame.height
    }
    
    
    //  Sendet Nachricht an Chatpartner.
    //
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let receiver = [aD.session.getPeerById(chatid)]
        
        if (receiver[0] != nil && textField.text != "") {
            var content = ["id": aD.uuid, "from": aD.name, "date": NSDate(), "text": textField.text]
            let data = NSKeyedArchiver.archivedDataWithRootObject(content)
            
            aD.session.session.sendData(data, toPeers: receiver, withMode: MCSessionSendDataMode.Reliable, error: nil)
            content["id"] = chatid
            aD.data.insert("Message", id: nil, data: content)
            conversation.append(content)
            self.tableView.reloadData()
        }
        
        textField.resignFirstResponder()
        textField.text = ""
        
        return true
    }
    
    
    //  Passt Elementbeschraenkungen dem Keyboard an.
    //
    func changeConstraints(sender: NSNotification) {
        self.fieldVertical.constant = 15
        
        if (sender.name == "UIKeyboardWillShowNotification") {
            if let userInfo = sender.userInfo {
                let size = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue().size
                if (size.height < size.width) {
                    self.fieldVertical.constant += size.height
                        
                } else {
                    self.fieldVertical.constant += size.width
                }
                
                self.view.layoutIfNeeded()
            }
        }
        
        NSOperationQueue.mainQueue().addOperationWithBlock({
            self.scrollTableToBottom()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func beispiele() {
        
        aD.data.insert("Message", id: nil, data: ["id": chatid, "from": titel.description, "date": NSDate(), "text": "Yo was geht?"])
        aD.data.insert("Message", id: nil, data: ["id": chatid, "from": "me", "date": NSDate(), "text": "FU"])
        aD.data.insert("Message", id: nil, data: ["id": chatid, "from": titel.description, "date": NSDate(), "text": "jshdfjgh"])
        aD.data.insert("Message", id: nil, data: ["id": chatid, "from": titel.description, "date": NSDate(), "text": "aaaaa"])
        aD.data.insert("Message", id: nil, data: ["id": chatid, "from": "me", "date": NSDate(), "text": "gerfjhwkejfhkwj wifjh weif"])
    }
}
