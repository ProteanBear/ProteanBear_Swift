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
    class func pbAnimation(create keyPath:String,duration:CFTimeInterval,fromValue:AnyObject,toValue:AnyObject) -> CABasicAnimation
    {
        let anim=CABasicAnimation(keyPath:keyPath)
        anim.fromValue = fromValue
        anim.toValue   = toValue
        anim.repeatCount = 0
        anim.duration = duration
        return anim
    }
    
    //Spring Animation
    class func pbAnimation(createSpring keyPath:String,duration:CFTimeInterval,usingSpringWithDamping damping:Float,initialSpringVelocity velocity:Float,fromValue:Float,toValue:Float) -> CAKeyframeAnimation
    {
        let dampingFactor:CGFloat=10.0
        let velocityFactor:CGFloat=10.0
        
        let values=CALayer.pbAnimationValues(fromValue, toValue: toValue, usingSpringWithDamping: damping, initialSpringVelocity: velocity, duration: duration)
        let anim = CAKeyframeAnimation(keyPath: keyPath)
        anim.values = values;
        anim.duration = duration;
        
        return anim
    }
    
    private class func pbAnimationValues(fromValue:Float,toValue:Float,usingSpringWithDamping damping:Float,initialSpringVelocity velocity:Float,duration:Double) -> [AnyObject]
    {
        //60个关键帧
        let numOfPoints:Int=Int(duration * 60)
        let values=NSMutableArray(capacity:numOfPoints)
        for(var i=0;i<numOfPoints;i++)
        {
            values.addObject(CGFloat(0))
        }
        
        //差值
        let dValue:Float=toValue-fromValue
        for(var point=0;point<numOfPoints;point++)
        {
            let x=Double(point)/Double(numOfPoints)
            let value=Double(toValue)-Double(dValue)*pow(M_E,Double(-Double(damping)*x))*Double(cos(Double(velocity)*x))
            values[point]=Float(value)
        }
        
        return values as [AnyObject]
    }
}