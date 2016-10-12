//
//  PbUIRefreshView.swift
//  pb.swift.ui
//  滚动视图使用的下拉或上拉刷新视图
//  Created by Maqiang on 15/7/7.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation
import UIKit

/**枚举类型，刷新状态
 * pulling          :拖拽中
 * normal           :正常
 * refreshing       :刷新中
 * willRefreshing   :将要刷新
 */
public enum PbUIRefreshState:Int
{
    case pulling,normal,refreshing,willRefreshing
}

/**枚举类型，刷新位置
 * header:头部
 * footer:底部
 */
public enum PbUIRefreshPosition:Int
{
    case header,footer
}

/// 对刷新控件进行配置
public protocol PbUIRefreshConfigProtocol
{
    /// 刷新控件的背景颜色
    func pbUIRefreshViewBackgroudColor() -> UIColor
    /// 刷新控件的显示字体大小
    func pbUIRefreshLabelFontSize() -> CGFloat
    /// 刷新控件的显示字体颜色
    func pbUIRefreshLabelTextColor() -> UIColor
    /// 刷新控件的指示器
    func pbUIRefreshActivityView() -> PbUIActivityIndicator?
    /// 刷新控件的指示器的默认尺寸
    func pbUIRefreshActivityDefaultSize() -> CGSize
    /// 刷新控件的指示器的默认颜色
    func pbUIRefreshActivityDefaultColor() -> UIColor
}

/// 箭头视图
open class PbUIArrowView:UIView
{
    /// 初始化
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor=UIColor.clear
    }
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder:aDecoder)
        self.backgroundColor=UIColor.clear
    }
    
    /// 绘制内容
    override open func draw(_ rect: CGRect)
    {
        let context = UIGraphicsGetCurrentContext()
        let offset:CGFloat=4
        
        context?.setLineWidth(2.0)
        context?.setStrokeColor(self.tintColor.cgColor)
        
        context?.move(to: CGPoint(x: self.bounds.midX, y: offset))
        context?.addLine(to: CGPoint(x: self.bounds.midX, y: self.bounds.height-offset*2))
        
        let offsetX=(self.bounds.width-offset*2)/4
        let offsetY=(self.bounds.height-offset*2)/3
        context?.addLine(to: CGPoint(x: self.bounds.midX-offsetX, y: self.bounds.height-offsetY-offset*2))
        context?.move(to: CGPoint(x: self.bounds.midX, y: self.bounds.height-offset*2))
        context?.addLine(to: CGPoint(x: self.bounds.midX+offsetX, y: self.bounds.height-offsetY-offset*2))
        
        context?.strokePath()
    }
}

/// 刷新基本视图
open class PbUIRefreshBaseView:UIView
{
    /// 默认颜色
    let textColor=UIColor.darkGray
    
    /// 父类控件
    var scrollView:UIScrollView!
    var scrollViewOriginalInset:UIEdgeInsets!
    
    /// 内部显示控件
    var statusLabel:UILabel!
    var arrowView:PbUIArrowView!
    var activityView:PbUIActivityIndicator!
    
    /// 回执方法
    var beginRefreshingCallback:(()->Void)?
    
    //记录状态
    /// 历史状态
    var oldState:PbUIRefreshState?
    /// 记录状态
    var state=PbUIRefreshState.normal
    
    /// 配置协议
    var config:PbUIRefreshConfigProtocol?
    
    /// 初始化方法
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

    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder:aDecoder)
        setup()
    }
    
    /// 创建载入指示器
    func createActivityView() -> PbUIActivityIndicator
    {
        let indicator=PbUIRingSpinnerView(frame: CGRect.zero)
        let size=(self.config == nil ? CGSize(width: 32,height: 32) : self.config!.pbUIRefreshActivityDefaultSize())
        indicator.bounds=CGRect(x: 0, y: 0, width: size.width, height: size.height)
        indicator.tintColor=(self.config == nil ? UIColor(red:215/255, green: 49/255, blue: 69/255, alpha: 1) : self.config!.pbUIRefreshActivityDefaultColor())
        indicator.stopAnimating()
        
        return indicator
    }
    
    /// 设置内部布局
    override open func layoutSubviews()
    {
        super.layoutSubviews()
        //箭头
        let arrowX:CGFloat = self.frame.size.width * 0.5 - 80
        self.arrowView.center = CGPoint(x: arrowX, y: self.frame.size.height * 0.5)
        //指示器
        (self.activityView as! UIView).center = self.arrowView.center
        (self.activityView as! UIView).isHidden=true
    }
    
    /// 设置父控件
    override open func willMove(toSuperview newSuperview: UIView?)
    {
        if (self.superview != nil)
        {
            self.superview!.removeObserver(self,forKeyPath:"contentSize",context: nil)
        }
        
        if (newSuperview != nil)
        {
            newSuperview!.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
            var rect:CGRect = self.frame
            
            rect.size.width = newSuperview!.frame.size.width
            rect.origin.x = 0
            self.frame = frame;
            
            scrollView = newSuperview as! UIScrollView
            scrollViewOriginalInset = scrollView.contentInset;
        }
    }
    
    /// 显示到屏幕上
    override open func draw(_ rect: CGRect)
    {
        super.draw(rect)
        if(self.state == PbUIRefreshState.willRefreshing)
        {
            self.state = PbUIRefreshState.refreshing
        }
    }
    
    /// 开始刷新
    func beginRefreshing()
    {
        if (self.window != nil)
        {
            self.state = PbUIRefreshState.refreshing;
        }
        else
        {
            state = PbUIRefreshState.willRefreshing;
            super.setNeedsDisplay()
        }
        
    }
    
    /// 结束刷新
    func endRefreshing()
    {
        let delayInSeconds:Double = 0.3
        let popTime:DispatchTime = DispatchTime.now() + Double(Int64(delayInSeconds)) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: popTime, execute: {
            self.state = PbUIRefreshState.normal;
        })
    }
    
    /// 设置状态
    func setStateForView(_ newValue:PbUIRefreshState)
    {
        if self.state != PbUIRefreshState.refreshing
        {
            scrollViewOriginalInset = self.scrollView.contentInset;
        }
        if self.state == newValue {return}
        
        switch newValue
        {
            case .normal:
                
                self.arrowView.layer.opacity=1
                self.activityView.stopAnimating()
                (self.activityView as! UIView).isHidden=true
                
                break
            
            case .pulling:
                
                break
            
            case .refreshing:
                
                self.arrowView.layer.opacity=0
                (self.activityView as! UIView).isHidden=false
                activityView.startAnimating()
                if(beginRefreshingCallback != nil){beginRefreshingCallback!()}
                
                break
            
            default:
                
                break
        }
    }
    
    /// 初始化内部控件
    fileprivate func setup()
    {
        //状态标签
        statusLabel = UILabel()
        statusLabel.autoresizingMask = UIViewAutoresizing.flexibleWidth
        statusLabel.font = UIFont.boldSystemFont(ofSize: self.config == nil ? 12 : self.config!.pbUIRefreshLabelFontSize())
        statusLabel.textColor = self.config == nil ? textColor : self.config!.pbUIRefreshLabelTextColor()
        statusLabel.backgroundColor =  UIColor.clear
        statusLabel.textAlignment = NSTextAlignment.center
        self.addSubview(statusLabel)
        
        //箭头图片
        arrowView = PbUIArrowView(frame:CGRect.zero)
        let size=(self.config == nil ? CGSize(width: 32,height: 32) : self.config!.pbUIRefreshActivityDefaultSize())
        arrowView.bounds=CGRect(x: 0, y: 0, width: size.width, height: size.height)
        arrowView.tintColor=(self.config == nil ? UIColor(red:215/255, green: 49/255, blue: 69/255, alpha: 1) : self.config!.pbUIRefreshActivityDefaultColor())
        arrowView.isHidden=true
        self.addSubview(arrowView)
        
        //状态标签
        self.activityView=(self.config == nil ? self.createActivityView() : self.config!.pbUIRefreshActivityView())
        self.activityView=(self.activityView == nil) ? self.createActivityView() : self.activityView
        (self.activityView as! UIView).isHidden=true
        self.addSubview(self.activityView as! UIView)
        
        //自己的属性
        self.autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.backgroundColor = UIColor.clear
        
        //设置默认状态
        self.state = PbUIRefreshState.normal
        self.backgroundColor=(self.config == nil ? UIColor.clear : self.config!.pbUIRefreshViewBackgroudColor())
    }
}

/// 顶部刷新视图
open class PbUIRefreshHeaderView:PbUIRefreshBaseView
{
    /// 记录最后更新时间
    var lastUpdateTime=Date(){willSet{}didSet{}}
    /// 更新时间标签
    var updateTimeLabel:UILabel?
    /// 覆盖父类属性，增加设置状态
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
                case .normal:
                    
                    self.statusLabel.text = "上拉可以刷新"
                    if PbUIRefreshState.refreshing == oldState
                    {
                        self.arrowView.transform = CGAffineTransform.identity
                        self.lastUpdateTime = Date()
                        self.updateTimeLabel?.text=String.date("yyyy年MM月dd日 HH:mm")
                        UIView.animate(withDuration: 0.3, animations:
                        {
                            var contentInset:UIEdgeInsets = self.scrollView.contentInset
                            contentInset.top = self.scrollViewOriginalInset.top
                            self.scrollView.contentInset = contentInset
                        })
                    }
                    else
                    {
                        UIView.animate(withDuration: 0.3, animations: {
                            self.arrowView.transform = CGAffineTransform.identity
                        })
                    }
            
                    break
                
            case .pulling:
                
                    self.statusLabel.text = "松开立即刷新"
                    UIView.animate(withDuration: 0.3, animations: {
                        self.arrowView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
                    })
                    break
                
            case .refreshing:
                
                self.statusLabel.text = "正在刷新中...";
                
                UIView.animate(withDuration: 0.3, animations:
                {
                    let top:CGFloat = self.scrollViewOriginalInset.top + self.frame.size.height
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
    
    /// 初始化方法
    override public init(frame: CGRect)
    {
        super.init(frame: frame)
        setup()
    }
    
    override public init(frame: CGRect, config: PbUIRefreshConfigProtocol)
    {
        super.init(frame: frame, config: config)
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder:aDecoder)
        setup()
    }
    
    /// 设置内部布局
    override open func layoutSubviews()
    {
        super.layoutSubviews()
        
        let statusX:CGFloat = 0
        let statusY:CGFloat = 6
        let statusHeight:CGFloat = self.frame.size.height * 0.5
        let statusWidth:CGFloat = self.frame.size.width
        
        //状态标签
        self.statusLabel.frame = CGRect(x: statusX, y: statusY, width: statusWidth, height: statusHeight)
        
        //时间标签
        let lastUpdateY:CGFloat = statusHeight-statusY
        let lastUpdateX:CGFloat = 0
        let lastUpdateHeight:CGFloat = statusHeight
        let lastUpdateWidth:CGFloat = statusWidth
        self.updateTimeLabel!.frame = CGRect(x: lastUpdateX, y: lastUpdateY, width: lastUpdateWidth, height: lastUpdateHeight);
    }
    
    /// 设置自己的位置和尺寸
    override open func willMove(toSuperview newSuperview: UIView!) {
        super.willMove(toSuperview: newSuperview)
        
        var rect:CGRect = self.frame
        rect.origin.y = -self.frame.size.height
        self.frame = rect
    }
    
    /// 监听UIScrollView的contentOffset属性
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (!self.isUserInteractionEnabled || self.isHidden){return}
        if (self.state == PbUIRefreshState.refreshing){return}
        
        if "contentOffset".isEqual(keyPath!)
        {
            self.adjustStateWithContentOffset()
        }
    }
    
    /// 调整状态
    func adjustStateWithContentOffset()
    {
        let currentOffsetY:CGFloat = self.scrollView.contentOffset.y
        let happenOffsetY:CGFloat = -self.scrollViewOriginalInset.top
        
        if (currentOffsetY >= happenOffsetY){return}
        
        if self.scrollView.isDragging
        {
            let normal2pullingOffsetY:CGFloat = happenOffsetY - self.frame.size.height
            if(self.state == PbUIRefreshState.normal && currentOffsetY < normal2pullingOffsetY)
            {
                self.state = PbUIRefreshState.pulling
            }
            else if(self.state == PbUIRefreshState.pulling && currentOffsetY >= normal2pullingOffsetY)
            {
                self.state = PbUIRefreshState.normal
            }
        }
        else if(self.state == PbUIRefreshState.pulling)
        {
            self.state = PbUIRefreshState.refreshing
        }
    }
    
    /// 初始化内部控件
    fileprivate override func setup()
    {
        super.setup()
        
        updateTimeLabel = UILabel()
        updateTimeLabel!.autoresizingMask = UIViewAutoresizing.flexibleWidth
        updateTimeLabel!.font = UIFont.boldSystemFont(ofSize: self.config == nil ? 12 : self.config!.pbUIRefreshLabelFontSize())
        updateTimeLabel!.textColor = self.config == nil ? textColor : self.config!.pbUIRefreshLabelTextColor()
        updateTimeLabel!.backgroundColor = UIColor.clear
        updateTimeLabel!.textAlignment = NSTextAlignment.center
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
