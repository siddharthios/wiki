//
//  GridCell.swift
//  wiki
//
//  Created by Siddharth Kumar on 24/06/18.
//  Copyright © 2018 Siddharth Kumar. All rights reserved.
//

import UIKit

class GridCell: UICollectionViewCell {
    
    var titleLabel = UILabel()
    var descLabel = UILabel()
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = false
        contentView.addSubview(imageView)
        
        titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines=0
        titleLabel.textColor=UIColor.black
        titleLabel.font=UIFont.boldSystemFont(ofSize: 13)
        titleLabel.adjustsFontSizeToFitWidth = true
        contentView.addSubview(titleLabel)
        
        
        descLabel = UILabel()
        descLabel.textAlignment = .left
        descLabel.textColor=UIColor.gray
        descLabel.font=UIFont.boldSystemFont(ofSize: 12)
        descLabel.numberOfLines = 0
        descLabel.adjustsFontSizeToFitWidth = true
        contentView.addSubview(descLabel)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var frame = imageView.frame
        frame.size.height = self.frame.size.height*0.8
        frame.size.width = self.frame.size.width*0.25
        frame.origin.x = self.frame.size.height*0.1
        frame.origin.y = self.frame.size.height*0.1
        imageView.frame = frame
  
        
        var labelFrame2 = titleLabel.frame
        labelFrame2.size.height = self.frame.size.height*0.3
        labelFrame2.size.width = self.frame.size.width*0.6
        labelFrame2.origin.x = self.frame.size.width*0.35
        labelFrame2.origin.y = self.frame.size.height*0.1
        titleLabel.frame = labelFrame2
        
        var labelFrame3 = titleLabel.frame
        labelFrame3.size.height = self.frame.size.height*0.5
        labelFrame3.size.width = self.frame.size.width*0.6
        labelFrame3.origin.x = self.frame.size.width*0.35
        labelFrame3.origin.y = self.frame.size.height*0.4
        descLabel.frame = labelFrame3
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
