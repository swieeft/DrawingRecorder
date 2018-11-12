//
//  StopWatchLabel.swift
//  DrawingRecorder
//
//  Created by 박길남 on 12/11/2018.
//  Copyright © 2018 swieeft. All rights reserved.
//

import UIKit

class StopWatchLabel: UILabel {

    private var recodingCounter:TimeInterval = 0.0 //녹화 시간
    private var animationCounter:TimeInterval = 0.0 //애니메이션 재생 시간
    
    private var timer = Timer()
    
    private var counterStr:String = "" //애니메이션 재생 시 녹화 시간을 string형식으로 변환하여 사용하기 위한 변수
    
    private var speed = 1.0

    // 녹화 시작
    func startRecoding() {
        self.recodingCounter = 0.0
        
        self.text = "00:00"
        startTimer(selector: #selector(recodingUpdateTimer))
    }
    
    // 녹화 종료
    func endRecoding() {
        stopTimer()
    }
    
    // 애니메이션 시작
    func playAnimation(speed:Double) {
        self.speed = speed
        self.animationCounter = 0.0
        
        self.counterStr = recodingCounter.toStringTimeStopWatchFormatter()
        
        self.text = "00:00/\(counterStr)"
        startTimer(selector: #selector(animationUpdateTimer))
    }
    
    // 타이머 설정 후 시작
    func startTimer(selector:Selector) {
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: selector, userInfo: nil, repeats: true)
    }
    
    // 타이머 종료
    func stopTimer() {
        self.timer.invalidate()
        self.counterStr = ""
        print("stopwatch \(recodingCounter.toStringTimeStopWatchFormatter())")
    }
    
    // 녹화 시간 화면 표시
    @objc func recodingUpdateTimer() {
        recodingCounter = recodingCounter + 0.1
        let timeStr = recodingCounter.toStringTimeStopWatchFormatter()

        updateText(timeStr: timeStr)
    }
    
    // 애니메이션 재생 시간 화면 표시
    @objc func animationUpdateTimer() {
        animationCounter = animationCounter + (0.1 * speed)
        
        var timeStr = "\(animationCounter.toStringTimeStopWatchFormatter())/\(counterStr)"
        
        // 애니메이션 재생 시간이 녹화시간보다 크거나 같다면 타이머 정지
        if self.animationCounter >= self.recodingCounter {
            timeStr = "\(counterStr)/\(counterStr)"
            self.stopTimer()
        }
        
        updateText(timeStr: timeStr)
    }
    
    func updateText(timeStr:String) {
        DispatchQueue.main.async {
            self.text = timeStr
        }
    }
}

















