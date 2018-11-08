//
//  RecodingButton.swift
//  DrawingRecorder
//
//  Created by 박길남 on 08/11/2018.
//  Copyright © 2018 swieeft. All rights reserved.
//

import UIKit

class RecodingButton: UIButton {
    private var startLayer:CAShapeLayer = CAShapeLayer()
    private var stopLayer:CAShapeLayer = CAShapeLayer()
    
    private var layerAnimation = CABasicAnimation(keyPath: "path")
    
    private(set) var isRecoding = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setCircleButton()
        setAnimation()
        setStartLayer()
        setStopLayer()
    }
    
    private func setCircleButton() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.layer.frame.width / 2
    }
    
    private func setAnimation() {
        layerAnimation.duration = 1
        layerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        layerAnimation.fillMode = kCAFillModeForwards
        layerAnimation.isRemovedOnCompletion = false
    }
    
    private func getCenter() -> CGPoint {
        let x = self.bounds.maxX / 2
        let y = self.bounds.maxY / 2
        let center = CGPoint(x: x, y: y)
        
        return center
    }
    
    private func setStartLayer() {
        let pathCenter = getCenter()
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: pathCenter.x + 15, y: pathCenter.y))
        path.addArc(withCenter: pathCenter, radius: 15, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        
        startLayer.path = path.cgPath
        startLayer.fillColor = UIColor.red.cgColor
        
        self.layer.addSublayer(startLayer)
    }
    
    private func setStopLayer() {
        let pathCenter = getCenter()
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: pathCenter.x - 10, y: pathCenter.y - 10))
        path.addLine(to: CGPoint(x: pathCenter.x + 10, y: pathCenter.y - 10))
        path.addLine(to: CGPoint(x: pathCenter.x + 10, y: pathCenter.y + 10))
        path.addLine(to: CGPoint(x: pathCenter.x - 10, y: pathCenter.y + 10))
        
        stopLayer.path = path.cgPath
        stopLayer.fillColor = UIColor.red.cgColor
    }
    
    func recoding() {
        if isRecoding {
            layerAnimation.fromValue = stopLayer.path
            layerAnimation.toValue = startLayer.path
            startLayer.add(layerAnimation, forKey: "changePath")
        } else {
            layerAnimation.fromValue = startLayer.path
            layerAnimation.toValue = stopLayer.path
            startLayer.add(layerAnimation, forKey: "changePath")
        }
        
        isRecoding = !isRecoding
    }
}
