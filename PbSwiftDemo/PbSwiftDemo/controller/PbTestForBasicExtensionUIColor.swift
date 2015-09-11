//
//  PbTestForBasicExtensionUIColor.swift
//  PbSwiftDemo
//
//  Created by Maqiang on 15/9/10.
//  Copyright (c) 2015年 ProteanBear. All rights reserved.
//

import Foundation
import UIKit

class PbTestForBasicExtensionUIColor: UITableViewController
{
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 9
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 14
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 44
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 44
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        var title=""
        switch section{
        case 0:title="红色（Red）"
        case 1:title="粉色（Pink）"
        case 2:title="紫色（Purple）"
        case 3:title="深紫色（Deep Purple）"
        case 4:title="靛蓝色（Indigo）"
        case 5:title="蓝色（Blue）"
        case 6:title="浅蓝色（Light Blue）"
        case 7:title="青色（Cyan）"
        case 8:title="蓝绿色（Teal）"
        default:title=""
        }
        return title
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell: UITableViewCell?
        cell=tableView.dequeueReusableCellWithIdentifier("PbTestCellBasicExtensionUIColor") as? UITableViewCell
        if(cell == nil)
        {
            cell=UITableViewCell(style:.Value1, reuseIdentifier:"PbTestCellBasicExtensionUIColor")
        }
        
        cell?.textLabel?.text=UIColor.pbLevelName(indexPath.row)
        cell?.textLabel?.font=UIFont.systemFontOfSize(15)
        cell?.detailTextLabel?.font=UIFont.systemFontOfSize(13)
        var color=UIColor.blackColor()
        
        switch(indexPath.section){
        //红色
        case 0:
            cell?.contentView.backgroundColor=UIColor.pbRedColor(indexPath.row)
            cell?.detailTextLabel?.text=UIColor.pbRedColorValue(indexPath.row)
            color=(
                indexPath.row<PbUIColorLevel.level500.rawValue||indexPath.row==PbUIColorLevel.levelA100.rawValue
                ?UIColor.blackColor():UIColor.whiteColor()
            )
            break
        //粉色
        case 1:
            cell?.contentView.backgroundColor=UIColor.pbPinkColor(indexPath.row)
            cell?.detailTextLabel?.text=UIColor.pbPinkColorValue(indexPath.row)
            color=(
                indexPath.row<PbUIColorLevel.level500.rawValue||indexPath.row==PbUIColorLevel.levelA100.rawValue
                    ?UIColor.blackColor():UIColor.whiteColor()
            )
            break
        //紫色
        case 2:
            cell?.contentView.backgroundColor=UIColor.pbPurpleColor(indexPath.row)
            cell?.detailTextLabel?.text=UIColor.pbPurpleColorValue(indexPath.row)
            color=(
                indexPath.row<PbUIColorLevel.level300.rawValue||indexPath.row==PbUIColorLevel.levelA100.rawValue
                    ?UIColor.blackColor():UIColor.whiteColor()
            )
            break
        //深紫色
        case 3:
            cell?.contentView.backgroundColor=UIColor.pbPurpleDeepColor(indexPath.row)
            cell?.detailTextLabel?.text=UIColor.pbPurpleDeepColorValue(indexPath.row)
            color=(
                indexPath.row<PbUIColorLevel.level300.rawValue||indexPath.row==PbUIColorLevel.levelA100.rawValue
                    ?UIColor.blackColor():UIColor.whiteColor()
            )
            break
        //靛蓝色
        case 4:
            cell?.contentView.backgroundColor=UIColor.pbIndigoColor(indexPath.row)
            cell?.detailTextLabel?.text=UIColor.pbIndigoColorValue(indexPath.row)
            color=(
                indexPath.row<PbUIColorLevel.level300.rawValue||indexPath.row==PbUIColorLevel.levelA100.rawValue
                    ?UIColor.blackColor():UIColor.whiteColor()
            )
            break
        //蓝色
        case 5:
            cell?.contentView.backgroundColor=UIColor.pbBlueColor(indexPath.row)
            cell?.detailTextLabel?.text=UIColor.pbBlueColorValue(indexPath.row)
            color=(
                indexPath.row<PbUIColorLevel.level500.rawValue||indexPath.row==PbUIColorLevel.levelA100.rawValue
                    ?UIColor.blackColor():UIColor.whiteColor()
            )
            break
        //浅蓝色
        case 6:
            cell?.contentView.backgroundColor=UIColor.pbBlueLightColor(indexPath.row)
            cell?.detailTextLabel?.text=UIColor.pbBlueLightColorValue(indexPath.row)
            color=(
                (indexPath.row>PbUIColorLevel.level400.rawValue
                && indexPath.row<PbUIColorLevel.levelA100.rawValue) || indexPath.row == PbUIColorLevel.levelA700.rawValue ? UIColor.whiteColor():UIColor.blackColor()
            )
            break
        //青色
        case 7:
            cell?.contentView.backgroundColor=UIColor.pbCyanColor(indexPath.row)
            cell?.detailTextLabel?.text=UIColor.pbCyanColorValue(indexPath.row)
            color=(
                (indexPath.row>PbUIColorLevel.level400.rawValue
                    && indexPath.row<PbUIColorLevel.levelA100.rawValue) ? UIColor.whiteColor():UIColor.blackColor()
            )
            break
        //蓝绿色
        case 8:
            cell?.contentView.backgroundColor=UIColor.pbTealColor(indexPath.row)
            cell?.detailTextLabel?.text=UIColor.pbTealColorValue(indexPath.row)
            color=(
                (indexPath.row>PbUIColorLevel.level400.rawValue
                    && indexPath.row<PbUIColorLevel.levelA100.rawValue) ? UIColor.whiteColor():UIColor.blackColor()
            )
            break
            
        default:cell?.contentView.backgroundColor=UIColor.whiteColor()
        }
        
        cell?.textLabel?.textColor=color
        cell?.detailTextLabel?.textColor=color
        
        return cell!
    }
}