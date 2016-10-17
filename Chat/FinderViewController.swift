
import UIKit
import MultipeerConnectivity
import Foundation

class FinderViewController: UIViewController, MPCBrowserDelegate, UIScrollViewDelegate, UINavigationControllerDelegate {
    
    let aD = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet var scrollView: UIScrollView!
    var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aD.currentView = self
        aD.browser.delegate = self
        aD.browser.browser.startBrowsingForPeers()
        
        // add background image
        let image = UIImage(named:"dart")!
        let bgView = UIImageView(image: image)
        bgView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size:image.size)
        
        scrollView.addSubview(bgView)
        
        // Set up the container view to hold your custom view hierarchy
        containerView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size:image.size))
        scrollView.addSubview(containerView)
        
        // Tell the scroll view the size of the contents
        scrollView.contentSize = image.size;
        
        // Set up the minimum & maximum zoom scales
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleWidth, scaleHeight)
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 1.0
        scrollView.zoomScale = 1.0
        
        centerScrollViewContents()
        
        /* test
        self.addButton(0, name: "0")
        self.addButton(1, name: "1")
        self.addButton(2, name: "2")
        
        self.removeButton(1)
        
        self.addButton(3, name: "3")
        
        self.removeButton(2)
        
        let imageView = UIImageView(image: UIImage(named: "dot"))
        imageView.center = CGPoint(x: containerView.center.x, y: containerView.center.y);
        containerView.addSubview(imageView)

        */
    }
    
    
    func addButton(tag: Int, name: String) {
        
        let btn = UIButton(frame: CGRect(x: 100 * tag, y: 100 * tag, width: 200, height: 200))
        let dot = UIImage(named: "dot") as UIImage?
        
        btn.setImage(dot, forState: .Normal)
        btn.setTitle(name, forState: UIControlState.Normal)
        btn.tag = tag
        btn.addTarget(self, action: "btnPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // Button-, Text-Positionierung
        let spacing: CGFloat = 6.0;
        
        let imageSize: CGSize = btn.imageView!.frame.size;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + spacing), 0.0);
        
        let titleSize: CGSize = btn.titleLabel!.frame.size;
        btn.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0.0, 0.0, -titleSize.width);
        
        self.containerView.addSubview(btn)
    }
    
    func removeButton(tag: Int){
        for view in self.containerView.subviews {
            if(view.tag == tag){
                view.removeFromSuperview()
            }
        }
    }
    
    func centerScrollViewContents() {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = containerView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        containerView.frame = contentsFrame
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return containerView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        centerScrollViewContents()
    }
    
    override func viewWillDisappear(animated: Bool) {
        aD.browser.browser.stopBrowsingForPeers()
    }
    
    //  ................................................................................
    //
    //
    //
    //
    // wenn Peer gefunden ... gefundene / erreichbare Peers zeichnen
    // SENDER FINDET SICH AUCH SELBER
    
    
    func foundPeer() {
        
        NSOperationQueue.mainQueue().addOperationWithBlock {
            var xDis: CGFloat = 20  // our Starting Offset, could be 0
            var yDis: CGFloat = 20
            
            for (index, name) in enumerate(self.aD.browser.foundPeers) {
                
                let btn = UIButton(frame: CGRect(x: xDis, y: yDis, width: 100, height: 100))
                
                let dot = UIImage(named: "dot") as UIImage?
                btn.setImage(dot, forState: .Normal)
                
                btn.setTitle("\(name.displayName)", forState: UIControlState.Normal)
                btn.tag = index
                //btn.addTarget(self, action: "btnPressed:", forControlEvents: UIControlEvents.TouchUpInside)
                btn.addTarget(self, action: "lostPeer:", forControlEvents: UIControlEvents.TouchUpInside)
                
                self.containerView.addSubview(btn)
                
                
                xDis += 100
                yDis += 100
            }
        }
        
    }
    
    //
    //  wenn Peer nicht mehr erreichbar, dann alles neu zeichnen?
    
    func lostPeer() {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            
            for var i = 1; i < self.containerView.subviews.count; i++ {
                self.containerView.subviews[i].removeFromSuperview()
            }
            
            self.foundPeer()
        }
    }
    
    //
    //
    //
    //
    //
    //................................................................................
    

    
    func btnPressed(sender: UIButton!) {
        let selectedPeer = aD.browser.foundPeers[sender.tag] as MCPeerID
        
        
        //aD.browser.browser.invitePeer(selectedPeer, toSession: aD.session.session, withContext: nil, timeout: 10)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}