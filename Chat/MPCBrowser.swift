
import UIKit
import MultipeerConnectivity

protocol MPCBrowserDelegate {
    func foundPeer()
    func lostPeer()
}

class MPCBrowser: NSObject, MCNearbyServiceBrowserDelegate {
    
    let aD = UIApplication.sharedApplication().delegate as! AppDelegate
    var browser: MCNearbyServiceBrowser!
    var delegate: MPCBrowserDelegate?
    var foundPeers = [MCPeerID]()
    
    override init() {
        super.init()
        browser = MCNearbyServiceBrowser(peer: aD.session.peer, serviceType: "appcoda-mpc")
        browser.delegate = self
    }
    
    func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!, withDiscoveryInfo info: [NSObject : AnyObject]!) {
        foundPeers.append(peerID)
        delegate?.foundPeer()
    }
    
    func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!) {
        
        for (index, aPeer) in enumerate(foundPeers){
            if aPeer == peerID {
                foundPeers.removeAtIndex(index)
                break
            }
        }
        
        
        
        foundPeers.removeAll(keepCapacity: true)
        
        delegate?.lostPeer()
        
    }
    
    
    func browser(browser: MCNearbyServiceBrowser!, didNotStartBrowsingForPeers error: NSError!) {
        println(error.localizedDescription)
    }
    
}
