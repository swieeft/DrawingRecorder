//
//  UIViewExtension.swift
//  DrawingRecorder
//
//  Created by 박길남 on 09/11/2018.
//  Copyright © 2018 swieeft. All rights reserved.
//

import UIKit

extension UIView {
    // 뷰를 원형으로 만듬
    func setCircleView() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.layer.frame.width / 2
    }
    
    // 뷰 탭 제스처 설정
    func setTapGesture(target:Any?, action:Selector?) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
    }
    
    func removeAllSubLayer() {
        self.layer.sublayers?.forEach({ (layer) in
            layer.removeFromSuperlayer()
        })
    }
}
