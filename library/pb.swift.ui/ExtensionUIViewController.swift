//
//  ExtensionUIViewController.swift
//  pb.swift.ui
//  扩展视图控制器，增加数据绑定载入处理方法
//  Created by Maqiang on 15/6/29.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation
import UIKit

/*PbMsyPosition:
 *  消息显示位置
 */
public enum PbMsyPosition:Int
{
    case Top,Bottom
}

extension UIViewController
{
    //pbLoadData:获取数据
    public func pbLoadData(updateMode:PbDataUpdateMode,controller:PbUIViewControllerProtocol?)
    {
        PbDataAdapter(delegate:controller).loadData(updateMode)
    }
    
    //pbMsgTip:提示信息
    public func pbMsgTip(msg:String,dismissAfterSecond:NSTimeInterval,position:PbMsyPosition)
    {
        //创建元素
        let label=UILabel(frame:CGRectZero)
        label.translatesAutoresizingMaskIntoConstraints=false
        label.backgroundColor=UIColor(white:0, alpha:0.7)
        label.textColor=UIColor.whiteColor()
        label.font=UIFont.systemFontOfSize(14)
        label.layer.cornerRadius=4
        label.clipsToBounds=true
        label.textAlignment = .Center
        label.numberOfLines=0
        label.text=msg
        label.layer.opacity=0
        self.view.addSubview(label)
        
        //计算尺寸
        let minSize:CGFloat=200.0
        let margin:CGFloat=10.0
        let size=NSString(string:msg).boundingRectWithSize(CGSizeMake(minSize,minSize), options: .UsesLineFragmentOrigin, attributes:["NSFontAttributeName":label.font], context:nil).size
        
        //设置布局
        self.view.addConstraint(NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[label(==width)]", options: .AlignAllBaseline, metrics: ["width":minSize], views:["label":label]))
        if(position == .Top)
        {
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-margin-[label(==height)]", options: .AlignAllBaseline, metrics:["height":size.height+margin,"margin":margin], views:["label":label]))
        }
        if(position == .Bottom)
        {
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[label(==height)]-margin-|", options: .AlignAllBaseline, metrics: ["height":size.height+margin,"margin":margin], views:["label":label]))
        }
        
        //显示元素
        UIView.animateWithDuration(0.3, delay: 0, options:.CurveEaseInOut, animations: { () -> Void in
                label.layer.opacity=1
            }) { (finished) -> Void in
                if(finished)
                {
                    //隐藏元素
                    UIView.animateWithDuration(0.3, delay: dismissAfterSecond, options: .CurveEaseInOut, animations: { () -> Void in
                            label.layer.opacity=0
                        }, completion: { (isFinished) -> Void in
                            if(isFinished)
                            {
                                label.removeFromSuperview()
                            }
                    })
                }
        }
    }
}