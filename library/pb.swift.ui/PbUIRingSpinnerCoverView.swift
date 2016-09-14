//
//  PbUIRingSpinnerCoverView.swift
//  pb.swift.ui
//  载入指示器遮盖层
//  Created by Maqiang on 15/7/3.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation
import UIKit

open class PbUIRingSpinnerCoverView:UIView,PbUIActivityIndicator
{
    //indicator:指示器
    let indicator=PbUIRingSpinnerView(frame: CGRect.zero)
    
    //init:初始化
    override public init(frame: CGRect)
    {
        super.init(frame: frame)
        setup()
    }
    
    //init:初始化
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder:aDecoder)
        setup()
    }
    
    //tintColorDidChange:颜色改变时处理
    override open func tintColorDidChange()
    {
        super.tintColorDidChange()
        
        self.indicator.tintColor=self.tintColor
    }
    
    //startAnimating:开始载入动画public 
    open func startAnimating()
    {
        self.isHidden=false
        self.indicator.startAnimating()
    }
    
    //startAnimating:关闭载入动画
    open func stopAnimating()
    {
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 0.6, options: [], animations: { () -> Void in
            
            self.layer.opacity=0
            
        }) { (isCompleted) -> Void in
            
            if(isCompleted)
            {
                self.isHidden=true
                self.indicator.stopAnimating()
            }
            
        }
    }
    
    //setup:初始化动画层处理显示
    fileprivate func setup()
    {
        indicator.bounds=CGRect(x: 0, y: 0, width: 40, height: 40);
        indicator.tintColor=UIColor(red:215/255, green: 49/255, blue: 69/255, alpha: 1)
        indicator.center=CGPoint(x: self.bounds.midX, y: self.bounds.midY-64);
        indicator.stopAnimating()
        
        self.addSubview(indicator)
        self.bringSubview(toFront: indicator)
    }
}
