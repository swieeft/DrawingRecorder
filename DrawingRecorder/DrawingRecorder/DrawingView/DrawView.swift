//
//  DrawView.swift
//  DrawingRecorder
//
//  Created by 박길남 on 06/11/2018.
//  Copyright © 2018 swieeft. All rights reserved.
//

import UIKit

class DrawView: UIView {
    
    var points:[RecodingData.Touch] = []

    var recodingData:RecodingData = RecodingData()
    var drawingInfo = RecodingData.DrawingInfo()
    
    var color = UIColor.red
    var width:CGFloat = 5
    
    var isRemove:Bool = false
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let point = self.convert((touch?.location(in: self))!, to: self)
        
        if isRemove {
            checkHit(point: point)
            return
        }
        
        guard let timestamp = touch?.timestamp else {
            return
        }
        
        drawingInfo = RecodingData.DrawingInfo()
        drawingInfo.touchStart = timestamp
        drawingInfo.color = color
        drawingInfo.width = width
        
        let touchData:RecodingData.Touch = (point, timestamp)
        drawingInfo.touchDatas.append(touchData)
        points.append(touchData)
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let point = self.convert((touch?.location(in: self))!, to: self)
        
        if isRemove {
            checkHit(point: point)
            return
        }
        
        guard let timestamp = touch?.timestamp else {
            return
        }
        
        let touchData:RecodingData.Touch = (point, timestamp)
        drawingInfo.touchDatas.append(touchData)
        points.append(touchData)
        
        self.setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if points.count == 0 {
            return
        }
        
        points.removeAll()

        if let timestamp = touch?.timestamp {
            drawingInfo.touchEnd = timestamp
        }
        
        recodingData.drawingInfos.append(drawingInfo)
    }
    
    func checkHit(point:CGPoint) {
        self.layer.sublayers?.forEach({ (layer) in
            if let l = layer as? CAShapeLayer {
                if let path = l.path, path.contains(point) {
                    l.removeFromSuperlayer()
                }
            }
        })
    }
    
    func startRecoding() {
        recodingData = RecodingData()
        recodingData.startRecodingTime = ProcessInfo.processInfo.systemUptime
    }
    
    func endRecoding() {
        recodingData.endRecodingTime = ProcessInfo.processInfo.systemUptime
    }
    
//    func play() {
//        removeLayers()
//
//        let drawingInfos = self.recodingData.drawingInfos
//
//        let queue = DispatchQueue(label: "addLayer")
//        queue.async {
//            let interval = drawingInfos[0].touchStart - self.recodingData.startRecodingTime
//            Thread.sleep(forTimeInterval: interval)
//            for i in 0..<drawingInfos.count {
////                let layer = drawingInfos[i].setAnimation()
//                let layer = self.addSubLayer(path: path, color: self.color, width: self.width)
//
//                DispatchQueue.main.async {
//                    self.layer.addSublayer(layer)
//                }
//
//                if i == drawingInfos.count - 1 {
//                    let interval = drawingInfos[i].interval + (self.recodingData.endRecodingTime - drawingInfos[i].touchEnd)
//                    Thread.sleep(forTimeInterval: interval)
//                } else {
//                    let interval = drawingInfos[i].interval + (drawingInfos[i + 1].touchStart - drawingInfos[i].touchEnd)
//                    Thread.sleep(forTimeInterval: interval)
//                }
//            }
//        }
//    }
    
    
//    func setAnimation() -> CALayer {
//        var animations:[CAAnimation] = []
//
//        var beginTime:TimeInterval = 0
//        var value:Double = 0
//
//        let layer = CAShapeLayer()
//        layer.path = path.cgPath
//        layer.strokeStart = 0
//        layer.strokeEnd = 1
//        layer.strokeColor = color.cgColor
//        layer.lineWidth = width
//        layer.lineJoin = kCALineJoinMiter
//        layer.fillColor = UIColor.clear.cgColor
//
//        for i in 1..<self.touchDatas.count {
//
//            let duration = self.touchDatas[i].timeInterval - self.touchDatas[i - 1].timeInterval
//
//            let toValue = value + (duration / interval)
//
//            let animation = CABasicAnimation(keyPath: "strokeEnd")
//            animation.beginTime = CACurrentMediaTime() + beginTime
//            animation.fromValue = value
//            animation.toValue = toValue
//            animation.duration = duration
//
//            beginTime += duration
//            value = toValue
//
//            animations.append(animation)
//        }
//
//        for i in 0..<animations.count {
//            layer.add(animations[i], forKey: "ani\(i)")
//        }
//
//        return layer
//    }
    
    var isPlay = false
    
    func play() {
        
        isPlay = true
        
        removeLayers()
        
        let drawingInfos = self.recodingData.drawingInfos
        
        let queue = DispatchQueue(label: "addLayer")
        queue.async {
            
            let interval = drawingInfos[0].touchStart - self.recodingData.startRecodingTime
            Thread.sleep(forTimeInterval: interval)
            
            for i in 0..<drawingInfos.count {
                let path = UIBezierPath()
                let layer = self.addSubLayer(path: path, color: self.color, width: self.width)
                
                DispatchQueue.main.async {
                    self.layer.addSublayer(layer)
                    self.setNeedsDisplay()
                }
                
                for j in 0..<drawingInfos[i].touchDatas.count {
                    if j == 0 {
                        path.move(to: drawingInfos[i].touchDatas[j].point)
                        
                        DispatchQueue.main.async {
                            layer.path = path.cgPath
                            self.setNeedsDisplay()
                        }
                        
                        if j + 1 >=  drawingInfos[i].touchDatas.count {
                            continue
                        }
                        
                        let interval = drawingInfos[i].touchDatas[j + 1].timeInterval - drawingInfos[i].touchDatas[j].timeInterval
                        Thread.sleep(forTimeInterval: interval)
                    } else {
                        path.addLine(to: drawingInfos[i].touchDatas[j].point)
                        
                        DispatchQueue.main.async {
                            layer.path = path.cgPath
                            self.setNeedsDisplay()
                        }
                        
                        if j + 1 >=  drawingInfos[i].touchDatas.count {
                            continue
                        }
                        
                        let interval = drawingInfos[i].touchDatas[j + 1].timeInterval - drawingInfos[i].touchDatas[j].timeInterval
                        Thread.sleep(forTimeInterval: interval)
                    }
                }
                
//                DispatchQueue.main.async {
//                    self.layer.addSublayer(layer)
//                }
                
                if i == drawingInfos.count - 1 {
                    let interval = drawingInfos[i].interval + (self.recodingData.endRecodingTime - drawingInfos[i].touchEnd)
                    Thread.sleep(forTimeInterval: interval)
                } else {
                    let interval = drawingInfos[i].interval + (drawingInfos[i + 1].touchStart - drawingInfos[i].touchEnd)
                    Thread.sleep(forTimeInterval: interval)
                }
            }
            
            DispatchQueue.main.async {
                self.isPlay = false
            }
        }
    }
    
    func removeLayers() {
        self.layer.sublayers?.forEach({ (layer) in
            layer.removeFromSuperlayer()
        })
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        if isPlay {
            return
        }
        drawLine()
    }
    
    func drawLine() {
        removeLayers()
        
        let path = UIBezierPath()
        
        for i in 0..<points.count {
            if i == 0 {
                path.move(to: points[i].point)
            } else {
                path.addLine(to: points[i].point)
            }
        }
        
        let layer = addSubLayer(path: path, color: color, width: width)
        self.layer.addSublayer(layer)
    }
    
    func addSubLayer(path:UIBezierPath, color:UIColor, width:CGFloat) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.strokeStart = 0
        layer.strokeEnd = 1
        layer.strokeColor = color.cgColor
        layer.lineWidth = width
        layer.lineJoin = kCALineJoinMiter
        layer.fillColor = UIColor.clear.cgColor
        
//        self.layer.addSublayer(layer)
        
        return layer
    }
}




























