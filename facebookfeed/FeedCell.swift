//
//  FeedCell.swift
//  facebookfeed
//
//  Created by HieuTong on 1/15/21.
//  Copyright © 2021 HieuTong. All rights reserved.
//

import Foundation
import UIKit


class FeedCell: UICollectionViewCell {
    var feedController: FeedController?
    
    @objc func animate() {
//        let view = UIView()
//        view.backgroundColor = .red
//        view.frame = statusImageView.frame
//        addSubview(view)
        feedController?.animateImageView(statusImageView: statusImageView)
    }
    
    
    var post: Post? {
        didSet {
            
            statusImageView.image = nil
            
            if let statusImageUrl = post?.statusImageURL {
                URLSession.shared.dataTask(with: NSURL(string: statusImageUrl)! as URL) { (data, reponse, error) in
                    if error != nil {
                        print(error)
                        return
                    }
                    
                    let image = UIImage(data: data!)
                    
                    DispatchQueue.main.async {
                        self.statusImageView.image = image
                    }
                }.resume()
            }
            
            if let statusImageName = post?.statusImageName {
                statusImageView.image = UIImage(named: statusImageName)
            }
            
            setupNameLocationStatusAndProfileImage()
        }
    }
    
    private func setupNameLocationStatusAndProfileImage() {
        if let name = post?.name {
            let attributedText = NSMutableAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: "\nDecember 18 . San Francisco . ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.rgb(r: 155, g: 161, b: 171, alpha: 1)]))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.string.count))
            
            let attachment = NSTextAttachment()
            attachment.image = #imageLiteral(resourceName: "globe_small")
            attachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
            attributedText.append(NSAttributedString(attachment: attachment))
            nameLabel.attributedText = attributedText
        }
        
        if let statusText = post?.statusText {
            statusTextView.text = statusText
        }
        
        if let profileImage = post?.profileImageName {
            profileImageView.image = profileImage
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "zuckprofile")
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let statusTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Meanwhile, Beast turned to the dark side"
        textView.font = .systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        return textView
    }()
    
    let statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "news_feed_icon")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let likesCommentLabel: UILabel = {
        let label = UILabel()
        label.text = "448 Likes  10.7 Comments"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .rgb(r: 155, g: 161, b: 171)
        return label
    }()
    
    let dividerViewLine: UIView = {
        let view = UIView()
        view.backgroundColor = .rgb(r: 226, g: 228, b: 232)
        return view
    }()
    
    let likeButton = FeedCell.buttonForTitle(title: "Like", iconImage: #imageLiteral(resourceName: "like"))
    let commentButton = FeedCell.buttonForTitle(title: "Comment", iconImage: #imageLiteral(resourceName: "comment"))
    let shareButton = FeedCell.buttonForTitle(title: "Share", iconImage: #imageLiteral(resourceName: "share"))
    
    static func buttonForTitle(title: String, iconImage: UIImage) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.rgb(r: 143, g: 150, b: 163), for: .normal)
        
        
        button.setImage(iconImage, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        return button
    }

    func setupViews() {
        backgroundColor = .white
        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(statusTextView)
        addSubview(statusImageView)
        addSubview(likesCommentLabel)
        addSubview(dividerViewLine)
        
        addSubview(likeButton)
        addSubview(commentButton)
        addSubview(shareButton)
        
        statusImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animate)))
                
        addConstraintsWithFormat(format: "H:|-8-[v0(44)]-8-[v1]|", views: profileImageView, nameLabel)
        
        addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: statusTextView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: statusImageView)
        
        addConstraintsWithFormat(format: "H:|-12-[v0]|", views: likesCommentLabel)
        
        addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: dividerViewLine)
        
        addConstraintsWithFormat(format: "H:|[v0(v2)][v1(v2)][v2]|", views: likeButton, commentButton, shareButton)

        addConstraintsWithFormat(format: "V:|-12-[v0]", views: nameLabel)
        
        addConstraintsWithFormat(format: "V:|-8-[v0(44)]-4-[v1]-4-[v2(200)]-8-[v3(24)]-8-[v4(0.4)]-8-[v5(44)]|", views: profileImageView, statusTextView, statusImageView, likesCommentLabel, dividerViewLine, likeButton)
        
        addConstraintsWithFormat(format: "V:[v0(44)]|", views: commentButton)
        addConstraintsWithFormat(format: "V:[v0(44)]|", views: shareButton)
    }
}
