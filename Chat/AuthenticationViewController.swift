
import UIKit

class AuthenticationViewController: UIViewController {
    let aD = UIApplication.sharedApplication().delegate as! AppDelegate
    var user: Array<Dictionary<String, AnyObject>>!
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var btn: UIButton!
    @IBOutlet var infoText: UILabel!
    @IBOutlet weak var UserLabel: UILabel!
    @IBOutlet weak var InfoLabel: UILabel!
    
    override func viewDidAppear(animated: Bool) {
        textField.returnKeyType = UIReturnKeyType.Send
        executeAuthentication()
    }
    
    private func executeAuthentication() {
        user = aD.data.get("User", predicat: aD.uuid)
        
        switch user.count {
        case 0:
            textField.hidden = false
            btn.hidden = false
            infoText.hidden = false
            UserLabel.hidden = false
            InfoLabel.hidden = false
            break
            
        case 1:
            aD.name = user[0]["name"]! as! String
            aD.username = (aD.uuid + " " + aD.name)
            performSegueWithIdentifier("authintication", sender: nil)
            break

        default:
            println("#FEHLER: AuthenticationViewController -> " +
                    "Mehr als ein Profil gefunden.")
            break
        }
    }
    
    @IBAction func register(sender: UIButton) {
        if (count(textField.text) < 4) {
            infoText.text = "Name zu kurz. Min 4 Zeichen."
        } else {
            aD.data.insert("User", id: aD.uuid, data: ["id": aD.uuid, "name": textField.text])
            aD.name = textField.text
            executeAuthentication()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        aD.session = MPCSession()
        aD.browser = MPCBrowser()
        aD.advertiser = MPCAdvertiser()
        aD.contacts = aD.data.get("Contact", predicat: nil)
    }
}
