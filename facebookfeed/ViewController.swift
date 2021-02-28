//
//  ViewController.swift
//  facebookfeed
//
//  Created by HieuTong on 1/13/21.
//  Copyright © 2021 HieuTong. All rights reserved.
//

import UIKit


struct Post {
    var name: String?
    var profileImageName: UIImage?
    var statusText: String?
    var statusImageName: String?
    var numLikes: Int?
    var numComments: Int?
    var statusImageURL: String?
    
    init(name: String, statusText: String, profileImageName: UIImage, statusImageName: String, numLikes: Int, numComments: Int, statusImageURL: String) {
        self.name = name
        self.statusText = statusText
        self.profileImageName = profileImageName
        self.statusImageName = statusImageName
        self.numLikes = numLikes
        self.numComments = numComments
        self.statusImageURL = statusImageURL
    }
}

let cellId = "cellId"

class FeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let memoryCapacity = 500 * 1024 * 1024
        let diskCapacity = 500 * 1024 * 1024
        let urlCache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "myDiskPath")
        URLCache.shared = urlCache
        
        let postMark = Post(name: "Mark", statusText: "Meanwhile. Best turned to the dark side", profileImageName: #imageLiteral(resourceName: "zuckprofile"), statusImageName: "zuckdog", numLikes: 400, numComments: 123, statusImageURL: "https://image.shutterstock.com/image-vector/summer-mountains-landscape-cartoon-nature-260nw-1438250240.jpg")
        let postSteve = Post(name: "Steve Jobs", statusText: "Design is not just what it looks like and feels like. Design is how it works.\n\n" + "Being the richest man in the cemetery doesn't matter to me. Going to bed at night saying we've done something wonderful, that's what matters to me.\n\n" + "Sometimes when you innovate, you make mistakes. It is best to admit them quickly, and get on with improving your other innovations.", profileImageName: #imageLiteral(resourceName: "steve_profile"), statusImageName: "steve_status", numLikes: 1000, numComments: 55, statusImageURL: "https://image.shutterstock.com/image-vector/summer-mountains-landscape-cartoon-nature-260nw-1438250240.jpg")
                        
        posts.append(postMark)
        posts.append(postSteve)
        
        // Do any additional setup after loading the view.
        navigationItem.title = "Facebook Feed"
        
        collectionView.alwaysBounceVertical = true
        
        collectionView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
        cell.post = posts[indexPath.row]
        cell.feedController = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let statusText = posts[indexPath.item].statusText {
            let rect = NSString(string: statusText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)], context: nil)
            
            let knowHeight: CGFloat = 8 + 44 + 4 + 4 + 200 + 8 + 24 + 8 + 24 + 8 + 44
            return CGSize(width: view.frame.width, height: rect.height + knowHeight + 16)
        }
        return CGSize(width: view.frame.width, height: 500)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    let blackBackgroundView = UIView()
    
    var statusImageView: UIImageView?
    let zoomImageView = UIImageView()
    let navBarCoverView = UIView()
    let tabBarCornerView = UIView()
    
    func animateImageView(statusImageView: UIImageView) {
        self.statusImageView = statusImageView
        if let startingFrame = statusImageView.superview?.convert(statusImageView.frame, to: nil) {
            
            statusImageView.alpha = 0
            blackBackgroundView.frame = self.view.frame
            blackBackgroundView.backgroundColor = .black
            blackBackgroundView.alpha = 0
            view.addSubview(blackBackgroundView)
            
            navBarCoverView.frame = CGRect(x: 0, y: 0, width: 1000, height: 20+100)
            navBarCoverView.backgroundColor = .black
            navBarCoverView.alpha = 0
            
            if let keyWindow = UIApplication.shared.keyWindow {
                keyWindow.addSubview(navBarCoverView)
                
                tabBarCornerView.frame = CGRect(x: 0, y: keyWindow.frame.height - 100, width: 1000, height: 100)
                tabBarCornerView.backgroundColor = .black
                tabBarCornerView.alpha = 0
                keyWindow.addSubview(tabBarCornerView)
            }
            
            zoomImageView.backgroundColor = .red
            zoomImageView.frame = startingFrame
            zoomImageView.isUserInteractionEnabled = true
            zoomImageView.image = statusImageView.image
            zoomImageView.contentMode = .scaleAspectFill
            zoomImageView.clipsToBounds = true
            view.addSubview(zoomImageView)
            
            zoomImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOut)))
            
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                let height = (self.view.frame.width / startingFrame.width) * startingFrame.height
                
                let y = self.view.frame.height / 2 - height / 2
                
                self.zoomImageView.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: height)
                
                self.blackBackgroundView.alpha = 1
                
                self.navBarCoverView.alpha = 1
                
                self.tabBarCornerView.alpha = 1
            }, completion: nil)
        }
    }
    
    @objc func zoomOut() {
        if let statusImageView = statusImageView, let startingFrame = statusImageView.superview?.convert(statusImageView.frame, to: nil) {
            
            
            UIView.animate(withDuration: 0.75) {
                self.zoomImageView.frame = startingFrame
                self.blackBackgroundView.alpha = 0
                self.navBarCoverView.alpha = 0

            } completion: { (didComplete) in
                self.zoomImageView.removeFromSuperview()
                self.blackBackgroundView.removeFromSuperview()
                self.navBarCoverView.removeFromSuperview()
                self.tabBarCornerView.removeFromSuperview()
                self.statusImageView?.alpha = 1
            }

        }
    }
    
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String:UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: [], metrics: nil, views: viewsDictionary))
    }
}


extension UIColor {
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: alpha)
    }
    
    
}
