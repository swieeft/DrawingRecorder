//
//  DrawView.swift
//  DrawingRecorder
//
//  Created by 박길남 on 06/11/2018.
//  Copyright © 2018 swieeft. All rights reserved.
//

import UIKit

protocol DrawingAnimationDelegate {
    func stopAnimation()
}

class DrawingView: UIView {
    
    // MARK: Properties
    private var recodingData = RecodingData()
    private var drawingData = DrawingData()
    private(set) var animationData = AnimationData()
    private(set) var theme = DrawingData.Theme()
    
    private(set) var isRecoding:Bool = false
    private(set) var isAnimationPlay:Bool = false

    private var workItem:DispatchWorkItem?
    
    var delegate:DrawingAnimationDelegate?
    
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
        if isRecoding == false || self.drawingData.touchInfos.count == 0 {
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
    
    // MARK: Animation Methods
    
    // 애니메이션 재생
    // - 타이머 설정 후 타이머의 값을 비교하여 타이머 값보다 터치 된 시간이 이전 시간일 경우에 화면에 그림
    // - 아직 타이머 값이 이전일 경우 대기하고 있음
    func animationPlay() {
        
        // 녹화 중일 경우 애니메이션 실행을 막음
        if isRecoding {
            return
        }
        
        self.removeAllSubLayer()
        
        let drawingDatas = self.recodingData.drawingDatas
        
        // 녹화 된 데이터가 없을 경우 종료
        if drawingDatas.count == 0 {
            self.delegate?.stopAnimation()
            return
        }
        
        isAnimationPlay = true
        
        //애니메이션 타이머 시작
        self.animationData.startTimer(recodingInterval: self.recodingData.interval)
        
        let queue = DispatchQueue(label: "drawingAnimation")
        queue.async {
            
            // 애니메이션 수행이 완료 되면 play 상태를 false로 돌려놓고 애니메이션 작업이 완료
            defer {
                DispatchQueue.main.async {
                    self.isAnimationPlay = false
                    self.delegate?.stopAnimation()
                }
            }
            
            self.watingDraw(time: drawingDatas[0].startDrawing)
            
            for i in 0..<drawingDatas.count {
                let data = drawingDatas[i]
                
                let path = UIBezierPath()
                
                let layer = CAShapeLayer()
                layer.createDrawingLayer(path: path, theme: data.theme)
                
                DispatchQueue.main.async {
                    self.layer.addSublayer(layer)
                }
                
                for j in 0..<data.touchInfos.count {
                    
                    let info = data.touchInfos[j]
                    
                    j == 0 ? path.move(to: info.point) : path.addLine(to: info.point)
                    
                    DispatchQueue.main.async {
                        layer.path = path.cgPath
                    }
                    
                    if j + 1 >= data.touchInfos.count {
                        continue
                    }
                    
                    self.watingDraw(time: data.touchInfos[j + 1].timeInterval)
                }
                
                let time = i == (drawingDatas.count - 1) ? self.recodingData.endRecoding : drawingDatas[i + 1].startDrawing
                self.watingDraw(time: time)
            }
        }
    }
    
    // 해당 포인트를 그린 시간이 될때까지 대기
    func watingDraw(time:TimeInterval) {
        let interval = time - self.recodingData.startRecoding
        
        while self.animationData.timerCounter <= interval {
            Thread.sleep(forTimeInterval: 0.001 / self.animationData.speed)
        }
    }
}



























