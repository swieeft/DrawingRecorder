//
//  DrawView.swift
//  DrawingRecorder
//
//  Created by 박길남 on 06/11/2018.
//  Copyright © 2018 swieeft. All rights reserved.
//

import UIKit

class DrawingView: UIView {
    
    // MARK: Properties
    private var recodingData = RecodingData()
    private var drawingData = DrawingData()
    private(set) var animationData = AnimationData()
    private(set) var theme = DrawingData.Theme()
    
    private(set) var isRecoding:Bool = false
    private(set) var isAnimationPlay:Bool = false
    
    // MARK: - Methods
    // MARK: Touches Methods
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isRecoding == false {
            return
        }
        
        guard let touch = touches.first else {
            return
        }
        
        // 새로운 그림 데이터 레코딩 시작
        self.drawingData = DrawingData()
        self.drawingData.startDrawing = touch.timestamp
        self.drawingData.theme = self.theme
        
        let point = self.convert(touch.location(in: self), to: self)
        self.drawingData.touchInfos.append((point, touch.timestamp))
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isRecoding == false {
            return
        }
        
        guard let touch = touches.first else {
            return
        }
        
        let point = self.convert(touch.location(in: self), to: self)
        self.drawingData.touchInfos.append((point, touch.timestamp))

        self.setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isRecoding == false {
            return
        }
        
        if self.drawingData.touchInfos.count == 0 {
            return
        }
        
        guard let touch = touches.first else {
            return
        }
        
        self.drawingData.endDrawing = touch.timestamp
        self.recodingData.drawingDatas.append(self.drawingData)
    }
    
    // MARK: Properties Setting Methods
    
    // 녹화 시간 - 녹화 데이터를 새로 만듬
    func startRecoding() {
        self.removeAllSubLayer()
        
        recodingData = RecodingData()
        recodingData.startRecoding = ProcessInfo.processInfo.systemUptime
        self.isUserInteractionEnabled = true
        isRecoding = true
    }
    
    // 녹화 종료
    func endRecoding() {
        recodingData.endRecoding = ProcessInfo.processInfo.systemUptime
        self.isUserInteractionEnabled = false
        isRecoding = false
    }
    
    // 펜 색상 선택
    func setPencilColor(color:UIColor) {
        setColor(color: color)
    }
    
    // 지우개 선택
    func selectEraser() {
        if let backColor = self.backgroundColor {
            setColor(color: backColor)
        }
    }
    
    // 펜 색상 설정
    private func setColor(color:UIColor) {
        self.theme.color = color
    }
    
    // 펜 두께 설정
    func setLineWidth(width:Int) {
        self.theme.width = CGFloat(width)
    }
    
    // 애니메이션 속도 설정
    func setSpeed(speed:Double) {
        self.animationData.speed = speed
    }
    
    // MARK: Drawing Methods
    override func draw(_ rect: CGRect) {
        // 애니메이션이 실행 중일 경우 그리기를 할 수 없게 함
        if isAnimationPlay {
            return
        }
        
        // 녹화 중이 아닐 경우 그리기를 할 수 없게 함
        if isRecoding == false {
            return
        }
        
        drawPath()
    }
    
    // 사용자가 녹화를 시작하고 그리기를 하면 뷰에 그림을 그려줌
    func drawPath() {
        self.removeAllSubLayer()
        
        // 이전에 입력 된 경로를 먼저 그려줌
        for i in 0..<self.recodingData.drawingDatas.count {
            let path = UIBezierPath()
            
            let drawingData = self.recodingData.drawingDatas[i]
            
            let touchInfos = drawingData.touchInfos
            
            for j in 0..<touchInfos.count {
                j == 0 ? path.move(to: touchInfos[j].point) : path.addLine(to: touchInfos[j].point)
            }
            
            let layer = CAShapeLayer()
            layer.createDrawingLayer(path: path, theme: drawingData.theme)
            self.layer.addSublayer(layer)
        }
        
        // 새로 입력 중인 경로를 그려줌
        let path = UIBezierPath()
        for i in 0..<self.drawingData.touchInfos.count {
            let info = self.drawingData.touchInfos[i]
            
            i == 0 ? path.move(to: info.point) : path.addLine(to: info.point)
        }
        
        let layer = CAShapeLayer()
        layer.createDrawingLayer(path: path, theme: self.drawingData.theme)
        self.layer.addSublayer(layer)
    }
    
    // 애니메이션 재생
    func animationPlay() {
        // 녹화 중일 경우 애니메이션 실행을 막음
        if isRecoding {
            return
        }
        
        isAnimationPlay = true
        
        self.removeAllSubLayer()
        
        let drawingDatas = self.recodingData.drawingDatas
        
        if drawingDatas.count == 0 {
            return
        }
        
        let queue = DispatchQueue(label: "recodingAnimation")
        queue.async {
            // 애니메이션 수행이 완료 되면 play 상태를 false로 돌려놓고 애니메이션 작업이 완료
            defer {
                DispatchQueue.main.async {
                    self.isAnimationPlay = false
                }
            }
            
            // 녹화 시작 시간 - 첫 터치 시간 만큼 대기 후 그리기 실행
            self.sleep(time1: drawingDatas[0].startDrawing, time2: self.recodingData.startRecoding)
            
            for i in 0..<drawingDatas.count {
                
                let data = drawingDatas[i]
                
                let path = UIBezierPath()

                let layer = CAShapeLayer()
                layer.createDrawingLayer(path: path, theme: data.theme)
                
                DispatchQueue.main.async {
                    self.layer.addSublayer(layer)
                    self.setNeedsDisplay()
                }
                
                for j in 0..<data.touchInfos.count {
                    let info = data.touchInfos[j]
                    
                    j == 0 ? path.move(to: info.point) : path.addLine(to: info.point)
                    
                    DispatchQueue.main.async {
                        layer.path = path.cgPath
                        self.setNeedsDisplay()
                    }

                    if j + 1 >= data.touchInfos.count {
                        continue
                    }
                    
                    self.sleep(time1: data.touchInfos[j + 1].timeInterval, time2: info.timeInterval)
                }
                
                if i == (drawingDatas.count - 1) {
                    self.sleep(time1: self.recodingData.endRecoding, time2: data.endDrawing)
                } else {
                    self.sleep(time1: drawingDatas[i + 1].startDrawing, time2: data.endDrawing)
                }
            }
        }
    }
    
    // time1 - time2 만큼의 시간 동안 스레드 정지
    func sleep(time1:TimeInterval, time2:TimeInterval) {
        let interval = time1 - time2
        Thread.sleep(forTimeInterval: interval / self.animationData.speed)
    }
}




























