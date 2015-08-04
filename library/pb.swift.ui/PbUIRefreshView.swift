//
//  PbUIRefreshView.swift
//  pb.swift.ui
//  滚动视图使用的下拉或上拉刷新视图
//  Created by Maqiang on 15/7/7.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation
import UIKit

//PbUIRefreshState:刷新状态
enum PbUIRefreshState:Int
{
    case Pulling,Normal,Refreshing,WillRefreshing
}

//PbUIRefreshPosition:刷新位置
enum PbUIRefreshPosition:Int
{
    case Header,Footer
}

//PbUIRefreshConfigProtocol:对刷新控件进行配置
protocol PbUIRefreshConfigProtocol
{
    func pbUIRefreshViewBackgroudColor() -> UIColor
    func pbUIRefreshLabelFontSize() -> CGFloat
    func pbUIRefreshLabelTextColor() -> UIColor
    func pbUIRefreshActivityView() -> PbUIActivityIndicator?
    func pbUIRefreshActivityDefaultSize() -> CGSize
    func pbUIRefreshActivityDefaultColor() -> UIColor
}

//PbUIArrowView:箭头视图
class PbUIArrowView:UIView
{
    //init:初始化
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor=UIColor.clearColor()
    }
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder:aDecoder)
        self.backgroundColor=UIColor.clearColor()
    }
    
    //绘制内容
    override func drawRect(rect: CGRect)
    {
        let context = UIGraphicsGetCurrentContext()
        let offset:CGFloat=4
        
        CGContextSetLineWidth(context,2.0)
        CGContextSetStrokeColorWithColor(context,self.tintColor.CGColor)
        
        CGContextMoveToPoint(context,CGRectGetMidX(self.bounds),offset)
        CGContextAddLineToPoint(context,CGRectGetMidX(self.bounds),CGRectGetHeight(self.bounds)-offset*2)
        
        let offsetX=(CGRectGetWidth(self.bounds)-offset*2)/4
        let offsetY=(CGRectGetHeight(self.bounds)-offset*2)/3
        CGContextAddLineToPoint(context,CGRectGetMidX(self.bounds)-offsetX,CGRectGetHeight(self.bounds)-offsetY-offset*2)
        CGContextMoveToPoint(context,CGRectGetMidX(self.bounds),CGRectGetHeight(self.bounds)-offset*2)
        CGContextAddLineToPoint(context,CGRectGetMidX(self.bounds)+offsetX,CGRectGetHeight(self.bounds)-offsetY-offset*2)
        
        CGContextStrokePath(context)
    }
}

//PbUIRefreshBaseView:刷新基本视图
class PbUIRefreshBaseView:UIView
{
    //默认颜色
    let textColor=UIColor.darkGrayColor()
    
    //父类控件
    var scrollView:UIScrollView!
    var scrollViewOriginalInset:UIEdgeInsets!
    
    //内部显示控件
    var statusLabel:UILabel!
    var arrowView:PbUIArrowView!
    var activityView:PbUIActivityIndicator!
    
    //回执方法
    var beginRefreshingCallback:(()->Void)?
    
    //记录状态
    var oldState:PbUIRefreshState?
    var state=PbUIRefreshState.Normal
    
    //配置协议
    var config:PbUIRefreshConfigProtocol?
    
    //初始化方法
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setup()
    }
    
    init(frame: CGRect,config:PbUIRefreshConfigProtocol)
    {
        super.init(frame: frame)
        self.config=config
        setup()
    }

    required init(coder aDecoder: NSCoder)
    {
        super.init(coder:aDecoder)
        setup()
    }
    
    //createActivityView:创建载入指示器
    func createActivityView() -> PbUIActivityIndicator
    {
        let indicator=PbUIRingSpinnerView(frame: CGRectZero)
        let size=(self.config == nil ? CGSizeMake(32,32) : self.config!.pbUIRefreshActivityDefaultSize())
        indicator.bounds=CGRectMake(0, 0, size.width, size.height)
        indicator.tintColor=(self.config == nil ? UIColor(red:215/255, green: 49/255, blue: 69/255, alpha: 1) : self.config!.pbUIRefreshActivityDefaultColor())
        indicator.stopAnimating()
        
        return indicator
    }
    
    //layoutSubviews:设置内部布局
    override func layoutSubviews()
    {
        super.layoutSubviews()
        //箭头
        let arrowX:CGFloat = self.frame.size.width * 0.5 - 80
        self.arrowView.center = CGPointMake(arrowX, self.frame.size.height * 0.5)
        //指示器
        (self.activityView as! UIView).center = self.arrowView.center
        (self.activityView as! UIView).hidden=true
    }
    
    //willMoveToSuperview:设置父控件
    override func willMoveToSuperview(newSuperview: UIView?)
    {
        if (self.superview != nil)
        {
            self.superview!.removeObserver(self,forKeyPath:"contentSize",context: nil)
        }
        
        if (newSuperview != nil)
        {
            newSuperview!.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.New, context: nil)
            var rect:CGRect = self.frame
            
            rect.size.width = newSuperview!.frame.size.width
            rect.origin.x = 0
            self.frame = frame;
            
            scrollView = newSuperview as! UIScrollView
            scrollViewOriginalInset = scrollView.contentInset;
        }
    }
    
    //drawRect:显示到屏幕上
    override func drawRect(rect: CGRect)
    {
        super.drawRect(rect)
        if(self.state == PbUIRefreshState.WillRefreshing)
        {
            self.state = PbUIRefreshState.Refreshing
        }
    }
    
    //beginRefreshing:开始刷新
    func beginRefreshing()
    {
        if (self.window != nil)
        {
            self.state = PbUIRefreshState.Refreshing;
        }
        else
        {
            state = PbUIRefreshState.WillRefreshing;
            super.setNeedsDisplay()
        }
        
    }
    
    //结束刷新
    func endRefreshing()
    {
        let delayInSeconds:Double = 0.3
        var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds))
        
        dispatch_after(popTime, dispatch_get_main_queue(), {
            self.state = PbUIRefreshState.Normal;
        })
    }
    
    //setStateForView:设置状态
    func setStateForView(newValue:PbUIRefreshState)
    {
        if self.state != PbUIRefreshState.Refreshing
        {
            scrollViewOriginalInset = self.scrollView.contentInset;
        }
        if self.state == newValue {return}
        
        switch newValue
        {
            case .Normal:
                
                self.arrowView.layer.opacity=1
                self.activityView.stopAnimating()
                (self.activityView as! UIView).hidden=true
                
                break
            
            case .Pulling:
                
                break
            
            case .Refreshing:
                
                self.arrowView.layer.opacity=0
                (self.activityView as! UIView).hidden=false
                activityView.startAnimating()
                if(beginRefreshingCallback != nil){beginRefreshingCallback!()}
                
                break
            
            default:
                
                break
        }
    }
    
    //setup:初始化内部控件
    private func setup()
    {
        //状态标签
        statusLabel = UILabel()
        statusLabel.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        statusLabel.font = UIFont.boldSystemFontOfSize(self.config == nil ? 12 : self.config!.pbUIRefreshLabelFontSize())
        statusLabel.textColor = self.config == nil ? textColor : self.config!.pbUIRefreshLabelTextColor()
        statusLabel.backgroundColor =  UIColor.clearColor()
        statusLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(statusLabel)
        
        //箭头图片
        arrowView = PbUIArrowView(frame:CGRectZero)
        let size=(self.config == nil ? CGSizeMake(32,32) : self.config!.pbUIRefreshActivityDefaultSize())
        arrowView.bounds=CGRectMake(0, 0, size.width, size.height)
        arrowView.tintColor=(self.config == nil ? UIColor(red:215/255, green: 49/255, blue: 69/255, alpha: 1) : self.config!.pbUIRefreshActivityDefaultColor())
        arrowView.hidden=true
        self.addSubview(arrowView)
        
        //状态标签
        self.activityView=(self.config == nil ? self.createActivityView() : self.config!.pbUIRefreshActivityView())
        self.activityView=(self.activityView == nil) ? self.createActivityView() : self.activityView
        (self.activityView as! UIView).hidden=true
        self.addSubview(self.activityView as! UIView)
        
        //自己的属性
        self.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.backgroundColor = UIColor.clearColor()
        
        //设置默认状态
        self.state = PbUIRefreshState.Normal
        self.backgroundColor=(self.config == nil ? UIColor.clearColor() : self.config!.pbUIRefreshViewBackgroudColor())
    }
}

//PbUIRefreshHeaderView:顶部刷新视图
class PbUIRefreshHeaderView:PbUIRefreshBaseView
{
    //lastUpdateTime:记录最后更新时间
    var lastUpdateTime=NSDate(){willSet{}didSet{}}
    //updateTimeLabel:更新时间标签
    var updateTimeLabel:UILabel?
    //state:覆盖父类属性，增加设置状态
    override var state:PbUIRefreshState
    {
        willSet
        {
            if(state==newValue){return}
            oldState=state
            setStateForView(newValue)
        }
        didSet
        {
            switch state
            {
                case .Normal:
                    
                    self.statusLabel.text = "上拉可以刷新"
                    if PbUIRefreshState.Refreshing == oldState
                    {
                        self.arrowView.transform = CGAffineTransformIdentity
                        self.lastUpdateTime = NSDate()
                        self.updateTimeLabel?.text=PbSystem.stringFromDate("yyyy年MM月dd日 HH:mm")
                        UIView.animateWithDuration(0.3, animations:
                        {
                            var contentInset:UIEdgeInsets = self.scrollView.contentInset
                            contentInset.top = self.scrollViewOriginalInset.top
                            self.scrollView.contentInset = contentInset
                        })
                    }
                    else
                    {
                        UIView.animateWithDuration(0.3, animations: {
                            self.arrowView.transform = CGAffineTransformIdentity
                        })
                    }
            
                    break
                
            case .Pulling:
                
                    self.statusLabel.text = "松开立即刷新"
                    UIView.animateWithDuration(0.3, animations: {
                        self.arrowView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                    })
                    break
                
            case .Refreshing:
                
                self.statusLabel.text = "正在刷新中...";
                
                UIView.animateWithDuration(0.3, animations:
                {
                    var top:CGFloat = self.scrollViewOriginalInset.top + self.frame.size.height
                    var inset:UIEdgeInsets = self.scrollView.contentInset
                    inset.top = top
                    self.scrollView.contentInset = inset
                    var offset:CGPoint = self.scrollView.contentOffset
                    offset.y = -top
                    self.scrollView.contentOffset = offset
                })
                
                break
            default:
                break
                
            }
        }
    }
    
    //初始化方法
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setup()
    }
    
    override init(frame: CGRect, config: PbUIRefreshConfigProtocol)
    {
        super.init(frame: frame, config: config)
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder:aDecoder)
        setup()
    }
    
    //layoutSubviews:设置内部布局
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        var statusX:CGFloat = 0
        var statusY:CGFloat = 6
        var statusHeight:CGFloat = self.frame.size.height * 0.5
        var statusWidth:CGFloat = self.frame.size.width
        
        //状态标签
        self.statusLabel.frame = CGRectMake(statusX, statusY, statusWidth, statusHeight)
        
        //时间标签
        var lastUpdateY:CGFloat = statusHeight-statusY
        var lastUpdateX:CGFloat = 0
        var lastUpdateHeight:CGFloat = statusHeight
        var lastUpdateWidth:CGFloat = statusWidth
        self.updateTimeLabel!.frame = CGRectMake(lastUpdateX, lastUpdateY, lastUpdateWidth, lastUpdateHeight);
    }
    
    //willMoveToSuperview:设置自己的位置和尺寸
    override func willMoveToSuperview(newSuperview: UIView!) {
        super.willMoveToSuperview(newSuperview)
        
        var rect:CGRect = self.frame
        rect.origin.y = -self.frame.size.height
        self.frame = rect
    }
    
    //observeValueForKeyPath:监听UIScrollView的contentOffset属性
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>)
    {
        if (!self.userInteractionEnabled || self.hidden){return}
        if (self.state == PbUIRefreshState.Refreshing){return}
        
        if "contentOffset".isEqualToString(keyPath)
        {
            self.adjustStateWithContentOffset()
        }
    }
    
    //adjustStateWithContentOffset:调整状态
    func adjustStateWithContentOffset()
    {
        var currentOffsetY:CGFloat = self.scrollView.contentOffset.y
        var happenOffsetY:CGFloat = -self.scrollViewOriginalInset.top
        
        if (currentOffsetY >= happenOffsetY){return}
        
        if self.scrollView.dragging
        {
            var normal2pullingOffsetY:CGFloat = happenOffsetY - self.frame.size.height
            if(self.state == PbUIRefreshState.Normal && currentOffsetY < normal2pullingOffsetY)
            {
                self.state = PbUIRefreshState.Pulling
            }
            else if(self.state == PbUIRefreshState.Pulling && currentOffsetY >= normal2pullingOffsetY)
            {
                self.state = PbUIRefreshState.Normal
            }
        }
        else if(self.state == PbUIRefreshState.Pulling)
        {
            self.state = PbUIRefreshState.Refreshing
        }
    }
    
    //setup:初始化内部控件
    private override func setup()
    {
        super.setup()
        
        updateTimeLabel = UILabel()
        updateTimeLabel!.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        updateTimeLabel!.font = UIFont.boldSystemFontOfSize(self.config == nil ? 12 : self.config!.pbUIRefreshLabelFontSize())
        updateTimeLabel!.textColor = self.config == nil ? textColor : self.config!.pbUIRefreshLabelTextColor()
        updateTimeLabel!.backgroundColor = UIColor.clearColor()
        updateTimeLabel!.textAlignment = NSTextAlignment.Center
        self.addSubview(updateTimeLabel!);
    }
}

//PbUIRefreshFooterView:底部加载视图
//class PbUIRefreshFooterView:PbUIRefreshBaseView
//{
//    var lastRefreshCount:Int = 0
//    //state:覆盖父类属性，增加设置状态
//    override var state:PbUIRefreshState
//    {
//        willSet
//        {
//            if(state==newValue){return}
//            oldState=state
//            setStateForView(newValue)
//        }
//        didSet
//        {
//            switch state
//            {
//                case .Normal:
//                
//                    self.statusLabel.text = "加载更多";
//                    if (PbUIRefreshState.Refreshing == oldState)
//                    {
//                        self.arrowView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
//                        UIView.animateWithDuration(0.3, animations:
//                        {
//                            self.scrollView.contentInset.bottom = self.scrollViewOriginalInset.bottom
//                        })
//                    }
//                    else
//                    {
//                        UIView.animateWithDuration(0.3, animations:
//                        {
//                            self.arrowView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI));
//                        })
//                    }
//                    
//                    var deltaH:CGFloat = self.heightForContentBreakView()
//                    var currentCount:Int = self.totalDataCountInScrollView()
//                    
//                    if (PbUIRefreshState.Refreshing == oldState && deltaH > 0  && currentCount != self.lastRefreshCount)
//                    {
//                        var offset:CGPoint = self.scrollView.contentOffset;
//                        offset.y = self.scrollView.contentOffset.y
//                        self.scrollView.contentOffset = offset;
//                    }
//                
//                    break
//                
//                case .Pulling:
//                
//                    self.statusLabel.text = "松开加载"
//                    UIView.animateWithDuration(0.3, animations:
//                    {
//                        self.arrowView.transform = CGAffineTransformIdentity
//                    })
//                
//                    break
//                
//                case .Refreshing:
//                
//                    self.statusLabel.text = "正在加载";
//                    self.lastRefreshCount = self.totalDataCountInScrollView();
//                    UIView.animateWithDuration(0.3, animations:
//                    {
//                        var bottom:CGFloat = self.frame.size.height + self.scrollViewOriginalInset.bottom
//                        var deltaH:CGFloat = self.heightForContentBreakView()
//                        if(deltaH < 0){bottom = bottom - deltaH}
//                        var inset:UIEdgeInsets = self.scrollView.contentInset;
//                        inset.bottom = bottom;
//                        self.scrollView.contentInset = inset;
//                    })
//                
//                    break
//                default:
//                    break
//                
//            }
//        }
//    }
//    
//    //layoutSubviews:设置内部布局
//    override func layoutSubviews()
//    {
//        super.layoutSubviews()
//        self.statusLabel.frame = self.bounds
//    }
//    
//    //willMoveToSuperview:设置自己的位置和尺寸
//    override func willMoveToSuperview(newSuperview: UIView?)
//    {
//        super.willMoveToSuperview(newSuperview)
//        
//        if(self.superview != nil)
//        {
//            self.superview!.removeObserver(self, forKeyPath:"contentSize", context: nil)
//        }
//        if (newSuperview != nil)
//        {
//            newSuperview!.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.New, context: nil)
//            // 重新调整frame
//            adjustFrameWithContentSize()
//        }
//    }
//    
//    //observeValueForKeyPath:监听UIScrollView的contentOffset属性
//    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>)
//    {
//        if(!self.userInteractionEnabled || self.hidden){return}
//        
//        if("contentSize".isEqualToString(keyPath))
//        {
//            adjustFrameWithContentSize()
//        }
//        else if("contentOffset".isEqualToString(keyPath))
//        {
//            if(self.state == PbUIRefreshState.Refreshing){return}
//            adjustStateWithContentOffset()
//        }
//    }
//    
//    //adjustStateWithContentOffset:调整状态
//    func adjustFrameWithContentSize()
//    {
//        var contentHeight:CGFloat = self.scrollView.contentSize.height
//        var scrollHeight:CGFloat = self.scrollView.frame.size.height  - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom
//        var rect:CGRect = self.frame;
//        rect.origin.y =  contentHeight > scrollHeight ? contentHeight : scrollHeight
//        self.frame = rect;
//    }
//    
//    //adjustStateWithContentOffset:调整状态
//    func adjustStateWithContentOffset()
//    {
//        var currentOffsetY:CGFloat  = self.scrollView.contentOffset.y
//        var happenOffsetY:CGFloat = self.happenOffsetY()
//        if(currentOffsetY <= happenOffsetY){return}
//        
//        if self.scrollView.dragging
//        {
//            var normal2pullingOffsetY =  happenOffsetY + self.frame.size.height
//            if self.state == PbUIRefreshState.Normal && currentOffsetY > normal2pullingOffsetY
//            {
//                self.state = PbUIRefreshState.Pulling;
//            }
//            else if (self.state == PbUIRefreshState.Pulling && currentOffsetY <= normal2pullingOffsetY)
//            {
//                self.state = PbUIRefreshState.Normal;
//            }
//        }
//        else if (self.state == PbUIRefreshState.Pulling)
//        {
//            self.state = PbUIRefreshState.Refreshing
//        }
//    }
//    
//    func totalDataCountInScrollView()->Int
//    {
//        var totalCount:Int = 0
//        if self.scrollView is UITableView
//        {
//            var tableView:UITableView = self.scrollView as! UITableView
//            
//            for (var i:Int = 0 ; i <  tableView.numberOfSections() ; i++)
//            {
//                totalCount = totalCount + tableView.numberOfRowsInSection(i)
//            }
//        }
//        else if self.scrollView is UICollectionView
//        {
//            var collectionView:UICollectionView = self.scrollView as! UICollectionView
//            for (var i:Int = 0 ; i <  collectionView.numberOfSections() ; i++)
//            {
//                totalCount = totalCount + collectionView.numberOfItemsInSection(i)
//            }
//        }
//        return totalCount
//    }
//    
//    func heightForContentBreakView()->CGFloat
//    {
//        var h:CGFloat  = self.scrollView.frame.size.height - self.scrollViewOriginalInset.bottom - self.scrollViewOriginalInset.top;
//        return self.scrollView.contentSize.height - h;
//    }
//    
//    
//    func happenOffsetY()->CGFloat
//    {
//        var deltaH:CGFloat = self.heightForContentBreakView()
//        if(deltaH > 0)
//        {
//            return   deltaH - self.scrollViewOriginalInset.top;
//        }
//        else
//        {
//            return  -self.scrollViewOriginalInset.top;
//        }
//    }
//}