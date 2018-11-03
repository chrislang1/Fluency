//
//  MainViewController.swift
//  Fluency
//
//  Created by Chris Lang on 2/11/18.
//  Copyright © 2018 Christopher Lang. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var pausedLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var syllableCountLabel: UILabel!
    @IBOutlet weak var spmLabel: UILabel!
    @IBOutlet weak var stutterCountLabel: UILabel!
    @IBOutlet weak var ssLabel: UILabel!
    
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var startIconImageView: UIImageView!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var syllableButton: UIButton!
    @IBOutlet weak var stutterButton: UIButton!
    
    
    var timer: Timer?
    var timeElapsed = 0.0
    var syllableCount : Float = 0 {
        didSet{
            let syllableCountInt = Int(syllableCount)
            syllableCountLabel.text = "\(syllableCountInt)"
            updateSS()
            updateSPM()
        }
    }
    var stutterCount : Float = 0 {
        didSet{
            let stutterCountInt = Int(stutterCount)
            stutterCountLabel.text = "\(stutterCountInt)"
            //updateSS()
        }
    }
    
    var spm = 0.0 {
        didSet{
            spmLabel.text = "\(spm)"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        buttonDisable()
        pausedLabel.alpha = 0
    }
    
    
    //MARK: - Button Actions
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        if startLabel.text == "Start" {
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
                self.timeElapsed += 0.01
                self.updateTimeLabels()
            })
            startLabel.text = "Pause"
            buttonEnable()
            timerLabel.textColor = .black
            UIView.animate(withDuration: 0.3) {
                self.pausedLabel.alpha = 0
            }
        } else if startLabel.text == "Pause" {
            if let timer = timer {
                timer.invalidate()
                self.timer = nil
            }
            startLabel.text = "Start"
            buttonDisable()
            timerLabel.textColor = .red
            pausedLabel.text = "Paused"
            pausedLabel.textColor = .red
            UIView.animate(withDuration: 0.3) {
                self.pausedLabel.alpha = 1
            }
        }
        
        
    }
    
    @IBAction func syllableButtonPressed(_ sender: UIButton) {
        syllableCount += 1
    }
    
    @IBAction func stutterButtonPressed(_ sender: UIButton) {
        stutterCount += 1
        syllableCount += 1
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
        }
        
        timeElapsed = 0.0
        timerLabel.text = "00:00.00"
        stutterCount = 0
        syllableCount = 0
        timerLabel.textColor = .black
        startLabel.text = "Start"
        pausedLabel.text = "Cleared"
        pausedLabel.textColor = .lightGray
        UIView.animate(withDuration: 0.3) {
            self.pausedLabel.alpha = 1
        }
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            UIView.animate(withDuration: 0.3) {
                self.pausedLabel.alpha = 0
            }
            
        }
    }
    
    func updateTimeLabels(){
        timerLabel.text = timeElapsed.minuteSecondsMS
    }
    
    func updateSS(){
        if syllableCount > 0 {
            let ss = stutterCount/syllableCount
            print("\(ss)")
            let roundedSS = (round(ss*1000)/1000)*100
            ssLabel.text = "\(roundedSS)%"
            print(roundedSS)
        } else if stutterCount == 0 {
            ssLabel.text = "-"
        }
    }
    
    func updateSPM(){
        if syllableCount > 0 {
            let minutes = timeElapsed/60
            spm = round(Double(syllableCount/Float(minutes))*10)/10
        } else {
            spmLabel.text = "-"
        }
    }
    
    func buttonEnable(){
        syllableButton.isEnabled = true
        stutterButton.isEnabled = true
        syllableButton.alpha = 1
        stutterButton.alpha = 1
    }
    
    func buttonDisable(){
        syllableButton.isEnabled = false
        stutterButton.isEnabled = false
        syllableButton.alpha = 0.5
        stutterButton.alpha = 0.5
    }
    
    
}

extension TimeInterval {
    var minuteSecondsMS : String {
        return String(format:"%02d:%02d.%02d", minute, second, millisecond)
    }
    var minute: Int {
        return Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    var second: Int {
        return Int(truncatingRemainder(dividingBy: 60))
    }
    var millisecond: Int {
        return Int((self*100).truncatingRemainder(dividingBy: 100))
    }
}

extension Int {
    var msToSeconds: Double {
        return Double(self) / 1000
    }
}
