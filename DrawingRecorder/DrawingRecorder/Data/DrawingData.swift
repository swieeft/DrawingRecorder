//
//  DrawingData.swift
//  DrawingRecorder
//
//  Created by 박길남 on 09/11/2018.
//  Copyright © 2018 swieeft. All rights reserved.
//

import UIKit

struct DrawingData {
    typealias TouchInfo = (point:CGPoint, timeInterval:TimeInterval)
    
    var startDrawing:TimeInterval = 0
    var endDrawing:TimeInterval = 0
    var theme:Theme = Theme()
    
    var touchInfos:[TouchInfo] = []
    
    struct Theme {
        var color:UIColor = .black
        var width:CGFloat = 5
    }
}
