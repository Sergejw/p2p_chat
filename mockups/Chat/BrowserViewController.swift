//
//  BrowserViewController.swift
//  Chat
//
//  Created by zerg on 28.05.15.
//  Copyright (c) 2015 zerg. All rights reserved.
//

import UIKit

class BrowserViewController: UIViewController, UIScrollViewDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var imageView = UIImageView()
    let image = UIImage(named:"dart")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        imageView.frame = CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height)
        imageView.image = self.image
        imageView.userInteractionEnabled = true
        
        scrollView.addSubview(imageView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:"loadImage:")
        tapGestureRecognizer.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        self.imagePickerController()
    }
    
    func loadImage(recognizer:UITapGestureRecognizer){
        
    }
    
    func imagePickerController(){
        
        imageView.contentMode = UIViewContentMode.Center
        imageView.frame = CGRectMake(0, 0, self.image!.size.width,self.image!.size.height)
        
        scrollView.contentSize = self.image!.size
        
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleWidth, scaleHeight)
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 1
        scrollView.zoomScale = minScale
    }
    
    func centerScrollViewContent(){
        let boundSize = scrollView.bounds.size
        var contentsFrame = imageView.frame
        
        if contentsFrame.size.width < boundSize.width{
            contentsFrame.origin.x = (boundSize.width - contentsFrame.size.width) / 2
        }else{
            contentsFrame.origin.x = 0
        }
        
        if contentsFrame.size.height < boundSize.height{
            contentsFrame.origin.y = (boundSize.height - contentsFrame.size.height) / 2
        }else{
            contentsFrame.origin.y = 0
        }
        
        imageView.frame = contentsFrame
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        centerScrollViewContent()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
