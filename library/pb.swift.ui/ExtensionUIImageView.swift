//
//  ExtensionUIImageView.swift
//  pb.swift.ui
//  扩展图片视图对象
//  Created by Maqiang on 15/6/23.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation
import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


extension UIImageView
{
    //loadWithUrl:异步载入网络图片
    public func loadWithUrl(_ urlString:String)
    {
        self.loadWithUrl(urlString,scale:nil)
    }
    
    //loadWithUrl:异步载入网络图片(指定显示的比例)
    public func loadWithUrl(_ urlString:String,scale:Float?)
    {
        self.loadWithUrl(urlString, scale: scale, lowMode: UIViewContentMode.scaleAspectFill, overMode: UIViewContentMode.scaleAspectFit)
    }
    
    //loadWithUrl:异步载入网络图片(指定显示的比例)
    public func loadWithUrl(_ urlString:String,scale:Float?,lowMode:UIViewContentMode,overMode:UIViewContentMode)
    {
        //网络格式错误
        if(!urlString.hasPrefix("http:"))
        {
            let image=UIImage(named: urlString)
            self.displayAnimation(image,scale:scale,lowMode:lowMode,overMode:overMode)
            return
        }
        
        //读取本地图片
        let image=PbDataAppController.getInstance.imageInLocalCache(urlString)
        
        //本地图片存在，显示图片
        if(image != nil)
        {
            self.displayAnimation(image,scale:scale,lowMode:lowMode,overMode:overMode)
        }
        //本地图片不存在，访问网络数据
        else
        {
            PbDataRequesterHttp().requestForResource(urlString, callback: { (data, response, error) -> Void in
                if(data != nil)
                {
                    //显示图片
                    self.displayAnimation(UIImage(data: data),scale:scale,lowMode:lowMode,overMode:overMode)
                    PbLog.debug("UIImageView:loadWithUrl:载入图片("+urlString+")完成")
                    //记录图片到缓存
                    PbDataAppController.getInstance.saveImageIntoLocalCache(data, forUrl:urlString)
                }
                else
                {
                    PbLog.error("UIImageView:loadWithUrl:未获取到图片:"+error.description)
                }
            })
        }
    }
    
    //autoSetContentMode:根据指定的比例设置图片视图显示模式
    public func autoSetContentMode(_ scale:Float?)
    {
        self.autoSetContentMode(scale, lowMode: UIViewContentMode.scaleAspectFill, overMode: UIViewContentMode.scaleAspectFit)
    }
    
    //autoSetContentMode:根据指定的比例设置图片视图显示模式
    public func autoSetContentMode(_ scale:Float?,lowMode:UIViewContentMode,overMode:UIViewContentMode)
    {
        if(self.image == nil || scale == nil){return}
        
        let width=self.image?.cgImage?.width
        let height=self.image?.cgImage?.height
        
        let isFill=(scale > Float(width!/height!))
        
        self.contentMode=isFill ? lowMode : overMode
    }
    
    //setImage:指定设置比例并动画显示图片
    public func setImage(_ image:UIImage,scale:Float?)
    {
        self.displayAnimation(image, scale:scale, lowMode: UIViewContentMode.scaleAspectFill, overMode: UIViewContentMode.scaleAspectFit)
    }
    
    //setImage:指定设置比例并动画显示图片
    public func setImage(_ image:UIImage,scale:Float?,lowMode:UIViewContentMode,overMode:UIViewContentMode)
    {
        self.displayAnimation(image, scale:scale, lowMode:lowMode,overMode:overMode)
    }
    
    //displayAnimation:动画显示图片
    public func displayAnimation(_ image:UIImage?)
    {
        if(image != nil)
        {
            //渐现进入
            self.alpha=0
            self.image=image
            self.setNeedsLayout()
            UIView.animate(withDuration: 1.5,delay:0.2, usingSpringWithDamping:1, initialSpringVelocity:0.5, options: [], animations: { () -> Void in
                
                self.alpha=1
                
                }, completion: { (isCompleted) -> Void in
                    
                    if(isCompleted)
                    {
                    }
                    
            })
        }
    }
    
    //displayAnimation:动画显示图片载入完成
    public func displayAnimation(_ image:UIImage?,scale:Float?,lowMode:UIViewContentMode,overMode:UIViewContentMode)
    {
        if(image != nil)
        {
            //渐现进入
            self.alpha=0
            self.image=image
            self.setNeedsLayout()
            UIView.animate(withDuration: 1,delay:0, usingSpringWithDamping:1, initialSpringVelocity:0.5, options: [], animations: { () -> Void in
                
                self.alpha=1
                
                }, completion: { (isCompleted) -> Void in
                    
                    if(isCompleted)
                    {
                    }
                    
            })
            
            //自动设置比例
            self.autoSetContentMode(scale, lowMode: lowMode, overMode: overMode)
        }
    }
}
