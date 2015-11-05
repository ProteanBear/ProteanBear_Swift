//
//  PbTestForBasicExtensionStringCode.swift
//  PbSwiftDemo
//
//  Created by Maqiang on 15/9/22.
//  Copyright © 2015年 ProteanBear. All rights reserved.
//

import Foundation
import UIKit

class PbTestForBasicExtensionStringCode: UIViewController
{
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var codeButton: UIButton!
    @IBOutlet weak var resultTextField: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //设置输入框右侧边距
        self.codeTextField.pbSetRightPadding(self.codeButton.frame.size.width)
        //设置返回结果的显示区样式
        self.resultTextField.layer.cornerRadius=4
    }
    
    @IBAction func codeButtonAction(sender: UIButton)
    {
        self.resultTextField.text=self.codeTextField.text?.md5()
    }
}
