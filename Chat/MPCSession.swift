
import UIKit
import MultipeerConnectivity

class MPCSession: NSObject, MCSessionDelegate {
    
    let aD = UIApplication.sharedApplication().delegate as! AppDelegate
    var peer: MCPeerID!
    var session: MCSession!
    
    override init() {
        super.init()
        peer = MCPeerID(displayName: aD.username)
        session = MCSession(peer: peer)
        session.delegate = self
    }
    
    
    // Remote peer changed state
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        switch state {
        case MCSessionState.Connected:
            println("Verbunden mit : \(peerID)")
            var arr = peerID.displayName.componentsSeparatedByString(" ")
            let id = arr[0]
            let name = peerID.displayName.stringByReplacingOccurrencesOfString(id + " ", withString: "", options: nil, range: nil)
            aD.data.insert("Contact", id: id, data: ["id": id, "name": name])
            addToContacts(["id": id, "name": name])
            break
            
        case MCSessionState.Connecting:
            println("Verbinde mit: \(peerID)")
            break
            
        case MCSessionState.NotConnected:
            println("Konnte nicht mit \(peerID) verbinden.")
            break
            
        default:
            println("Did not connect to session: \(peerID)")
        } 
    }
    
    
    //  Fuegt neuen Kontakt den vorhandenen zu.
    //
    private func addToContacts(item: Dictionary<String, AnyObject>) {
        var contains: Bool = false
        
        if (aD.contacts.count > 0) {
            for peer in aD.contacts {
                if (peer["id"] as! String == item["id"] as! String) {
                    contains = true
                    break
                }
            }
        }
        
        if !contains {
            aD.contacts.append(item)
            NSNotificationCenter.defaultCenter().postNotificationName("newContact", object: nil)
        }
    }

    
    //  Liefert Peer aus bestehenden Verbindungen.
    //
    func getPeerById(id: String) -> MCPeerID! {
        
        for peer in session.connectedPeers {
            if (peer.displayName.description.rangeOfString(id) != nil) {
                return peer as! MCPeerID
            }
        }
        
        return nil
    }
    
    
    //  Speichert und meldet ankommende Daten.
    //
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        let item = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as! [String: AnyObject]
    
        aD.data.insert("Message", id: nil, data: item)
        NSNotificationCenter.defaultCenter().postNotificationName("didReceiveData", object: nil, userInfo: item)
    }
    
    
    // Received a byte stream from remote peer
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {}
    
    // Start receiving a resource from remote peer
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {}
    
    // Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {}
}
