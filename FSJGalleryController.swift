//
//  FSJGalleryController.swift
//  ImageGallery
//
//  Created by Felipe Saint-jean on 7/13/16.
//  Copyright © 2016 Felipe Saint-jean. All rights reserved.
//
import UIKit


class FSJGalleryController: UICollectionViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = false
        self.extendedLayoutIncludesOpaqueBars = false
    }
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GalleryCell", forIndexPath: indexPath) as! FSJPreviewCell
        
        //cell.configureCell(self.results[indexPath.row])
        return cell
    }


}