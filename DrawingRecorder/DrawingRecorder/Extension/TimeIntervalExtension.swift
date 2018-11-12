//
//  TimeIntervalExtension.swift
//  DrawingRecorder
//
//  Created by 박길남 on 12/11/2018.
//  Copyright © 2018 swieeft. All rights reserved.
//

import UIKit

extension TimeInterval {
    func toStringTimeStopWatchFormatter() -> String {
        let time = Int(self)
        
        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 100)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        
        let timeStr = String(format: "%0.2d:%0.2d.%0.2d", minutes, seconds, ms)
        return timeStr
    }
}
