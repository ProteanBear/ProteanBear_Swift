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
class PbUICollectionViewCellForImage:UICollectionViewCell
{
    //imageView:图片
    let imageView=UIImageView(frame:CGRectZero)
    
    //重载构造方法
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder:aDecoder)
        self.setup()
    }
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.setup()
    }
    
    //setup:初始化
    func setup()
    {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.contentMode=UIViewContentMode.ScaleAspectFill
        self.addSubview(self.imageView)
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[imageView]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline,metrics:nil, views: ["imageView":self.imageView]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[imageView]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline,metrics:nil, views: ["imageView":self.imageView]))
    }
}
