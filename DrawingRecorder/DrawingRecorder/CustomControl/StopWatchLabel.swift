//
//  StopWatchLabel.swift
//  DrawingRecorder
//
//  Created by 박길남 on 12/11/2018.
//  Copyright © 2018 swieeft. All rights reserved.
//

import UIKit

class StopWatchLabel: UILabel {

    // MARK: Properties
    private var recodingCounter:TimeInterval = 0.0 //녹화 시간
    private var animationCounter:TimeInterval = 0.0 //애니메이션 재생 시간
    
    private var timer = Timer()
    
    private var counterStr:String = "" //애니메이션 재생 시 녹화 시간을 string형식으로 변환하여 사용하기 위한 변수
    
    private var speed = 1.0
    
    private let timerInterval = 0.1

    // MARK: - Methods
    
    // 녹화 시작
    func startRecoding() {
        self.recodingCounter = 0.0
        
        self.text = "00:00.0"
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
        
        self.text = "00:00.0/\(counterStr)"
        startTimer(selector: #selector(animationUpdateTimer))
    }
    
    // MARK: Timer Methods
    
    // 타이머 설정 후 시작
    private func startTimer(selector:Selector) {
        self.timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: selector, userInfo: nil, repeats: true)
    }
    
    // 타이머 종료
    private func stopTimer() {
        self.timer.invalidate()
        self.counterStr = ""
    }
    
    // 녹화 시간 화면 표시
    @objc private func recodingUpdateTimer() {
        recodingCounter = recodingCounter + timerInterval
        let timeStr = recodingCounter.toStringTimeStopWatchFormatter()

        updateText(timeStr: timeStr)
    }
    
    // 애니메이션 재생 시간 화면 표시
    @objc private func animationUpdateTimer() {
        animationCounter = animationCounter + (timerInterval * speed)
        
        var timeStr = "\(animationCounter.toStringTimeStopWatchFormatter())/\(counterStr)"
        
        // 애니메이션 재생 시간이 녹화시간보다 크거나 같다면 타이머 정지
        if self.animationCounter >= self.recodingCounter {
            timeStr = "\(counterStr)/\(counterStr)"
            self.stopTimer()
        }
        
        updateText(timeStr: timeStr)
    }
    
    // Label에 시간 표시
    private func updateText(timeStr:String) {
        DispatchQueue.main.async {
            self.text = timeStr
        }
    }
}

















