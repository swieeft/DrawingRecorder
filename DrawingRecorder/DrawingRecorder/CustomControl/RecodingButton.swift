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
    
    private let animationKey = "changePath"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setCircleView()
        
        setAnimation()
        setStartLayer()
        setStopLayer()
    }
    
    // 버튼 클릭 시 사용 될 애니메이션 설정
    private func setAnimation() {
        layerAnimation.duration = 1
        layerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        layerAnimation.fillMode = kCAFillModeForwards
        layerAnimation.isRemovedOnCompletion = false
    }
    
    // 녹화 시작 버튼 모양 레이어 설정
    private func setStartLayer() {
        let pathCenter = getCenter()
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: pathCenter.x + 15, y: pathCenter.y))
        path.addArc(withCenter: pathCenter, radius: 15, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        
        startLayer.path = path.cgPath
        startLayer.fillColor = UIColor.red.cgColor
        
        self.layer.addSublayer(startLayer)
    }
    
    // 녹화 종료 버튼 모양 레이어 설정
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
    
    // 버튼의 Center Point 계산
    private func getCenter() -> CGPoint {
        let x = self.bounds.maxX / 2
        let y = self.bounds.maxY / 2
        let center = CGPoint(x: x, y: y)
        
        return center
    }
    
    // 녹화 시작, 종료 시 버튼 모양 변경
    func recoding(isRecoding:Bool) {
        if isRecoding {
            layerAnimation.fromValue = stopLayer.path
            layerAnimation.toValue = startLayer.path
            startLayer.add(layerAnimation, forKey: animationKey)
        } else {
            layerAnimation.fromValue = startLayer.path
            layerAnimation.toValue = stopLayer.path
            startLayer.add(layerAnimation, forKey: animationKey)
        }
    }
}
