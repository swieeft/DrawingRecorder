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
    
    var currentWidth:Int = 0
    
    var delegate:LineWidthSelectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        widthTextField.text = "\(currentWidth)"
    }
    
    @IBAction func upSize(_ sender: Any) {
        if currentWidth == 100 {
            return
        }
        currentWidth += 1
        setLineWidth()
    }
    
    @IBAction func downSize(_ sender: Any) {
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
