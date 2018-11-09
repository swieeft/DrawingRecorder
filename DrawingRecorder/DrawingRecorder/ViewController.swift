//
//  ViewController.swift
//  DrawingRecorder
//
//  Created by 박길남 on 06/11/2018.
//  Copyright © 2018 swieeft. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate, ColorPickerDelegate, LineWidthSelectProtocol {

    @IBOutlet weak var drawView: DrawView!
    
    @IBOutlet weak var recodingButton: RecodingButton!
    
    @IBOutlet weak var pencilButton: UIButton!
    @IBOutlet weak var colorPickerButton: UIButton!
    @IBOutlet weak var eraserButton: UIButton!
    
    @IBOutlet weak var lineWidthView: UIView!
    @IBOutlet weak var lineWidthLabel: UILabel!
    
    @IBOutlet weak var informationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.colorPickerButton.layer.masksToBounds = false
        self.colorPickerButton.layer.cornerRadius = self.colorPickerButton.layer.frame.width / 2
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectLineWidthOpen(sender:)))
        self.lineWidthView.isUserInteractionEnabled = true
        self.lineWidthView.addGestureRecognizer(tapGesture)
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
    
    @IBAction func selectColor(_ sender: UIButton) {
        guard let colorVC = UIStoryboard(name: "ColorPickerViewController", bundle: nil).instantiateInitialViewController() as? ColorPickerViewController else {
            return
        }
        
        if let color = colorPickerButton.backgroundColor {
            colorVC.currentColor = color
        }
        colorVC.delegate = self
//        colorVC.modalPresentationStyle = .popover
        colorVC.modalPresentationStyle = .popover
        colorVC.preferredContentSize = CGSize(width: 200, height: 200)
        colorVC.popoverPresentationController?.sourceView = sender
        colorVC.popoverPresentationController?.sourceRect = sender.bounds
        colorVC.popoverPresentationController?.permittedArrowDirections = .any
        colorVC.popoverPresentationController?.delegate = self
        
        self.present(colorVC, animated: true, completion: nil)
    }
    
    @IBAction func selectPencil(_ sender: Any) {
        if let color = colorPickerButton.backgroundColor {
            drawView.selectPencil(color: color)
        } else {
            drawView.selectPencil(color: .black)
        }
        
        selectButtonChange(isPencil: true)
    }
    
    @IBAction func removeDraw(_ sender: Any) {
        drawView.selectEraser()
        selectButtonChange(isPencil: false)
    }
    
    @objc func selectLineWidthOpen(sender:UITapGestureRecognizer) {
        guard let lineWidthVC = UIStoryboard(name: "LineWidthSelectViewController", bundle: nil).instantiateInitialViewController() as? LineWidthSelectViewController else {
            return
        }
        
        guard let view = sender.view else {
            return
        }
        
        lineWidthVC.currentWidth = Int(drawView.width)
        lineWidthVC.delegate = self
        lineWidthVC.modalPresentationStyle = .popover
        lineWidthVC.preferredContentSize = CGSize(width: 100, height: 50)
        lineWidthVC.popoverPresentationController?.sourceView = view
        lineWidthVC.popoverPresentationController?.sourceRect = view.bounds
        lineWidthVC.popoverPresentationController?.permittedArrowDirections = .any
        lineWidthVC.popoverPresentationController?.delegate = self
        
        self.present(lineWidthVC, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    func selectLineWidth(width: Int) {
        drawView.setLineWidth(width: width)
        lineWidthLabel.text = "\(width)pt"
    }
    
    func selectButtonChange(isPencil:Bool) {
        pencilButton.isSelected = isPencil
        eraserButton.isSelected = !isPencil
    }
    
    func setColor(color: UIColor) {
        colorPickerButton.backgroundColor = color
        drawView.setColor(color: color)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



























































