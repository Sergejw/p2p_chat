

import UIKit
import MultipeerConnectivity

protocol MPCAdvertiserDelegate {
    func showAlert(alert: UIAlertController);
}

class MPCAdvertiser: NSObject, MCNearbyServiceAdvertiserDelegate, UIAlertViewDelegate {
    
    let aD = UIApplication.sharedApplication().delegate as! AppDelegate
    var advertiser: MCNearbyServiceAdvertiser!
    var iOS7alert: UIAlertView!
    var iOS8alert: UIAlertController!
    var invitationHandler: ((Bool, MCSession!)->Void)!
    
    override init() {
        super.init()
        advertiser = MCNearbyServiceAdvertiser(peer: aD.session.peer, discoveryInfo: ["id": aD.uuid], serviceType: "appcoda-mpc")
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()
    }
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didReceiveInvitationFromPeer peerID: MCPeerID!, withContext context: NSData!, invitationHandler: ((Bool, MCSession!) -> Void)!) {
        self.invitationHandler = invitationHandler
        
        // iOS8
        if (aD.IOS8 != nil) {
            iOS8alert = UIAlertController()
            iOS8alert = UIAlertController(title: "", message: "\(peerID.displayName) wants to chat with you.", preferredStyle: UIAlertControllerStyle.Alert)
            iOS8alert.addAction(UIAlertAction(title: "Accept", style: UIAlertActionStyle.Default) {
                (alertAction) -> Void in self.invitationHandler(true, self.aD.session.session)})
            iOS8alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
                (alertAction) -> Void in self.invitationHandler(false, nil)})
            aD.currentView.presentViewController(iOS8alert, animated: true, completion: nil)
            
        // iOS7
        } else {
            iOS7alert = UIAlertView()
            iOS7alert.delegate = self
            iOS7alert.message = "\(peerID.displayName) wants to chat with you."
            iOS7alert.addButtonWithTitle("Cancel")
            iOS7alert.addButtonWithTitle("Accept")
            iOS7alert.show()
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex{
        case 0:
            self.invitationHandler(false, nil)
            
        case 1:
            self.invitationHandler(true, self.aD.session.session)
            
        default:
            println("sond")
        }
    }
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didNotStartAdvertisingPeer error: NSError!) {
        println(error.localizedDescription)
    }
}
