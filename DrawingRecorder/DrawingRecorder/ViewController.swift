//
//  ViewController.swift
//  DrawingRecorder
//
//  Created by 박길남 on 06/11/2018.
//  Copyright © 2018 swieeft. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate, ColorPickerDelegate, LineWidthSelectProtocol, SpeedProtocol, DrawingAnimationDelegate {

    @IBOutlet weak var drawingView: DrawingView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var recodingButton: RecodingButton!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var pencilButton: UIButton!
    @IBOutlet weak var colorPickerButton: UIButton!
    @IBOutlet weak var eraserButton: UIButton!
    
    @IBOutlet weak var lineWidthView: UIView!
    @IBOutlet weak var lineWidthLabel: UILabel!
    
    @IBOutlet weak var speedView: UIView!
    @IBOutlet weak var speedLabel: UILabel!
    
    @IBOutlet weak var stopWatchLabel: StopWatchLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.drawingView.delegate = self
        self.colorPickerButton.setCircleView()
        self.playButton.setCircleView()
        self.lineWidthView.setTapGesture(target: self, action: #selector(selectLineWidthOpen(sender:)))
        self.speedView.setTapGesture(target: self, action: #selector(selectSpeedOpen(sender:)))
        
    }
    
    // 녹화 시작, 종료
    @IBAction func recoding(_ sender: UIButton) {
        // 애니메이션 재생 중에는 녹화를 할 수 없음
        if drawingView.isAnimationPlay {
            return
        }
        
        if drawingView.isRecoding {
            drawingView.endRecoding()
            stopWatchLabel.endRecoding()
        } else {
            drawingView.startRecoding()
            stopWatchLabel.startRecoding()
        }
        
        // 녹화 버튼 녹화 상태에 맞게 변경
        recodingButton.recoding(isRecoding: !drawingView.isRecoding)
    }
    
    // 애니메이션 시작
    @IBAction func play(_ sender: Any) {
        // 녹화 중이거나 애니메이션 실행 중에는 애니메이션 실행 할 수 없음
        if drawingView.isRecoding || drawingView.isAnimationPlay{
            return
        }
        
        menuView.setViewEnabled(isEnabled: false)
        bottomView.setViewEnabled(isEnabled: false)
        
        drawingView.animationPlay()
        stopWatchLabel.playAnimation(speed: drawingView.animationData.speed)
    }
    
    // 애니메이션 종료
    func stopAnimation() {
        menuView.setViewEnabled(isEnabled: true)
        bottomView.setViewEnabled(isEnabled: true)
    }
    
    // 펜 사용 선택
    @IBAction func selectPencil(_ sender: Any) {
        // 현재 설정된 펜 색상을 drawView에 전달
        if let color = colorPickerButton.backgroundColor {
            drawingView.setPencilColor(color: color)
        } else {
            drawingView.setPencilColor(color: .black)
        }
        
        selectButtonChange(isPencil: true)
    }
    
    // 지우개 사용 선택
    @IBAction func selectEraser(_ sender: Any) {
        drawingView.selectEraser()
        selectButtonChange(isPencil: false)
    }
    
    // 펜 색상 설정 창 열기
    @IBAction func selectColorOpen(_ sender: UIButton) {
        guard let colorVC = ColorPickerViewController.storyboardInstance() as? ColorPickerViewController else {
            return
        }
        
        // 현재 색상
        if let color = colorPickerButton.backgroundColor {
            colorVC.currentColor = color
        }
        
        colorVC.delegate = self
        colorVC.setPopoverViewController(size: CGSize(width: 200, height: 200), sourceView: sender, delegate: self)
        
        self.present(colorVC, animated: true, completion: nil)
    }
    
    // 펜 굵기 선택 창 열기
    @objc func selectLineWidthOpen(sender:UITapGestureRecognizer) {
        guard let lineWidthVC = LineWidthSelectViewController.storyboardInstance() as? LineWidthSelectViewController else {
            return
        }
        
        guard let view = sender.view else {
            return
        }
        
        lineWidthVC.currentWidth = Int(drawingView.theme.width) // 현재 굵기
        lineWidthVC.delegate = self
        lineWidthVC.setPopoverViewController(size: CGSize(width: 132, height: 50), sourceView: view, delegate: self)
        
        self.present(lineWidthVC, animated: true, completion: nil)
    }
    
    // 속도 선택 창 열기
    @objc func selectSpeedOpen(sender:UITapGestureRecognizer) {
        guard let speedVC = SpeedViewController.storyboardInstance() as? SpeedViewController else {
            return
        }
        
        guard let view = sender.view else {
            return
        }
        
        speedVC.currentSpeed = drawingView.animationData.speed // 현재 속도
        speedVC.delegate = self
        speedVC.setPopoverViewController(size: CGSize(width: 203, height: 42), sourceView: view, delegate: self)

        self.present(speedVC, animated: true, completion: nil)
    }
    
    // 펜과 지우개는 동시에 선택 할 수 없기 때문에 둘 중 하나만 사용할 수 있도록 상태 변경
    func selectButtonChange(isPencil:Bool) {
        pencilButton.isSelected = isPencil
        eraserButton.isSelected = !isPencil
    }
    
    // 펜 색상 설정 창에서 설정 된 색상
    func setColor(color: UIColor) {
        colorPickerButton.backgroundColor = color
        drawingView.setPencilColor(color: color)
    }
    
    // 펜 굵기 설정 창에서 설정 된 굵기
    func selectLineWidth(width: Int) {
        drawingView.setLineWidth(width: width)
        lineWidthLabel.text = "\(width)pt"
    }
    
    // 재생속도 설정 창에서 설정 된 속도
    func setSpeed(speed: Double) {
        speedLabel.text = "\(speed)x"
        drawingView.setSpeed(speed: speed)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



























































