//
//  GridLayout.swift
//  wiki
//
//  Created by Siddharth Kumar on 24/06/18.
//  Copyright © 2018 Siddharth Kumar. All rights reserved.
//


import UIKit

class GridLayout: UICollectionViewFlowLayout {
    
    let innerSpace: CGFloat = 10
    let numberOfCellsOnRow: CGFloat = 1
    
    
    override init() {
        super.init()
        self.minimumLineSpacing = innerSpace
        self.minimumInteritemSpacing = innerSpace
        self.scrollDirection = .vertical
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    func itemWidth() -> CGFloat {
        return (collectionView!.frame.size.width/self.numberOfCellsOnRow)-(self.innerSpace*2)
    }
    
    override var itemSize: CGSize {
        set {
            self.itemSize = CGSize(width:itemWidth(), height:itemWidth()*0.3)
        }
        get {
            return CGSize(width:itemWidth(),height:itemWidth()*0.3)
        }
    }
    
    
}
