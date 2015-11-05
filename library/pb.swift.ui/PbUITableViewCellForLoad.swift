//
//  PbUITableViewCellForLoad.swift
//  pb.swift.ui
//  表格单元格：用于底部载入时使用
//  Created by Maqiang on 15/6/29.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation
import UIKit

public class PbUITableViewCellForLoad:UITableViewCell
{
    //indicator:载入指示器
    private var indicator=UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    //startLoadAnimating:开始载入动画
    func startLoadAnimating()
    {
        self.indicator.startAnimating()
    }
    
    //stopLoadAnimating:开始载入动画
    func stopLoadAnimating()
    {
        self.indicator.stopAnimating()
    }
    
    //setIndicatorTiniColor:设置指示器主题颜色
    func setIndicatorTiniColor(tiniColor:UIColor)
    {
        self.indicator.tintColor=tiniColor
    }

    //重载构造方法
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder:aDecoder)
        self.setup()
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style:style, reuseIdentifier:reuseIdentifier)
        self.setup()
    }
    
    //setup:初始化载入指示器
    private func setup()
    {
        self.indicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.indicator)
        
        self.addConstraint(NSLayoutConstraint(item: self.indicator, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.indicator, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
    }
}
