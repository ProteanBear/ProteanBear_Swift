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
    case top,bottom
}

extension UIViewController
{
    /// 获取数据,这种扩展方式需要实现协议
    /// - parameter updateMode:数据更新模式
    /// - parameter controller:协议实现对象
    public func pbLoadData(_ updateMode:PbDataUpdateMode,controller:PbUIViewControllerProtocol?)
    {
        PbDataAdapter(delegate:controller).loadData(updateMode)
    }
    
    /// 提示信息，注意有些表格或网格视图底部显示时会看不到
    /// - parameter msg                 :提示信息
    /// - parameter dismissAfterSecond  :消失时间，单位为秒
    /// - parameter position            :显示位置
    public func pbMsgTip(_ msg:String,dismissAfterSecond:TimeInterval,position:PbMsyPosition)
    {
        //创建元素
        let label=UILabel(frame:CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints=false
        label.backgroundColor=UIColor(white:0, alpha:0.7)
        label.textColor=UIColor.white
        label.font=UIFont.systemFont(ofSize: 14)
        label.layer.cornerRadius=4
        label.clipsToBounds=true
        label.textAlignment = .center
        label.numberOfLines=0
        label.text=msg
        label.layer.opacity=0
        self.view.addSubview(label)
        
        //计算尺寸
        let minSize:CGFloat=200.0
        let margin:CGFloat=10.0
        let size=NSString(string:msg).boundingRect(with: CGSize(width: minSize,height: minSize), options: .usesLineFragmentOrigin, attributes:["NSFontAttributeName":label.font], context:nil).size
        
        //设置布局
        self.view.addConstraint(NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[label(==width)]", options: .alignAllLastBaseline, metrics: ["width":minSize], views:["label":label]))
        if(position == .top)
        {
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-margin-[label(==height)]", options: .alignAllLastBaseline, metrics:["height":size.height+margin,"margin":margin], views:["label":label]))
        }
        if(position == .bottom)
        {
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[label(==height)]-margin-|", options: .alignAllLastBaseline, metrics: ["height":size.height+margin,"margin":margin], views:["label":label]))
        }
        
        //显示元素
        UIView.animate(withDuration: 0.3, delay: 0, options:UIViewAnimationOptions(), animations: { () -> Void in
                label.layer.opacity=1
            }) { (finished) -> Void in
                if(finished)
                {
                    //隐藏元素
                    UIView.animate(withDuration: 0.3, delay: dismissAfterSecond, options: UIViewAnimationOptions(), animations: { () -> Void in
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
