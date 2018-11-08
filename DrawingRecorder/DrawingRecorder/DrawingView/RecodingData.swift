//
//  Line.swift
//  DrawingRecorder
//
//  Created by 박길남 on 06/11/2018.
//  Copyright © 2018 swieeft. All rights reserved.
//

import UIKit

struct RecodingData {
    typealias Touch = (point:CGPoint, timeInterval:TimeInterval)
    
    var startRecodingTime:TimeInterval = 0
    var endRecodingTime:TimeInterval = 0
    var drawingInfos:[DrawingInfo] = []
    
    var isPaly:Bool = false
    
    struct DrawingInfo {
        
        var touchStart:TimeInterval = 0
        var touchEnd:TimeInterval = 0
        
        var touchDatas:[Touch] = []
        
        var color:UIColor = UIColor.clear
        var width:CGFloat = 0
        
        var path:UIBezierPath {
            get {
                let bezierPath = UIBezierPath()

                for i in 0..<self.touchDatas.count {
                    if i == 0 {
                        bezierPath.move(to: self.touchDatas[i].point)
                    } else {
                        bezierPath.addLine(to: self.touchDatas[i].point)
                    }
                }

                return bezierPath
            }
        }
        
        var interval:TimeInterval {
            get {
                return touchEnd - touchStart
            }
        }
    }
}




