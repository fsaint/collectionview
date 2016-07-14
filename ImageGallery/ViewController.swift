//
//  ViewController.swift
//  ImageGallery
//
//  Created by Felipe Saint-jean on 7/14/16.
//  Copyright © 2016 Felipe Saint-jean. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

    @IBAction func presentImageSelector(sender: AnyObject) {
        FSJGalleryController.presentFrom(self) { (assets) in
            print("Got assets")
        }
    }
}
