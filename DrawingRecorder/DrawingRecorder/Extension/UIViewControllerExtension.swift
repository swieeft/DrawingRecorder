//
//  UIViewController.swift
//  DrawingRecorder
//
//  Created by 박길남 on 09/11/2018.
//  Copyright © 2018 swieeft. All rights reserved.
//

import UIKit

protocol StoryboardName: class {
    
}

extension StoryboardName where Self:UIViewController {
    static var storyboardName: String {
        return String(describing: self)
    }
}

extension UIViewController: StoryboardName {
    func setPopoverViewController(size:CGSize, sourceView:UIView, delegate:UIPopoverPresentationControllerDelegate) {
        self.modalPresentationStyle = .popover
        self.preferredContentSize = size
        self.popoverPresentationController?.sourceView = sourceView
        self.popoverPresentationController?.sourceRect = sourceView.bounds
        self.popoverPresentationController?.permittedArrowDirections = .any
        self.popoverPresentationController?.delegate = delegate
    }
    
    static func storyboardInstance<T:UIViewController>() -> T? {
        let vc = UIStoryboard(name: self.storyboardName, bundle: nil).instantiateInitialViewController() as? T
        return vc
    }
}
