//
//  PbTestForCollectionViewController.swift
//  swiftPbTest
//
//  Created by Maqiang on 15/7/6.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation
import UIKit

class PbTestForCollectionViewController:PbUICollectionViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //设置布局
        let layout=UICollectionViewFlowLayout()
        let cellWidth=((PbSystem.screenCurrentWidth()-16)/2)-16
        layout.itemSize=CGSizeMake(cellWidth,(cellWidth) * 3/4)
        layout.minimumLineSpacing=8
        layout.minimumInteritemSpacing=8
        layout.sectionInset=UIEdgeInsetsMake(8, 8, 8, 8)
        layout.scrollDirection=UICollectionViewScrollDirection.Vertical
        self.collectionView?.setCollectionViewLayout(layout, animated: false)
        
        //载入数据
        PbDataAppController.getInstance.requestWithKey("userLogin", params: NSDictionary(objects:["moru_1982.student@sina.com.cn",NSString(string:"123456".md5()).substringFromIndex(16)],forKeys:["account","pwd"]), callback: { (data, error, property) -> Void in
            
            if(data != nil)
            {
                var status:Int?=data.objectForKey("status") as? Int
                if(status != nil)
                {
                    if(status==0)
                    {
                        self.pbLoadData(PbDataUpdateMode.First)
                    }
                }
            }
            
            }, getMode: PbDataGetMode.FromNet)
    }
    
    override func pbKeyForDataLoad() -> String?
    {
        return "busiNews"
    }
    
    override func pbResolveFromResponse(response: NSDictionary) -> AnyObject?
    {
        var dataList:NSArray?
        
        var statusObj: AnyObject?=response.objectForKey("status")
        if(statusObj != nil)
        {
            var status=statusObj as! Int
            if(status == 0)
            {
                let result=response.objectForKey("result") as! NSDictionary
                dataList=result.objectForKey("dataList") as? NSArray
            }
            else
            {
                self.pbErrorForDataLoad(PbUIViewControllerErrorType.ServerError, error:(response.objectForKey("message") as! String))
            }
        }
        
        return dataList
    }
    
    override func pbIdentifierForCollectionView(indexPath: NSIndexPath, data: NSDictionary?) -> String
    {
        return "PbUICellTestCollectionView"
    }
    
    override func pbSetDataForCollectionView(cell: AnyObject, data: NSDictionary?, photoRecord: PbDataPhotoRecord?, indexPath: NSIndexPath) -> AnyObject
    {
        let cell=cell as! PbTestUICollectionCell
        
        cell.titleLabel.text=data!.objectForKey("title") as! String?
        
        if(photoRecord != nil)
        {
            switch(photoRecord!.state)
            {
            case .New:
                self.pbAddPhotoTaskToQueue(indexPath, data: data)
                cell.imageView.image=UIImage(named:"default_placeholder")
            case .Downloaded:
                cell.imageView.displayAnimation(photoRecord?.image)
            case .Failed:
                cell.imageView.image=UIImage(named:"default_placeholder")
            default:
                cell.imageView.image=UIImage(named:"default_placeholder")
            }
        }
        else
        {
            //设置默认图片
            cell.imageView.image=UIImage(named:"default_placeholder")
        }
        
        return cell
    }
    
    override func pbPhotoKeyInIndexPath(indexPath: NSIndexPath) -> String?
    {
        return "attachUrl"
    }
    
    override func pbFullUrlForDataLoad(url: String?) -> String?
    {
        var result=url
        
        if(result != nil)
        {
            if(result!.hasPrefix("http:"))
            {
                
            }
            else
            {
                result="http://125.64.14.199/"+result!
            }
        }
        
        return result
    }
    
    override func pbPageKeyForDataLoad() -> String
    {
        return "pageNum"
    }
}
