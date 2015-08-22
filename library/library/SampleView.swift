//
//  SampleView.swift
//  booklog
//
//  Created by arao on 2015/07/22.
//  Copyright (c) 2015年 arao. All rights reserved.
//

import Foundation
import UIKit

class SampleView :UIView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.greenColor()
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}