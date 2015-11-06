//
//  PbUIAnimatedPageControl.swift
//  PbSwiftDemo
//  来源于KYAnimatedPageControl，编写Swift版本
//  带有粘土果冻效果的页码切换器
//  Created by Maqiang on 15/8/29.
//  Copyright (c) 2015年 ProteanBear. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

//PbUIAnimatedPageControlIndicatorStyle:指示器类型
public enum PbUIAnimatedPageControlIndicatorStyle:Int
{
    case GooeyCircle,RotateRect
}

//PbUIAnimatedPageControlScrollDirection:滚动方向
public enum PbUIAnimatedPageControlScrollDirection:Int
{
    case None,Right,Left,Up,Down,Crazy
}

//PbUIAnimatedPageControlIndicator:指示器基类
public class PbUIAnimatedPageControlIndicator:CALayer
{
    //indicatorSize:
    var indicatorSize:CGFloat!{
        willSet
        {
            if(self.indicatorSize != nil
                && self.indicatorSize==newValue){return}
        }
    }
    //indicatorColor:
    var indicatorColor:UIColor!
    //currentRect:
    var currentRect:CGRect!
    //lastContentOffset:
    var lastContentOffset:CGFloat=0
    //scrollDirection:
    var scrollDirection=PbUIAnimatedPageControlScrollDirection.None
    
    //animateIndicator:
    public func animateIndicator(scrollView:UIScrollView,pageControl:PbUIAnimatedPageControl) -> Void {}
    //restoreAnimation:
    public func restoreAnimation(distince:Float) -> Void{}
    //restoreAnimation:
    public func restoreAnimation(distince:Float,after:NSTimeInterval) -> Void
    {
        UIView.animateWithDuration(after, animations: { () -> Void in
            }) { (isFinish) -> Void in
                if(isFinish)
                {
                    self.restoreAnimation(distince)
                }
        }
    }
}

//PbUIAnimatedPageControlIndicatorGooeyCircle:圆形指示器
class PbUIAnimatedPageControlIndicatorGooeyCircle:PbUIAnimatedPageControlIndicator
{
    //needsDisplayForKey:
    override class func needsDisplayForKey(key: String) -> Bool
    {
        if("factor" == key)
        {
            return true
        }
        
        return super.needsDisplayForKey(key)
    }
    
    //beginGooeyAnim:
    var beginGooeyAnim=false
    //factor:
    var factor:CGFloat!
    
    //init:重载构造方法
    override init()
    {
        super.init()
    }
    override init(layer: AnyObject)
    {
        super.init(layer:layer)
        
        let indicator=layer as! PbUIAnimatedPageControlIndicatorGooeyCircle
        self.indicatorSize=indicator.indicatorSize
        self.indicatorColor=indicator.indicatorColor
        self.currentRect=indicator.currentRect
        self.lastContentOffset=indicator.lastContentOffset
        self.scrollDirection=indicator.scrollDirection
        self.factor=indicator.factor
    }
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    //drawInContext:重构绘制UI的方法
    override func drawInContext(ctx: CGContext)
    {
        //设置3.6 出来的弧度最像圆形
        let offset=self.currentRect.size.width/3.6
        let rectCenter=CGPointMake(self.currentRect.origin.x + self.currentRect.size.width/2 , self.currentRect.origin.y + self.currentRect.size.height/2)
        
        //8个控制点实际的偏移距离。 The real distance of 8 control points.
        let extra = (self.currentRect.size.width * 2 / 5) * self.factor
        
        let pointA = CGPointMake(rectCenter.x,self.currentRect.origin.y + extra)
        let pointB = CGPointMake(self.scrollDirection == PbUIAnimatedPageControlScrollDirection.Left ? rectCenter.x + self.currentRect.size.width/2 : rectCenter.x + self.currentRect.size.width/2 + extra*2 ,rectCenter.y)
        let pointC = CGPointMake(rectCenter.x ,rectCenter.y + self.currentRect.size.height/2 - extra)
        let pointD = CGPointMake(self.scrollDirection == PbUIAnimatedPageControlScrollDirection.Left ? self.currentRect.origin.x - extra*2 : self.currentRect.origin.x, rectCenter.y)
        
        let c1 = CGPointMake(pointA.x + offset, pointA.y)
        let c2 = CGPointMake(pointB.x, pointB.y - offset)
        let c3 = CGPointMake(pointB.x, pointB.y + offset)
        let c4 = CGPointMake(pointC.x + offset, pointC.y)
        let c5 = CGPointMake(pointC.x - offset, pointC.y)
        let c6 = CGPointMake(pointD.x, pointD.y + offset)
        let c7 = CGPointMake(pointD.x, pointD.y - offset)
        let c8 = CGPointMake(pointA.x - offset, pointA.y)
        
        // 更新界面
        let ovalPath = UIBezierPath()
        ovalPath.moveToPoint(pointA)
        ovalPath.addCurveToPoint(pointB, controlPoint1: c1, controlPoint2: c2)
        ovalPath.addCurveToPoint(pointC, controlPoint1: c3, controlPoint2: c4)
        ovalPath.addCurveToPoint(pointD, controlPoint1: c5, controlPoint2: c6)
        ovalPath.addCurveToPoint(pointA, controlPoint1: c7, controlPoint2: c8)
        ovalPath.closePath()
        
        CGContextAddPath(ctx, ovalPath.CGPath) 
        CGContextSetFillColorWithColor(ctx, self.indicatorColor.CGColor) 
        CGContextFillPath(ctx) 
    }
    
    //animateIndicator:
    override func animateIndicator(scrollView:UIScrollView,pageControl:PbUIAnimatedPageControl) -> Void
    {
        if ((scrollView.contentOffset.x - self.lastContentOffset) >= 0 && (scrollView.contentOffset.x - self.lastContentOffset) <= (scrollView.frame.size.width)/2)
        {
            self.scrollDirection = PbUIAnimatedPageControlScrollDirection.Left
        }
        else if ((scrollView.contentOffset.x - self.lastContentOffset) <= 0 && (scrollView.contentOffset.x - self.lastContentOffset) >= -(scrollView.frame.size.width)/2)
        {
            self.scrollDirection = PbUIAnimatedPageControlScrollDirection.Right
        }
        
        if (!beginGooeyAnim)
        {
            self.factor = min(1, max(0, (abs(scrollView.contentOffset.x - self.lastContentOffset) / scrollView.frame.size.width)))
        }
        
        let originX = (scrollView.contentOffset.x / scrollView.frame.size.width) * (pageControl.frame.size.width / (CGFloat(pageControl.pageCount)-1))
        
        if (originX - self.indicatorSize/2 <= 0)
        {
            self.currentRect = CGRectMake(0, self.frame.size.height/2-self.indicatorSize/2, self.indicatorSize, self.indicatorSize)
        }
        else if ((originX - self.indicatorSize/2) >= self.frame.size.width - self.indicatorSize)
        {
            self.currentRect = CGRectMake(self.frame.size.width - self.indicatorSize, self.frame.size.height/2-self.indicatorSize/2, self.indicatorSize, self.indicatorSize)
        }
        else
        {
            self.currentRect = CGRectMake(originX - self.indicatorSize/2, self.frame.size.height/2-self.indicatorSize/2, self.indicatorSize, self.indicatorSize)
        }
        
        self.setNeedsDisplay()
    }
    
    //restoreAnimation:
    override func restoreAnimation(distince:Float) -> Void
    {
        let anim=CALayer.pbAnimation(createSpring:"factor", duration: 0.8, usingSpringWithDamping: 0.5, initialSpringVelocity: 3, fromValue: Float(0.5+distince*1.5),toValue:0)
        anim.delegate=self
        self.factor=0
        self.addAnimation(anim,forKey:"restoreAnimation")
    }
    
    //animationDidStart:
    override func animationDidStart(anim: CAAnimation)
    {
        self.beginGooeyAnim=true
    }
    
    //animationDidStop:
    override func animationDidStop(anim: CAAnimation, finished flag: Bool)
    {
        if(flag)
        {
            self.beginGooeyAnim=false
        }
    }
}

//PbUIAnimatedPageControlIndicatorRotateRect:方形指示器
class PbUIAnimatedPageControlIndicatorRotateRect:PbUIAnimatedPageControlIndicator
{
    //needsDisplayForKey:
    override class func needsDisplayForKey(key: String) -> Bool
    {
        if("index" == key)
        {
            return true
        }
        
        return super.needsDisplayForKey(key)
    }
    
    //index:
    var index:CGFloat!
    
    //init:重载构造方法
    override init()
    {
        super.init()
    }
    override init(layer: AnyObject)
    {
        super.init(layer:layer)
        
        let indicator=layer as! PbUIAnimatedPageControlIndicatorRotateRect
        self.indicatorSize=indicator.indicatorSize
        self.indicatorColor=indicator.indicatorColor
        self.currentRect=indicator.currentRect
        self.lastContentOffset=indicator.lastContentOffset
        self.index=indicator.index
    }
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    //drawInContext:重构绘制UI的方法
    override func drawInContext(ctx: CGContext)
    {
        let rectPath=UIBezierPath(rect: self.currentRect)
        
        let bounds = CGPathGetBoundingBox(rectPath.CGPath)
        let radians = CGFloat(Double(self.index) * M_PI_2)
        let center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
        var transform = CGAffineTransformIdentity
        transform = CGAffineTransformTranslate(transform, center.x, center.y)
        transform = CGAffineTransformRotate(transform,radians)
        transform = CGAffineTransformTranslate(transform, -center.x, -center.y)
        
        let path=CGPathCreateCopyByTransformingPath(rectPath.CGPath,&transform)
        rectPath.CGPath=path!
        
        CGContextAddPath(ctx, path)
        CGContextSetFillColorWithColor(ctx, self.indicatorColor.CGColor)
        CGContextFillPath(ctx)
    }
    
    //animateIndicator:
    override func animateIndicator(scrollView:UIScrollView,pageControl:PbUIAnimatedPageControl) -> Void
    {
        let originX = (scrollView.contentOffset.x / scrollView.frame.size.width) * (pageControl.frame.size.width / (CGFloat(pageControl.pageCount)-1)) 
        
        self.index = (scrollView.contentOffset.x / scrollView.frame.size.width) 
        
        if (originX - self.indicatorSize/2 <= 0)
        {
            self.currentRect = CGRectMake(0, self.frame.size.height/2-self.indicatorSize/2, self.indicatorSize, self.indicatorSize) 
            
        }
        else if ((originX - self.indicatorSize/2) >= self.frame.size.width - self.indicatorSize)
        {
            self.currentRect = CGRectMake(self.frame.size.width - self.indicatorSize, self.frame.size.height/2-self.indicatorSize/2, self.indicatorSize, self.indicatorSize) 
            
        }
        else
        {
            self.currentRect = CGRectMake(originX - self.indicatorSize/2, self.frame.size.height/2-self.indicatorSize/2, self.indicatorSize, self.indicatorSize) 
        }
        
        self.setNeedsDisplay()
    }
}

//PbUIAnimatedPageControlLine:过渡直线
class PbUIAnimatedPageControlLine:CALayer
{
    //needsDisplayForKey:
    override class func needsDisplayForKey(key: String) -> Bool
    {
        if("selectedLineLength" == key)
        {
            return true
        }
        
        return super.needsDisplayForKey(key)
    }
    
    //pageCount:page的个数
    var pageCount=6
    //selectedPage:选中的item  1,2,3,4
    var selectedPage=1{
        willSet
        {
            if(selectedPage==newValue){return}
        }
        didSet
        {
            self.selectedLineLength = (self.pageCount > 1) ? (Double(selectedPage-1)*self.distince()):0
            self.initialSelectedLineLength=self.selectedLineLength
        }
    }
    
    //shouldShowProgressLine:是否开启进度显示
    var shouldShowProgressLine=true
    
    //lineHeight:pageControl线的高度
    var lineHeight=2.0
    //ballDiameter:小球的直径
    var ballDiameter=10.0
    
    //unSelectedColor:未选中时的颜色
    var unSelectedColor=UIColor.lightGrayColor()
    //selectedColor:选中的颜色
    var selectedColor=UIColor.redColor()
    
    //selectedLineLength:选中的长度
    var selectedLineLength=1.0
    //initialSelectedLineLength:记录上一次选中的长度
    var initialSelectedLineLength=1.0
    //lastContentOffsetX:记录上一次的contentOffSet.x
    var lastContentOffsetX=0.0
    
    //bindScrollView:绑定的滚动视图
    var bindScrollView:UIScrollView?
    
    //重载构造方法
    override init()
    {
        super.init()
    }
    override init(layer: AnyObject)
    {
        super.init(layer:layer)
        
        let line=layer as! PbUIAnimatedPageControlLine
        self.selectedPage=line.selectedPage
        self.lineHeight=line.lineHeight
        self.ballDiameter=line.ballDiameter
        self.unSelectedColor=line.unSelectedColor
        self.selectedColor=line.selectedColor
        self.shouldShowProgressLine=line.shouldShowProgressLine
        self.pageCount=line.pageCount
        self.selectedLineLength=line.selectedLineLength
        self.bindScrollView=line.bindScrollView
        self.masksToBounds=line.masksToBounds
    }
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    //drawInContext:重构绘制UI的方法
    override func drawInContext(ctx: CGContext)
    {
        if(self.selectedPage <= self.pageCount){}
        if(self.selectedPage != 0){}
        
        if (self.pageCount == 1)
        {
            let linePath = CGPathCreateMutable()
            CGPathMoveToPoint(linePath, nil, self.frame.size.width/2, self.frame.size.height/2)
            let circleRect = CGRectMake(self.frame.size.width/2-CGFloat(self.ballDiameter/2),self.frame.size.height/2-CGFloat(self.ballDiameter/2),CGFloat(self.ballDiameter),CGFloat(self.ballDiameter))
            CGPathAddEllipseInRect(linePath, nil, circleRect)
            
            CGContextAddPath(ctx, linePath)
            CGContextSetFillColorWithColor(ctx, self.selectedColor.CGColor)
            CGContextFillPath(ctx)
            
            return
        }
        
        var linePath = CGPathCreateMutable()
        CGPathMoveToPoint(linePath, nil,CGFloat(self.ballDiameter/2),self.frame.size.height/2)
        
        //画默认颜色的背景线
        CGPathAddRoundedRect(linePath, nil, CGRectMake(CGFloat(self.ballDiameter/2), self.frame.size.height/2 - CGFloat(self.lineHeight/2), self.frame.size.width - CGFloat(self.ballDiameter),CGFloat(self.lineHeight)), 0, 0)
        
        //画pageCount个小圆
        for (var i = 0;i<self.pageCount;i++)
        {
            let circleRect = CGRectMake(CGFloat(Double(i)*self.distince()), self.frame.size.height/2 - CGFloat(self.ballDiameter/2),CGFloat(self.ballDiameter),CGFloat(self.ballDiameter))
            CGPathAddEllipseInRect(linePath, nil, circleRect)
        }
        
        CGContextAddPath(ctx, linePath)
        CGContextSetFillColorWithColor(ctx, self.unSelectedColor.CGColor)
        CGContextFillPath(ctx)
        
        if (self.shouldShowProgressLine == true)
        {
            CGContextBeginPath(ctx)
            linePath = CGPathCreateMutable()
            
            //画带颜色的线
            CGPathAddRoundedRect(linePath,nil,CGRectMake(CGFloat(self.ballDiameter/2),self.frame.size.height/2-CGFloat(self.lineHeight/2),CGFloat(self.selectedLineLength),CGFloat(self.lineHeight)), 0, 0)
            
            //画pageCount个有色小圆
            for (var i = 0;i<self.pageCount;i++)
            {
                
                if (Double(i)*self.distince() <= self.selectedLineLength+0.1)
                {
                    let circleRect = CGRectMake(CGFloat(Double(i)*self.distince()),self.frame.size.height/2 - CGFloat(self.ballDiameter/2),CGFloat(self.ballDiameter),CGFloat(self.ballDiameter))
                    CGPathAddEllipseInRect(linePath, nil, circleRect)
                }
            }
            
            CGContextAddPath(ctx, linePath)
            CGContextSetFillColorWithColor(ctx, self.selectedColor.CGColor)
            CGContextFillPath(ctx)
            
        }
    }
    
    //直线动画接口:传入目标index作为参数
    func animateSelectedLineToNewIndex(newIndex:Int)
    {
        let newLineLength = Double(newIndex-1) * self.distince()
        let anim = CALayer.pbAnimation(create:"selectedLineLength",duration: 0.2, fromValue: Float(self.selectedLineLength), toValue: Float(newLineLength))
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        self.selectedLineLength = newLineLength 
        anim.delegate = self 
        self.addAnimation(anim, forKey:"lineAnimation")
        
        self.selectedPage = newIndex
    }
    
    //直线动画接口:传入绑定scrollView作为参数
    func animateSelectedLineWithScrollView(scrollView:UIScrollView)
    {
        if (scrollView.contentOffset.x <= 0)
        {
            return
        }
        
        let offSetX = Double(scrollView.contentOffset.x) - self.lastContentOffsetX
        
        self.selectedLineLength = self.initialSelectedLineLength + offSetX/Double(scrollView.frame.size.width) * self.distince()
        self.setNeedsDisplay()
    }
    
    //animationDidStop:
    override func animationDidStop(anim: CAAnimation, finished flag: Bool)
    {
        if (flag)
        {
            initialSelectedLineLength = self.selectedLineLength
            lastContentOffsetX = (self.selectedLineLength / self.distince()) * Double(self.bindScrollView!.frame.size.width)
        }
    }
    
    //distince
    private func distince() -> Double
    {
        return (Double(self.frame.size.width)-self.ballDiameter)/Double(self.pageCount-1)
    }
}

//PbUIAnimatedPageControl:动画页码切换器
public class PbUIAnimatedPageControl: UIView
{
    //pageCount:页码数量
    var pageCount:Int=0
    //selectedPage:选中页码，从1开始
    var selectedPage:Int=1
    
    //unSelectedColor:未选中时的颜色
    var unSelectedColor=UIColor.lightGrayColor()
    //selectedColor:选中的颜色
    var selectedColor=UIColor.redColor()
    
    //shouldShowProgressLine:是否显示填充进度条
    var shouldShowProgressLine=true
    //bindScrollView:绑定的滚动视图
    var bindScrollView:UIScrollView?
    //swipeEnable:Possible to swipe (Pan gesture recognize)
    var swipeEnable=true
    
    //indicatorStyle:Indicator样式
    var indicatorStyle=PbUIAnimatedPageControlIndicatorStyle.GooeyCircle
    //indicatorSize:Indicator大小
    var indicatorSize:CGFloat=3.0
    //indicator:指示器
    var indicator:PbUIAnimatedPageControlIndicator!
    
    //didSelectIndexBlock:选中某个index的回调 DidSelecteSomeIndex Block
    var didSelectIndexBlock:((index:Int)->Void)?
    
    //line:
    private var line:PbUIAnimatedPageControlLine?
    //gooeyCircle:
    private var gooeyCircle:PbUIAnimatedPageControlIndicatorGooeyCircle?
    //rotateRect:
    private var rotateRect:PbUIAnimatedPageControlIndicatorRotateRect?
    //lastIndex:
    private var lastIndex=1
    
    //重构构造方法
    override public init(frame: CGRect)
    {
        super.init(frame: frame)
        
        let tap=UITapGestureRecognizer(target: self, action: Selector("tapAction:"))
        self.addGestureRecognizer(tap)
        
        let pan=UIPanGestureRecognizer(target: self, action: Selector("panAction:"))
        self.addGestureRecognizer(pan)
        
        self.layer.masksToBounds = false
    }
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    //willMoveToSuperview:
    override public func willMoveToSuperview(newSuperview: UIView?)
    {
        self.layer.addSublayer(self.pageControlLine())
        self.layer.insertSublayer(self.getIndicator(),above: self.pageControlLine())
        self.getLine().setNeedsDisplay()
    }
    
    //pageControlLine:获取线条
    func pageControlLine() -> PbUIAnimatedPageControlLine
    {
        return self.getLine()
    }
    
    //animateToIndex:Animate to index
    public func animationToIndex(index:Int)
    {
        let a=abs(self.line!.selectedLineLength-Double(index)*((Double(self.line!.frame.size.width)-self.line!.ballDiameter)/Double(self.line!.pageCount - 1)))
        let b=((Double(self.line!.frame.size.width)-self.line!.ballDiameter)/Double(self.line!.pageCount - 1))
        let distince =  a/b
        
        //背景线条动画
        self.line?.animateSelectedLineToNewIndex(Int(index+1))
        
        //scrollview 滑动
        self.bindScrollView?.setContentOffset(CGPointMake(self.bindScrollView!.frame.size.width * CGFloat(index), 0), animated: true)
        
        //恢复动画
        self.indicator.restoreAnimation(Float(distince/Double(self.pageCount)),after: 0.2)
    }
    
    //tapAction:
    public func tapAction(recognizer:UITapGestureRecognizer)
    {
        if(self.bindScrollView != nil)
        {
            let location = recognizer.locationInView(self)
            if (CGRectContainsPoint(self.line!.frame, location))
            {
                let ballDistance = Double(self.frame.size.width) / Double(self.pageCount - 1)
                var index =  Double(location.x) / ballDistance
                if ((Double(location.x) - Double(index*ballDistance)) >= Double(ballDistance/2))
                {
                    index += 1.0
                }
                
                let a=abs(self.line!.selectedLineLength-index*((Double(self.line!.frame.size.width)-self.line!.ballDiameter)/Double(self.line!.pageCount - 1)))
                let b=((Double(self.line!.frame.size.width)-self.line!.ballDiameter)/Double(self.line!.pageCount - 1))
                let distince = a/b
                
                //背景线条动画
                self.line!.animateSelectedLineToNewIndex(Int(index+1))
                
                //scrollview 滑动
                self.bindScrollView!.setContentOffset(CGPointMake(self.bindScrollView!.frame.size.width*CGFloat(index),0), animated:true)
                
                //恢复动画
                self.indicator.restoreAnimation(Float(distince/Double(self.pageCount)), after:0.2)
                
                if(self.didSelectIndexBlock != nil)
                {
                    self.didSelectIndexBlock!(index:Int(index+1))
                }
            }
        }
    }
    
    //panAction:
    public func panAction(recognizer:UIPanGestureRecognizer)
    {
        if (!self.swipeEnable)
        {
            return
        }
        
        let location=recognizer.locationInView(self)
        if (CGRectContainsPoint(self.line!.frame, location))
        {
            let ballDistance = Double(self.frame.size.width) / Double(self.pageCount - 1)
            var index:Int =  Int(Double(location.x) / ballDistance)
            if ((Double(location.x) - Double(index)*ballDistance) >= ballDistance/2)
            {
                index += 1
            }
            
            if (index != self.lastIndex)
            {
                self.animationToIndex(index)
                self.lastIndex=index
            }
        }
    }
    
    //getLine:
    private func getLine() -> PbUIAnimatedPageControlLine
    {
        if (self.line == nil)
        {
            self.line = PbUIAnimatedPageControlLine()
            self.line?.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
            self.line?.pageCount = self.pageCount
            self.line?.selectedPage = 1
            self.line?.shouldShowProgressLine = self.shouldShowProgressLine
            self.line?.unSelectedColor = self.unSelectedColor
            self.line?.selectedColor = self.selectedColor
            self.line?.bindScrollView = self.bindScrollView
            self.line?.contentsScale = UIScreen.mainScreen().scale
        }
        
        return self.line!
    }
    
    //getGooeyCircle:
    private func getGooeyCircle() -> PbUIAnimatedPageControlIndicatorGooeyCircle
    {
        if (self.gooeyCircle == nil)
        {
            self.gooeyCircle=PbUIAnimatedPageControlIndicatorGooeyCircle()
            self.gooeyCircle?.indicatorColor=self.selectedColor
            self.gooeyCircle?.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
            self.gooeyCircle?.indicatorSize  = self.indicatorSize
            self.gooeyCircle?.contentsScale = UIScreen.mainScreen().scale
        }
        
        return self.gooeyCircle!
    }
    
    //getRotateRect:
    private func getRotateRect() -> PbUIAnimatedPageControlIndicatorRotateRect
    {
        if (self.rotateRect == nil)
        {
            self.rotateRect = PbUIAnimatedPageControlIndicatorRotateRect()
            self.rotateRect?.indicatorColor = self.selectedColor
            self.rotateRect?.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
            self.rotateRect?.indicatorSize  = self.indicatorSize
            self.rotateRect?.contentsScale = UIScreen.mainScreen().scale
        }
        
        return self.rotateRect!
    }
    
    //getIndicator:
    private func getIndicator() -> PbUIAnimatedPageControlIndicator
    {
        if (self.indicator == nil)
        {
            switch (self.indicatorStyle)
            {
                case .GooeyCircle:
                    self.indicator = self.getGooeyCircle()
                    break
                case .RotateRect:
                    self.indicator = self.getRotateRect()
                    break
            }
            
            self.indicator.animateIndicator(self.bindScrollView!, pageControl: self)
        }
        
        return self.indicator
    }
}