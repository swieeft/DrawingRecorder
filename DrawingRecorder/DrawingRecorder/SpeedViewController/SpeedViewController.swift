//
//  SpeedViewController.swift
//  DrawingRecorder
//
//  Created by 박길남 on 09/11/2018.
//  Copyright © 2018 swieeft. All rights reserved.
//

import UIKit

protocol SpeedProtocol {
    func setSpeed(speed:Double)
}

class SpeedViewController: UIViewController {

    @IBOutlet weak var halfSpeedButton: UIButton!
    @IBOutlet weak var defaultSpeedButton: UIButton!
    @IBOutlet weak var doubleSpeedButton: UIButton!
    @IBOutlet weak var quadrupleSpeedButton: UIButton!
    
    var currentSpeed:Double = 1.0 // 현재 재생 속도
    
    var delegate:SpeedProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // 0.5x
    @IBAction func halfSpeed(_ sender: Any) {
        currentSpeed = 0.5
        setSpeed()
    }
    
    // 1.0x
    @IBAction func defaultSpeed(_ sender: Any) {
        currentSpeed = 1.0
        setSpeed()
    }
    
    // 2.0x
    @IBAction func doubleSpeed(_ sender: Any) {
        currentSpeed = 2.0
        setSpeed()
    }
    
    // 4.0x
    @IBAction func quadrupleSpeed(_ sender: Any) {
        currentSpeed = 4.0
        setSpeed()
    }
    
    func setSpeed() {
        self.delegate?.setSpeed(speed: self.currentSpeed)
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
