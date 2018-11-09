//
//  LineWidthSelectViewController.swift
//  DrawingRecorder
//
//  Created by 박길남 on 09/11/2018.
//  Copyright © 2018 swieeft. All rights reserved.
//

import UIKit

protocol LineWidthSelectProtocol {
    func selectLineWidth(width:Int)
}

class LineWidthSelectViewController: UIViewController {

    @IBOutlet weak var borderView: UIView!
    
    @IBOutlet weak var widthTextField: UITextField!
    
    @IBOutlet weak var upSizeButton: UIButton!
    @IBOutlet weak var downSizeButton: UIButton!
    
    var currentWidth:Int = 0 // 현재 펜 굵기
    
    var delegate:LineWidthSelectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        widthTextField.text = "\(currentWidth)"
    }
    
    // 펜 굵기 증가
    @IBAction func upSize(_ sender: Any) {
        // 굵기는 100보다 클 수 없음
        if currentWidth == 100 {
            return
        }
        currentWidth += 1
        setLineWidth()
    }
    
    // 펜 굵기 감소
    @IBAction func downSize(_ sender: Any) {
        // 굵기는 1보다 작을 수 없음
        if currentWidth == 1 {
            return
        }
        
        currentWidth -= 1
        setLineWidth()
    }
    
    func setLineWidth() {
        widthTextField.text = "\(currentWidth)"
        self.delegate?.selectLineWidth(width: currentWidth)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
