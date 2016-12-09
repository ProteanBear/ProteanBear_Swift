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
    /// 异步载入网络图片，会自动先从缓存读取，如没有再从网络下载，并在下载完成后淡入效果显示
    /// - parameter url:图片链接地址
    public func pbLoadWith(_ url:String)
    {
        self.pbLoadWith(url,scale:nil)
    }
    
    /// 异步载入网络图片(指定显示的比例)，会自动先从缓存读取，如没有再从网络下载，并在下载完成后淡入效果显示
    /// - parameter url     :图片链接地址
    /// - parameter scale   :显示比例宽比高，如4/3；默认小于这个比例用scaleAspectFill，大于比例用scaleAspectFit
    public func pbLoadWith(_ url:String,scale:Float?)
    {
        self.pbLoadWith(url, scale: scale, lowMode: UIViewContentMode.scaleAspectFill, overMode: UIViewContentMode.scaleAspectFit)
    }
    
    /// 异步载入网络图片(指定显示的比例)，会自动先从缓存读取，如没有再从网络下载，并在下载完成后淡入效果显示
    /// - parameter url     :图片链接地址
    /// - parameter scale   :显示比例宽比高，如4/3
    /// - parameter lowMode :小于比例时的显示模式
    /// - parameter overMode:大于比例时的显示模式
    public func pbLoadWith(_ url:String,scale:Float?,lowMode:UIViewContentMode,overMode:UIViewContentMode)
    {
        //网络格式错误
        if(!url.hasPrefix("http"))
        {
            let image=UIImage(named: url)
            self.pbAnimation(image,scale:scale,lowMode:lowMode,overMode:overMode)
            return
        }
        
        //读取本地图片
        let image=PbDataAppController.instance.imageInLocalCache(url)
        
        //本地图片存在，显示图片
        if(image != nil)
        {
            self.pbAnimation(image,scale:scale,lowMode:lowMode,overMode:overMode)
        }
        //本地图片不存在，访问网络数据
        else
        {
            PbDataAppController.instance.requester?.requestForResource(url, callback: { (data, response, error) -> Void in
                
                if(data != nil)
                {
                    //显示图片
                    self.pbAnimation(UIImage(data: data!),scale:scale,lowMode:lowMode,overMode:overMode)
                    PbLog.debug("UIImageView:loadWithUrl:载入图片("+url+")完成")
                    //记录图片到缓存
                    PbDataAppController.instance.saveImageIntoLocalCache(data!, forUrl:url)
                }
                else
                {
                    PbLog.error("UIImageView:loadWithUrl:未获取到图片:"+(error?.description)!)
                }
            })
        }
    }
    
    /// 根据指定的比例设置图片视图显示模式
    /// - parameter scale   :显示比例宽比高，如4/3；默认小于这个比例用scaleAspectFill，大于比例用scaleAspectFit
    public func pbAutoSetContentMode(_ scale:Float?)
    {
        self.pbAutoSetContentMode(scale, lowMode: .scaleAspectFill, overMode: .scaleAspectFit)
    }
    
    /// 根据指定的比例设置图片视图显示模式
    /// - parameter scale   :显示比例宽比高，如4/3
    /// - parameter lowMode :小于比例时的显示模式
    /// - parameter overMode:大于比例时的显示模式
    public func pbAutoSetContentMode(_ scale:Float?,lowMode:UIViewContentMode,overMode:UIViewContentMode)
    {
        if(self.image == nil || scale == nil){return}
        
        let width=self.image?.cgImage?.width
        let height=self.image?.cgImage?.height
        
        let isFill=(scale > Float(width!/height!))
        
        self.contentMode=isFill ? lowMode : overMode
    }
    
    /// 指定设置比例并动画显示图片
    /// - parameter image   :图片
    /// - parameter scale   :显示比例宽比高，如4/3；默认小于这个比例用scaleAspectFill，大于比例用scaleAspectFit
    public func pbSet(_ image:UIImage,scale:Float?)
    {
        self.pbAnimation(image, scale:scale, lowMode: UIViewContentMode.scaleAspectFill, overMode: UIViewContentMode.scaleAspectFit)
    }
    
    /// 指定设置比例并动画显示图片
    /// - parameter image   :图片
    /// - parameter scale   :显示比例宽比高，如4/3
    /// - parameter lowMode :小于比例时的显示模式
    /// - parameter overMode:大于比例时的显示模式
    public func pbSet(_ image:UIImage,scale:Float?,lowMode:UIViewContentMode,overMode:UIViewContentMode)
    {
        self.pbAnimation(image, scale:scale, lowMode:lowMode,overMode:overMode)
    }
    
    /// 动画（淡入）显示图片
    /// - parameter image   :图片
    public func pbAnimation(_ image:UIImage?)
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
    
    /// 动画（淡入）显示图片载入完成
    /// - parameter image   :图片
    /// - parameter scale   :显示比例宽比高，如4/3
    /// - parameter lowMode :小于比例时的显示模式
    /// - parameter overMode:大于比例时的显示模式
    public func pbAnimation(_ image:UIImage?,scale:Float?,lowMode:UIViewContentMode,overMode:UIViewContentMode)
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
            self.pbAutoSetContentMode(scale, lowMode: lowMode, overMode: overMode)
        }
    }
}
