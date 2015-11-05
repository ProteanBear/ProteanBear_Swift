//
//  PbTestForBasicPbSystem.swift
//  PbSwiftDemo
//
//  Created by Maqiang on 15/9/23.
//  Copyright © 2015年 ProteanBear. All rights reserved.
//

import Foundation
import UIKit

class PbTestForBasicPbSystem: UITableViewController
{
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 5
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var count=0
        switch section{
            case 0:count=5
            case 1:count=5
            case 2:count=4
            case 3:count=6
            case 4:count=4
            default:count=0
        }
        return count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 44
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        var title=""
        switch section{
            case 0:title="设备标准尺寸"
            case 1:title="系统标准尺寸"
            case 2:title="设备判断"
            case 3:title="系统判断"
            case 4:title="屏幕尺寸"
            default:title=""
        }
        return title
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell: UITableViewCell?
        cell=tableView.dequeueReusableCellWithIdentifier("PbSystemTableCell")
        if(cell == nil)
        {
            cell=UITableViewCell(style:.Value2, reuseIdentifier:"PbSystemTableCell")
        }
        
        switch(indexPath.section){
        case 0:
            switch(indexPath.row){
            case 0:
                cell?.textLabel?.text="iPhone4"
                cell?.detailTextLabel?.text="Pt:"+PbSystem.sizeiPhone4Width.description+" X "+PbSystem.sizeiPhone4Height.description+" Px:"+(PbSystem.sizeiPhone4Width*2).description+" X "+(PbSystem.sizeiPhone4Height*2).description
                break
            case 1:
                cell?.textLabel?.text="iPhone5"
                cell?.detailTextLabel?.text="Pt:"+PbSystem.sizeiPhone5Width.description+" X "+PbSystem.sizeiPhone5Height.description+" Px:"+(PbSystem.sizeiPhone5Width*2).description+" X "+(PbSystem.sizeiPhone5Height*2).description
                break
            case 2:
                cell?.textLabel?.text="iPhone6"
                cell?.detailTextLabel?.text="Pt:"+PbSystem.sizeiPhone6Width.description+" X "+PbSystem.sizeiPhone6Height.description+" Px:"+(PbSystem.sizeiPhone6Width*2).description+" X "+(PbSystem.sizeiPhone6Height*2).description
                break
            case 3:
                cell?.textLabel?.text="iPhone6p"
                cell?.detailTextLabel?.text="Pt:"+PbSystem.sizeiPhone6pWidth.description+" X "+PbSystem.sizeiPhone6pHeight.description+" Px:"+(PbSystem.sizeiPhone6pWidth*3).description+" X "+(PbSystem.sizeiPhone6pHeight*3).description+"(1080 X 1920)"
                break
            case 4:
                cell?.textLabel?.text="iPad"
                cell?.detailTextLabel?.text="Pt:"+PbSystem.sizeiPadWidth.description+" X "+PbSystem.sizeiPadHeight.description+" Px:"+(PbSystem.sizeiPadWidth*2).description+" X "+(PbSystem.sizeiPadHeight*2).description
                break
                default:break
            }
            break
        case 1:
            switch(indexPath.row){
                case 0:
                    cell?.textLabel?.text="底部Tab栏"
                    cell?.detailTextLabel?.text=PbSystem.sizeBottomTabBarHeight.description
                    break
                case 1:
                    cell?.textLabel?.text="底部工具栏"
                    cell?.detailTextLabel?.text=PbSystem.sizeBottomToolBarHeight.description
                    break
                case 2:
                    cell?.textLabel?.text="顶部状态栏"
                    cell?.detailTextLabel?.text=PbSystem.sizeTopStatusBarHeight.description
                    break
                case 3:
                    cell?.textLabel?.text="顶部标题栏"
                    cell?.detailTextLabel?.text=PbSystem.sizeTopTitleBarHeight.description
                    break
                case 4:
                    cell?.textLabel?.text="顶部菜单栏"
                    cell?.detailTextLabel?.text=PbSystem.sizeTopMenuBarHeight.description
                    break
                default:break
            }
            break
        case 2:
            switch(indexPath.row){
                case 0:
                    cell?.textLabel?.text="手机"
                    cell?.detailTextLabel?.text=PbSystem.isPhone().description
                    break
                case 1:
                    cell?.textLabel?.text="iPhone5"
                    cell?.detailTextLabel?.text=PbSystem.isPhone5().description
                    break
                case 2:
                    cell?.textLabel?.text="iPhone6"
                    cell?.detailTextLabel?.text=PbSystem.isPhone6().description
                    break
                case 3:
                    cell?.textLabel?.text="iPhone6p"
                    cell?.detailTextLabel?.text=PbSystem.isPhone6p().description
                    break
                default:break
            }
            break
        case 3:
            switch(indexPath.row){
            case 0:
                cell?.textLabel?.text="系统版本"
                cell?.detailTextLabel?.text=PbSystem.osVersion().description
                break
            case 1:
                cell?.textLabel?.text="iOS6"
                cell?.detailTextLabel?.text=PbSystem.os6().description
                break
            case 2:
                cell?.textLabel?.text="iOS7"
                cell?.detailTextLabel?.text=PbSystem.os7().description
                break
            case 3:
                cell?.textLabel?.text="iOS8"
                cell?.detailTextLabel?.text=PbSystem.os8().description
                break
            case 4:
                cell?.textLabel?.text="iOS9"
                cell?.detailTextLabel?.text=PbSystem.os9().description
                break
            case 5:
                cell?.textLabel?.text="iOS8以上"
                cell?.detailTextLabel?.text=PbSystem.osUp8().description
                break
            default:break
            }
            break
        case 4:
            switch(indexPath.row){
            case 0:
                cell?.textLabel?.text="全屏设备尺寸"
                cell?.detailTextLabel?.text=PbSystem.screenWidth(true).description+" X "+PbSystem.screenHeight(true).description
                break
            case 1:
                cell?.textLabel?.text="全屏翻转尺寸"
                cell?.detailTextLabel?.text=PbSystem.screenCurrentWidth(true).description+" X "+PbSystem.screenCurrentHeight(true).description
                break
            case 2:
                cell?.textLabel?.text="容器设备尺寸"
                cell?.detailTextLabel?.text=PbSystem.screenWidth().description+" X "+PbSystem.screenHeight().description
                break
            case 3:
                cell?.textLabel?.text="容器翻转尺寸"
                cell?.detailTextLabel?.text=PbSystem.screenCurrentWidth().description+" X "+PbSystem.screenCurrentHeight().description
                break
            default:break
            }
            break
        default:break
        }
        
        return cell!
    }
}