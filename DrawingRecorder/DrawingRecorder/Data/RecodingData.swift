//
//  Line.swift
//  DrawingRecorder
//
//  Created by 박길남 on 06/11/2018.
//  Copyright © 2018 swieeft. All rights reserved.
//

import UIKit

struct RecodingData {
    var startRecoding:TimeInterval = 0 // 녹화 시작시간
    var endRecoding:TimeInterval = 0 // 녹화 종료시간
    var drawingDatas:[DrawingData] = [] // 녹화 시 입력 된 drawing 정보
    
    // 녹화된 시간
    var interval:TimeInterval {
        get {
            return endRecoding - startRecoding
        }
    }
}
























