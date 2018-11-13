//
//  CAShapeLayerExtension.swift
//  DrawingRecorder
//
//  Created by 박길남 on 09/11/2018.
//  Copyright © 2018 swieeft. All rights reserved.
//

import UIKit

extension CAShapeLayer {
    // drawing에 사용될 레이어 만들기
    func createDrawingLayer(path:UIBezierPath, theme:DrawingData.Theme) {
        self.path = path.cgPath
        self.strokeStart = 0
        self.strokeEnd = 1
        self.strokeColor = theme.color.cgColor
        self.lineWidth = theme.width
        self.lineJoin = kCALineJoinMiter
        self.fillColor = UIColor.clear.cgColor
    }
}
