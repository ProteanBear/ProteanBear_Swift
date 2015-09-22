//
//  PbTestForPhotoManager.swift
//  swiftPbTest
//
//  Created by Maqiang on 15/6/30.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation
//
//  ViewController.swift
//  swiftPbTest
//
//  Created by Maqiang on 15/6/15.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import UIKit

class PbTestForPhotoManager: UIViewController
{
    
    @IBOutlet weak var image1: UIImageView!
    
    @IBOutlet weak var image2: UIImageView!
    
    @IBOutlet weak var image3: UIImageView!
    
    @IBOutlet weak var image4: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let manager=PbDataPhotoManager(downloadMaxCount: 1)
        manager.download(
            [
                PbDataPhotoRecord(urlString:"http://a.36krcnd.com/nil_class/67967e6c-ea12-4acd-9494-aa23bb16f959/QQ20150624-1_2x.jpg!heading", index: NSIndexPath(index: 1)),
                PbDataPhotoRecord(urlString:"http://b.36krcnd.com/nil_class/a5f9794b-2167-410e-a871-33f1c4cd8a5e/Screen_Shot_2015-06-26_at_1.58.41_PM.png!heading", index: NSIndexPath(index: 2)),
                PbDataPhotoRecord(urlString:"http://a.36krcnd.com/nil_class/fec542c5-a0d6-4860-bc30-80f4af6f0c49/yestone_HD_1122357753.jpg!heading", index: NSIndexPath(index: 3)),
                PbDataPhotoRecord(urlString:"http://d.36krcnd.com/nil_class/e991e235-1eb2-4ce3-b0fe-4d86b036f028/unnamed.jpg!heading", index: NSIndexPath(index: 4))
            ],
            callback: { (photoRecord) -> Void in
                
                if(photoRecord.indexPath==NSIndexPath(index:1))
                {
                    self.image1.setImage(photoRecord.image!,scale:16/9)
                }
                if(photoRecord.indexPath==NSIndexPath(index:2))
                {
                    self.image2.setImage(photoRecord.image!,scale:4/3)
                }
                if(photoRecord.indexPath==NSIndexPath(index:3))
                {
                    self.image3.setImage(photoRecord.image!,scale:9/16)
                }
                if(photoRecord.indexPath==NSIndexPath(index:4))
                {
                    self.image4.setImage(photoRecord.image!,scale:1)
                }
        })
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

