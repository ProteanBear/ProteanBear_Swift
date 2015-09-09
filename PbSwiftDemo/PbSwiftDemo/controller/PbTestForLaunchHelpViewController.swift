//
//  PbTestForLaunchHelpViewController.swift
//  PbSwiftDemo
//
//  Created by Maqiang on 15/9/9.
//  Copyright (c) 2015年 ProteanBear. All rights reserved.
//

import Foundation
import UIKit

class PbTestForLaunchHelpViewController: PbWidgetLaunchHelpViewController
{
    override func setup()
    {
        super.setup()
    }
    
    override func imageArray() -> Array<String>?
    {
        return ["back_help_a","back_help_b","back_help_c"]
    }
    
    override func pageControlSize() -> CGSize
    {
        return super.pageControlSize()
    }
}
