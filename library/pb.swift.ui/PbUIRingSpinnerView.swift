//
//  PbUIRingSpinnerView.swift
//  pb.swift.ui
//  载入指示器
//  Created by Maqiang on 15/7/2.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation
import UIKit

class PbUIRingSpinnerView:UIView,PbUIActivityIndicator
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
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setup()
    }

    //init:初始化
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder:aDecoder)
        setup()
    }
    
    //layoutSubviews:设置指示器大小
    override func layoutSubviews()
    {
        super.layoutSubviews()
        self.processLayer.frame=CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))
        self.updatePath()
    }
    
    //tintColorDidChange:颜色改变时处理
    override func tintColorDidChange()
    {
        super.tintColorDidChange()
        self.processLayer.strokeColor=self.tintColor.CGColor
    }
    
    //startAnimating:开始载入动画
    func startAnimating()
    {
        if(isAnimating){return}
        self.hidden=false
        
        let animation=CABasicAnimation()
        animation.keyPath="transform.rotation"
        animation.duration=1.0
        animation.fromValue=0.0
        animation.toValue=2 * M_PI
        animation.repeatCount=Float(Int.max)
        animation.timingFunction=CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        
        self.processLayer.addAnimation(animation, forKey:animationName)
        self.isAnimating = true
    }
    //startAnimating:关闭载入动画
    func stopAnimating()
    {
        if(!isAnimating){return}
        
        self.processLayer.removeAnimationForKey(animationName)
        self.isAnimating=false
        self.hidden=true
    }
    
    //setup:初始化动画层处理显示
    private func setup()
    {
        self.processLayer.strokeColor=self.tintColor.CGColor
        self.processLayer.fillColor=nil
        self.processLayer.lineWidth=1.5
        self.layer.addSublayer(self.processLayer)
    }
    
    //updatePath:更新显示路径
    private func updatePath()
    {
        let center=CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
        
        let val1=CGRectGetWidth(self.bounds)/2
        let val2=CGRectGetHeight(self.bounds)/2
        let redius:CGFloat=(val1<val2 ? val1:val2)-(self.processLayer.lineWidth/2)
        
        let startAngle:CGFloat=CGFloat(-M_PI_4)
        let endAngle:CGFloat=CGFloat(3 * M_PI_2)
        
        let path=UIBezierPath(arcCenter: center, radius: redius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        self.processLayer.path=path.CGPath
    }
}
