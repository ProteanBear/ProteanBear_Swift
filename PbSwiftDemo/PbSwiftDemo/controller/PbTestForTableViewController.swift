//
//  PbTestForTableViewController.swift
//  swiftPbTest
//
//  Created by Maqiang on 15/6/30.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation
import UIKit

class PbTestForTableViewController:PbUITableViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //载入数据
        PbDataAppController.getInstance.requestWithKey("userLogin", params: NSDictionary(objects:["moru_1982.student@sina.com.cn",NSString(string:"123456".md5()).substringFromIndex(16)],forKeys:["account","pwd"]), callback: { (data, error, property) -> Void in
            
            if(data != nil)
            {
                let status:Int?=data.objectForKey("status") as? Int
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
        
        let statusObj: AnyObject?=response.objectForKey("status")
        if(statusObj != nil)
        {
            let status=statusObj as! Int
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
    
    override func pbIdentifierForTableView(indexPath: NSIndexPath, data: AnyObject?) -> String
    {
        return "PbUICellTestTableView"
    }
    
    override func pbSetDataForTableView(cell: AnyObject, data: AnyObject?,photoRecord:PbDataPhotoRecord?,indexPath: NSIndexPath) -> AnyObject
    {
        let cell=cell as! PbTestUITableCell
        
        cell.titleLabel.text=data!.objectForKey("title") as! String?
        cell.summaryLabel.text=data!.objectForKey("summary") as! String?
        
        if(photoRecord != nil)
        {
            switch(photoRecord!.state)
            {
            case .New:
                self.pbAddPhotoTaskToQueue(indexPath, data: data)
                cell.titleImage.image=UIImage(named:"default_placeholder")
            case .Downloaded:
                cell.titleImage.displayAnimation(photoRecord?.image)
            case .Failed:
                cell.titleImage.image=UIImage(named:"default_placeholder")
            default:
                cell.titleImage.image=UIImage(named:"default_placeholder")
            }
        }
        else
        {
            //设置默认图片
            cell.titleImage.image=UIImage(named:"default_placeholder")
        }
        
        return cell
    }
    
    override func pbNormalHeightForRowAtIndexPath(tableView: UITableView, indexPath: NSIndexPath) -> CGFloat
    {
        return 120
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