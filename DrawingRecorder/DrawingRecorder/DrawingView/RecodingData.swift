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
        
        func setAnimation() -> CALayer {
            var animations:[CAAnimation] = []

            var beginTime:TimeInterval = 0
            var value:Double = 0
            
            let layer = CAShapeLayer()
            layer.path = path.cgPath
            layer.strokeStart = 0
            layer.strokeEnd = 1
            layer.strokeColor = color.cgColor
            layer.lineWidth = width
            layer.lineJoin = kCALineJoinMiter
            layer.fillColor = UIColor.clear.cgColor
            
            for i in 1..<self.touchDatas.count {
                
                let duration = self.touchDatas[i].timeInterval - self.touchDatas[i - 1].timeInterval
                
                let toValue = value + (duration / interval)
                
                let animation = CABasicAnimation(keyPath: "strokeEnd")
                animation.beginTime = CACurrentMediaTime() + beginTime
                animation.fromValue = value
                animation.toValue = toValue
                animation.duration = duration
                
                beginTime += duration
                value = toValue
                
                animations.append(animation)
            }
            
            for i in 0..<animations.count {
                layer.add(animations[i], forKey: "ani\(i)")
            }
            
            return layer
        }
    }
}




