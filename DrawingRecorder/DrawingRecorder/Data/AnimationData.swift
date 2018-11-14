//
//  AnimationData.swift
//  DrawingRecorder
//
//  Created by 박길남 on 09/11/2018.
//  Copyright © 2018 swieeft. All rights reserved.
//

import UIKit

class AnimationData {
    var speed:Double // 애니메이션 재생속도
    var timerCounter:TimeInterval // 애니메이션 타이머 진행 시간
    
    private var recodingInterval:TimeInterval // 녹화시간
    private let timerInterval = 0.005
    
    private var timer:Timer?
    
    init() {
        self.speed = 1.0
        self.timerCounter = 0.0
        self.recodingInterval = 0.0
    }
    
    // 타이머 시작
    func startTimer(recodingInterval:TimeInterval) {
        self.recodingInterval = recodingInterval
        
        self.timerCounter = 0.0
        self.timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(animationUpdateTimer), userInfo: nil, repeats: true)
    }
    
    // 타이머 값 증가
    @objc func animationUpdateTimer() {
        self.timerCounter += timerInterval * self.speed
        
        if self.timerCounter >= self.recodingInterval {
            self.timer?.invalidate()
        }
    }
}
