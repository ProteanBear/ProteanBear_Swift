//
//  PbUICollectionViewCellForLoad.swift
//  pb.swift.ui
//  网格单元格：用于底部载入时使用
//  Created by Maqiang on 15/7/7.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation
import UIKit

open class PbUICollectionViewCellForLoad: UICollectionViewCell
{
    //indicator:载入指示器
    fileprivate var indicator=UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    //startLoadAnimating:开始载入动画
    open func startLoadAnimating()
    {
        self.indicator.startAnimating()
    }
    
    //stopLoadAnimating:开始载入动画
    open func stopLoadAnimating()
    {
        self.indicator.stopAnimating()
    }
    
    //setIndicatorTiniColor:设置指示器主题颜色
    open func setIndicatorTiniColor(_ tiniColor:UIColor)
    {
        self.indicator.tintColor=tiniColor
    }
    
    //重载构造方法
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder:aDecoder)
        self.setup()
    }
    
    override public init(frame: CGRect)
    {
        super.init(frame: frame)
        self.setup()
    }
    
    //setup:初始化载入指示器
    func setup()
    {
        self.indicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.indicator)
        
        self.addConstraint(NSLayoutConstraint(item: self.indicator, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.indicator, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
    }
}
