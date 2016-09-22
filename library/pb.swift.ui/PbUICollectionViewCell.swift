//
//  PbUICollectionViewCell.swift
//  PbSwiftDemo
//
//  Created by Maqiang on 15/9/3.
//  Copyright (c) 2015年 ProteanBear. All rights reserved.
//

import Foundation
import UIKit

//PbUICollectionViewCellForImage:图片单元格
open class PbUICollectionViewCellForImage:UICollectionViewCell
{
    //imageView:图片
    let imageView=UIImageView(frame:CGRect.zero)
    
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
    
    //setup:初始化
    func setup()
    {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.contentMode=UIViewContentMode.scaleAspectFill
        self.addSubview(self.imageView)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[imageView]-0-|", options: NSLayoutFormatOptions.alignAllLastBaseline,metrics:nil, views: ["imageView":self.imageView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[imageView]-0-|", options: NSLayoutFormatOptions.alignAllLastBaseline,metrics:nil, views: ["imageView":self.imageView]))
    }
}
