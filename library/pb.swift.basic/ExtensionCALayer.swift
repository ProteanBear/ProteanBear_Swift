//
//  ExtensionCALayer.swift
//  PbSwiftDemo
//
//  Created by Maqiang on 15/8/30.
//  Copyright (c) 2015年 ProteanBear. All rights reserved.
//

import Foundation
import QuartzCore

extension CALayer
{
    //Normal Animation
    public class func pbAnimation(create keyPath:String,duration:CFTimeInterval,fromValue:AnyObject,toValue:AnyObject) -> CABasicAnimation
    {
        let anim=CABasicAnimation(keyPath:keyPath)
        anim.fromValue = fromValue
        anim.toValue   = toValue
        anim.repeatCount = 0
        anim.duration = duration
        return anim
    }
    
    //Spring Animation
    public class func pbAnimation(createSpring keyPath:String,duration:CFTimeInterval,usingSpringWithDamping damping:Float,initialSpringVelocity velocity:Float,fromValue:Float,toValue:Float) -> CAKeyframeAnimation
    {
        let values=CALayer.pbAnimationValues(fromValue, toValue: toValue, usingSpringWithDamping: damping, initialSpringVelocity: velocity, duration: duration)
        let anim = CAKeyframeAnimation(keyPath: keyPath)
        anim.values = values;
        anim.duration = duration;
        
        return anim
    }
    
    fileprivate class func pbAnimationValues(_ fromValue:Float,toValue:Float,usingSpringWithDamping damping:Float,initialSpringVelocity velocity:Float,duration:Double) -> [AnyObject]
    {
        //60个关键帧
        let numOfPoints:Int=Int(duration * 60)
        let values=NSMutableArray(capacity:numOfPoints)
        for _ in 0 ..< numOfPoints
        {
            values.add(CGFloat(0))
        }
        
        //差值
        let dValue:Float=toValue-fromValue
        for point in 0 ..< numOfPoints
        {
            let x=Double(point)/Double(numOfPoints)
            let value=Double(toValue)-Double(dValue)*pow(M_E,Double(-Double(damping)*x))*Double(cos(Double(velocity)*x))
            values[point]=Float(value)
        }
        
        return values as [AnyObject]
    }
}
