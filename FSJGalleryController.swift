//
//  FSJGalleryController.swift
//  ImageGallery
//
//  Created by Felipe Saint-jean on 7/13/16.
//  Copyright © 2016 Felipe Saint-jean. All rights reserved.
//
import UIKit
import Photos


class FSJGalleryController: UICollectionViewController, PHPhotoLibraryChangeObserver {
    
    var all_assets: PHFetchResult = PHAsset.fetchAssetsWithOptions(nil)
    
    var selected_assets: [PHAsset] = []

    var onReady: (([PHAsset])-> Void)? = nil
    
    var onCancel: ((UIViewController)->Void)? = nil
    
    @IBOutlet weak var select_button: UIBarButtonItem!
    
    
    func reloadAssets(){
        self.all_assets =  PHAsset.fetchAssetsWithOptions(nil)
        self.collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = false
        self.extendedLayoutIncludesOpaqueBars = false
        
        PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) in
            self.reloadAssets()
            
        })
        
        PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
        
        self.select_button.enabled = false
        
    }
    
    func photoLibraryDidChange(changeInstance: PHChange) {
        self.reloadAssets()
    }
    
    deinit {
        PHPhotoLibrary.sharedPhotoLibrary().unregisterChangeObserver(self)
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return all_assets.count
    }
    
    
    @IBAction func selectImages(sender: AnyObject) {
        if let onReady = onReady {
            onReady(self.selected_assets)
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        let w = Int(self.view.bounds.width)
        
        for i in 4...6 {
            if w % i == 0 {
                if let flowLayout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
                    flowLayout.itemSize = CGSize(width: w/i, height: w/i)
                }

                return
            }
        }
        
        /* Default to 4 rows if could not find match */
        if let flowLayout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: w/4, height: w/4)
        }
        
    }
    
    @IBAction func cancelSelection(sender: AnyObject) {
        if let onCancel = onCancel {
            onCancel(self)
        }
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GalleryCell", forIndexPath: indexPath) as! FSJPreviewCell
        
        let manager = PHImageManager.defaultManager()
        
        if cell.tag != 0 {
            manager.cancelImageRequest(PHImageRequestID(cell.tag))
        }
        
        let initialRequestOptions = PHImageRequestOptions()
        initialRequestOptions.synchronous = true
        initialRequestOptions.resizeMode = .Fast
        initialRequestOptions.deliveryMode = .FastFormat
        
        if let asset = all_assets.objectAtIndex(all_assets.count - indexPath.row - 1) as? PHAsset {
            let request_id = manager.requestImageForAsset(asset,
                                         targetSize: CGSize(width: 86.0, height: 86.0),
                                         contentMode: .AspectFit,
                                         options: initialRequestOptions) { (initialResult, _) in
                
                                            cell.preview.image = initialResult
            }
            
            cell.tag = Int(request_id)

            
            if self.selected_assets.contains(asset) {
                cell.selectionIndex.alpha = 1.0
                let index = self.selected_assets.indexOf(asset)!
                cell.selectionIndex.text = "\(index + 1)"
                
            }else{
                cell.selectionIndex.alpha = 0.0
            }

            
        }else{
            cell.tag = 0
        }
        
        
        
        //cell.configureCell(self.results[indexPath.row])
        return cell
    }

    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let asset = all_assets.objectAtIndex(all_assets.count - indexPath.row - 1) as? PHAsset {
            if self.selected_assets.contains(asset) {
                /* had a value. Need to deselect */
                let index = self.selected_assets.indexOf(asset)!
                self.selected_assets.removeAtIndex(index)
                self.collectionView?.reloadData()
            }else{
                /* no value, make the last */
                self.selected_assets.append(asset)
                 self.collectionView?.reloadItemsAtIndexPaths([indexPath])
            }
            
        
        }
        
        
        if self.selected_assets.count >= 1 {
            self.select_button.enabled = true
        }else{
            self.select_button.enabled = false
        }
        
    }

    
    class func presentFrom(viewController: UIViewController){
        
        guard let nav = UIStoryboard(name: "FSJGallery", bundle: nil).instantiateInitialViewController() as? UINavigationController else {return}
        guard let gallery = nav.viewControllers[0] as? FSJGalleryController  else {return}
        
        gallery.onCancel = { _ in
            nav.dismissViewControllerAnimated(true, completion: nil)
        }
        
        gallery.onReady = { assets  in
            nav.dismissViewControllerAnimated(true, completion: nil)
        }
        
        viewController.presentViewController(nav, animated: true) {
            
        }
    }
    
}