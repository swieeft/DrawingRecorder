//
//  ColorPickerViewController.swift
//  DrawingRecorder
//
//  Created by 박길남 on 06/11/2018.
//  Copyright © 2018 swieeft. All rights reserved.
//

import UIKit

protocol ColorPickerDelegate {
    func setColor(color:UIColor)
}

class ColorPickerViewController: UIViewController {

    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var colorDisplayView: UIView!
    
    var currentColor:UIColor = UIColor.clear
    
    var redColor:Float = 0.0
    var greenColor:Float = 0.0
    var blueColor:Float = 0.0
    
    var delegate:ColorPickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.layer.cornerRadius = 10
        pickerView.layer.masksToBounds = true
        
        applyButton.layer.cornerRadius = 5
        applyButton.layer.masksToBounds = true
        
        cancelButton.layer.cornerRadius = 5
        cancelButton.layer.masksToBounds = true
        
        colorDisplayView.layer.cornerRadius = 10
        colorDisplayView.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setCurrentColor()
    }
    
    func setCurrentColor() {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.currentColor.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            redColor = Float(fRed)
            redSlider.value = Float(fRed)
            
            greenColor = Float(fGreen)
            greenSlider.value = Float(fGreen)
            
            blueColor = Float(fBlue)
            blueSlider.value = Float(fBlue)
            
            setColor()
        }
    }
    
    @IBAction func onRedSliderAction(_ sender: Any) {
        redColor = redSlider.value
        setColor()
    }
    
    @IBAction func onGreenSliderAction(_ sender: Any) {
        greenColor = greenSlider.value
        setColor()
    }
    
    @IBAction func onBlueSliderAction(_ sender: Any) {
        blueColor = blueSlider.value
        setColor()
    }
    
    @IBAction func onApplyAction(_ sender: Any) {
        let color = UIColor(red: CGFloat(redColor), green: CGFloat(greenColor), blue: CGFloat(blueColor), alpha: 1.0)
        self.delegate?.setColor(color: color)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func onCancelAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func setColor() {
        let red = String(format: "%0.0f", redColor * 255)
        redLabel.text = "Red : \(red)"
        
        let green = String(format: "%0.0f", greenColor * 255)
        greenLabel.text = "Green : \(green)"
        
        let blue = String(format: "%0.0f", blueColor * 255)
        blueLabel.text = "Blue : \(blue)"
        
        colorDisplayView.backgroundColor = UIColor(red: CGFloat(redColor), green: CGFloat(greenColor), blue: CGFloat(blueColor), alpha: 1.0)
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
