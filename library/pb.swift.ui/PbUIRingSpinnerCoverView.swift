//
//  PbUIRingSpinnerCoverView.swift
//  pb.swift.ui
//  载入指示器遮盖层
//  Created by Maqiang on 15/7/3.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation
import UIKit

public class PbUIRingSpinnerCoverView:UIView,PbUIActivityIndicator
{
    //indicator:指示器
    let indicator=PbUIRingSpinnerView(frame: CGRectZero)
    
    //init:初始化
    override init(frame: CGRect)
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
    override public func tintColorDidChange()
    {
        super.tintColorDidChange()
        
        self.indicator.tintColor=self.tintColor
    }
    
    //startAnimating:开始载入动画public 
    public func startAnimating()
    {
        self.hidden=false
        self.indicator.startAnimating()
    }
    
    //startAnimating:关闭载入动画
    public func stopAnimating()
    {
        UIView.animateWithDuration(0.5, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 0.6, options: [], animations: { () -> Void in
            
            self.layer.opacity=0
            
        }) { (isCompleted) -> Void in
            
            if(isCompleted)
            {
                self.hidden=true
                self.indicator.stopAnimating()
            }
            
        }
    }
    
    //setup:初始化动画层处理显示
    private func setup()
    {
        indicator.bounds=CGRectMake(0, 0, 40, 40);
        indicator.tintColor=UIColor(red:215/255, green: 49/255, blue: 69/255, alpha: 1)
        indicator.center=CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)-64);
        indicator.stopAnimating()
        
        self.addSubview(indicator)
        self.bringSubviewToFront(indicator)
    }
}
