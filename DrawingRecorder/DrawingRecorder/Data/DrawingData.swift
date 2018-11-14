//
//  DrawingData.swift
//  DrawingRecorder
//
//  Created by 박길남 on 09/11/2018.
//  Copyright © 2018 swieeft. All rights reserved.
//

import UIKit

struct DrawingData {
    typealias TouchInfo = (point:CGPoint, timeInterval:TimeInterval)
    
    var startDrawing:TimeInterval // 터치 시작시간
    var endDrawing:TimeInterval // 터치 종료시간
    var theme:Theme // drawing 시 사용할 속성
    
    var touchInfos:[TouchInfo] // 라인의 포인트 및 시간 정보
    
    init() {
        self.startDrawing = 0
        self.endDrawing = 0
        self.theme = Theme()
        self.touchInfos = []
    }
    
    init(startDrawing:TimeInterval, theme:Theme) {
        self.startDrawing = startDrawing
        self.endDrawing = 0
        self.theme = theme
        self.touchInfos = []
    }
    
    // drawing 속성
    struct Theme {
        var color:UIColor // 라인 색상
        var width:CGFloat // 라인 두께
        
        init() {
            self.color = .black
            self.width = 5
        }
    }
}
