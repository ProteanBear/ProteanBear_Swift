//
//  PbUIRingSpinnerView.swift
//  pb.swift.ui
//  载入指示器
//  Created by Maqiang on 15/7/2.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation
import UIKit

open class PbUIRingSpinnerView:UIView,PbUIActivityIndicator
{
    //animationName:记录动画名称
    let animationName="PbUIRingSpinnerViewAnimation"
    //isAnimating:记录是否动画中
    var isAnimating=false
    //processLayer:动画层
    let processLayer=CAShapeLayer()
    //lineWidth:
    var lineWidth:CGFloat=1.5{
        didSet{
            self.processLayer.lineWidth=self.lineWidth
            self.updatePath()
        }
    }
    
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
    
    //layoutSubviews:设置指示器大小
    override open func layoutSubviews()
    {
        super.layoutSubviews()
        self.processLayer.frame=CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        self.updatePath()
    }
    
    //tintColorDidChange:颜色改变时处理
    override open func tintColorDidChange()
    {
        super.tintColorDidChange()
        self.processLayer.strokeColor=self.tintColor.cgColor
    }
    
    //startAnimating:开始载入动画
    open func startAnimating()
    {
        if(isAnimating){return}
        self.isHidden=false
        
        let animation=CABasicAnimation()
        animation.keyPath="transform.rotation"
        animation.duration=1.0
        animation.fromValue=0.0
        animation.toValue=2 * M_PI
        animation.repeatCount=Float(Int.max)
        animation.timingFunction=CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        
        self.processLayer.add(animation, forKey:animationName)
        self.isAnimating = true
    }
    //startAnimating:关闭载入动画
    open func stopAnimating()
    {
        if(!isAnimating){return}
        
        self.processLayer.removeAnimation(forKey: animationName)
        self.isAnimating=false
        self.isHidden=true
    }
    
    //setup:初始化动画层处理显示
    fileprivate func setup()
    {
        self.processLayer.strokeColor=self.tintColor.cgColor
        self.processLayer.fillColor=nil
        self.processLayer.lineWidth=1.5
        self.layer.addSublayer(self.processLayer)
    }
    
    //updatePath:更新显示路径
    fileprivate func updatePath()
    {
        let center=CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        
        let val1=self.bounds.width/2
        let val2=self.bounds.height/2
        let redius:CGFloat=(val1<val2 ? val1:val2)-(self.processLayer.lineWidth/2)
        
        let startAngle:CGFloat=CGFloat(-M_PI_4)
        let endAngle:CGFloat=CGFloat(3 * M_PI_2)
        
        let path=UIBezierPath(arcCenter: center, radius: redius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        self.processLayer.path=path.cgPath
    }
}
