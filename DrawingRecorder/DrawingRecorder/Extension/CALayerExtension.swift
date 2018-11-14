//
//  CALayerExtension.swift
//  DrawingRecorder
//
//  Created by 박길남 on 14/11/2018.
//  Copyright © 2018 swieeft. All rights reserved.
//

import UIKit

extension CALayer {
    func roundBorder(cornerRadius:CGFloat, borderColor:UIColor, borderWidth:CGFloat, masksToBounds:Bool = true) {
        self.cornerRadius = cornerRadius
        self.borderColor = borderColor.cgColor
        self.borderWidth = borderWidth
        self.masksToBounds = masksToBounds
    }
}

