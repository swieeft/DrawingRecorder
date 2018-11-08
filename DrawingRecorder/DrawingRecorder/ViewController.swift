//
//  ViewController.swift
//  DrawingRecorder
//
//  Created by 박길남 on 06/11/2018.
//  Copyright © 2018 swieeft. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ColorPickerDelegate {

    @IBOutlet weak var drawView: DrawView!
    @IBOutlet weak var recodingButton: RecodingButton!
    @IBOutlet weak var colorPickerButton: UIButton!
    @IBOutlet weak var informationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func start(_ sender: UIButton) {
        recodingButton.isRecoding ? drawView.endRecoding() : drawView.startRecoding()
        
        drawView.isUserInteractionEnabled =  !recodingButton.isRecoding
        informationLabel.isHidden =  !recodingButton.isRecoding
        
        recodingButton.recoding()
    }
    
    @IBAction func play(_ sender: Any) {
        drawView.play()
    }
    
    @IBAction func selectColor(_ sender: Any) {
        guard let colorVC = UIStoryboard(name: "ColorPickerViewController", bundle: nil).instantiateInitialViewController() as? ColorPickerViewController else {
            return
        }
        
        colorVC.currentColor = drawView.color
        colorVC.delegate = self
        colorVC.modalPresentationStyle = .overCurrentContext
        
        self.present(colorVC, animated: false, completion: nil)
    }
    
    @IBAction func removeDraw(_ sender: Any) {
        drawView.removePath()
    }
    
    func setColor(color: UIColor) {
        let origImage = UIImage(named: "pencil")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        colorPickerButton.setImage(tintedImage, for: .normal)
        colorPickerButton.tintColor = color

        drawView.color = color
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



























































