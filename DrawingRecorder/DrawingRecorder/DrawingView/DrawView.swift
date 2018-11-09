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
    
    private(set) var color = UIColor.black
    private(set) var width:CGFloat = 5
    
    var drawLayer:CAShapeLayer = CAShapeLayer()
    
    var isPlay = false
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let point = self.convert((touch?.location(in: self))!, to: self)
        
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
    
    func startRecoding() {
        recodingData = RecodingData()
        recodingData.startRecodingTime = ProcessInfo.processInfo.systemUptime
        
        removeLayers()
    }
    
    func endRecoding() {
        recodingData.endRecodingTime = ProcessInfo.processInfo.systemUptime
    }
    
    func selectPencil(color:UIColor) {
        setColor(color: color)
    }
    
    func selectEraser() {
        if let backColor = self.backgroundColor {
            setColor(color: backColor)
        }
    }
    
    func setColor(color:UIColor) {
        self.color = color
    }
    
    func setLineWidth(width:Int) {
        self.width = CGFloat(width)
    }
    
    func play() {
        
        isPlay = true
        
        removeLayers()
        
        let drawingInfos = self.recodingData.drawingInfos
        
        if drawingInfos.count == 0 {
            return
        }
        
        let queue = DispatchQueue(label: "addLayer")
        queue.async {
            
            let interval = drawingInfos[0].touchStart - self.recodingData.startRecodingTime
            
            Thread.sleep(forTimeInterval: interval)
            
            for i in 0..<drawingInfos.count {
                let path = UIBezierPath()
                let layer = self.addSubLayer(path: path, color: drawingInfos[i].color, width: drawingInfos[i].width)
                
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
                
                if i == drawingInfos.count - 1 {
                    let interval = drawingInfos[i].interval + (self.recodingData.endRecodingTime - drawingInfos[i].touchEnd)
                    Thread.sleep(forTimeInterval: interval)
                } else {
                    let interval = drawingInfos[i + 1].touchStart - drawingInfos[i].touchEnd
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
        
        for i in 0..<self.recodingData.drawingInfos.count {
            let path = UIBezierPath()
            
            let touchDatas = self.recodingData.drawingInfos[i].touchDatas
            
            for j in 0..<touchDatas.count {
                if j == 0 {
                    path.move(to: touchDatas[j].point)
                } else {
                    path.addLine(to: touchDatas[j].point)
                }
            }
            
            let layer = addSubLayer(path: path, color: recodingData.drawingInfos[i].color, width: recodingData.drawingInfos[i].width)
            self.layer.addSublayer(layer)
        }
        
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
         
        return layer
    }
}




























