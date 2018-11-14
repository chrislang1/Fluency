//
//  MainViewController.swift
//  Fluency
//
//  Created by Chris Lang on 2/11/18.
//  Copyright © 2018 Christopher Lang. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    //MARK: - Portrait Outlets
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
    
    //MARK: - Landscape Outlets
    @IBOutlet weak var startButtonLandscape: UIButton!
    @IBOutlet var stutterButtonArray: [UIButton]!
    
    @IBOutlet weak var landscapePausedLabel: UILabel!
    @IBOutlet weak var landscapeTimerLabel: UILabel!
    
    @IBOutlet weak var landscapeSyllableCountLabel: UILabel!
    @IBOutlet weak var landscapeSPMLabel: UILabel!
    @IBOutlet weak var landscapeStutterCountLabel: UILabel!
    @IBOutlet weak var landscapeSSCountLabel: UILabel!
    
    @IBOutlet var stutterButtonLabels: [UILabel]!
    @IBOutlet var stutterValueLabels: [UILabel]!
    
    @IBOutlet weak var landscapeSyllableButton: UIButton!
    
    
    //MARK: - Landscape/Portrait Views
    @IBOutlet var portraitView: UIView!
    @IBOutlet var landscapeView: UIView!
    
    //MARK: - Variables
    let impact = UIImpactFeedbackGenerator(style: .medium)
    let defaults = UserDefaults.standard
    
    var timer: Timer?
    var timeElapsed = 0.0
    var syllableCount : Float = 0 {
        didSet{
            let syllableCountInt = Int(syllableCount)
            syllableCountLabel.text = "\(syllableCountInt)"
            landscapeSyllableCountLabel.text = "\(syllableCountInt)"
            updateSS()
            updateSPM()
        }
    }
    var stutterCount : Float = 0 {
        didSet{
            let stutterCountInt = Int(stutterCount)
            stutterCountLabel.text = "\(stutterCountInt)"
            landscapeStutterCountLabel.text = "\(stutterCountInt)"
            
            if stutterCount > 0 {
               syllableCount += 1
            }
        }
    }
    
    var spm = 0.0 {
        didSet{
            spmLabel.text = "\(spm)"
            landscapeSPMLabel.text = "\(spm)"
        }
    }
    
    var timerStringValue = "00:00.00" {
        didSet{
            timerLabel.text = timerStringValue
            landscapeTimerLabel.text = timerStringValue
        }
    }
    
    var stutterCountValues: [Float] = [0,0,0,0,0] {
        didSet {
            let sum = stutterCountValues.reduce(0, +)
            stutterCount = sum
            for x in stutterCountValues.indices {
                stutterValueLabels[x].text = "\(stutterCountValues[x])"
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkOrientation()
        viewSetup()
        setupLandscapeLabels()
    }
    
    func viewSetup(){
        buttonDisable()
        pausedLabel.alpha = 0
        landscapePausedLabel.alpha = 0
        stutterCountValues = [0,0,0,0,0]
    }
    
    func setupLandscapeLabels(){
        for x in stutterButtonLabels.indices {
            stutterButtonLabels[x].text = stutterButtonArray[x].titleLabel?.text
        }
    }
    
    
    //MARK: - Button Actions
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        if startLabel.text == "Start" {
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
                self.timeElapsed += 0.01
                self.updateTimeLabels()
            })
            startLabel.text = "Pause"
            startIconImageView.image = UIImage.init(named: "Pause")
            startButtonLandscape.setImage(UIImage.init(named: "Pause"), for: .normal)
            buttonEnable()
            timerLabel.textColor = .black
            landscapeTimerLabel.textColor = .black
            UIView.animate(withDuration: 0.3) {
                self.pausedLabel.alpha = 0
                self.landscapePausedLabel.alpha = 0
            }
        } else if startLabel.text == "Pause" {
            if let timer = timer {
                timer.invalidate()
                self.timer = nil
            }
            startLabel.text = "Start"
            startIconImageView.image = UIImage.init(named: "Start")
            startButtonLandscape.setImage(UIImage.init(named: "Start"), for: .normal)
            buttonDisable()
            timerLabel.textColor = UIColor.init(red: 0.92, green: 0.34, blue: 0.26, alpha: 1.0)
            landscapeTimerLabel.textColor = UIColor.init(red: 0.92, green: 0.34, blue: 0.26, alpha: 1.0)
            pausedLabel.text = "Paused"
            landscapePausedLabel.text = "Paused"
            pausedLabel.textColor = UIColor.init(red: 0.92, green: 0.34, blue: 0.26, alpha: 1.0)
            landscapePausedLabel.textColor = UIColor.init(red: 0.92, green: 0.34, blue: 0.26, alpha: 1.0)
            UIView.animate(withDuration: 0.3) {
                self.pausedLabel.alpha = 1
                self.landscapePausedLabel.alpha = 1
            }
        }
        
        
    }
    
    @IBAction func syllableButtonPressed(_ sender: UIButton) {
        syllableCount += 1
        if defaults.bool(forKey: "HapticFeedback") {
          impact.impactOccurred()
        }
    }
    
    @IBAction func stutterButtonPressed(_ sender: UIButton) {
        stutterCount += 1
        if defaults.bool(forKey: "HapticFeedback") {
            impact.impactOccurred()
        }
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        reset()
    }
    
    func reset(){
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
        }
        
        timeElapsed = 0.0
        timerStringValue = "00:00.00"
        stutterCount = 0
        syllableCount = 0
        stutterCountValues = [0,0,0,0,0]
        timerLabel.textColor = .black
        timerLabel.textColor = .black
        startLabel.text = "Start"
        startIconImageView.image = UIImage.init(named: "Start")
        startButtonLandscape.setImage(UIImage.init(named: "Start"), for: .normal)
        pausedLabel.text = "Cleared"
        pausedLabel.textColor = .lightGray
        landscapePausedLabel.text = "Cleared"
        landscapePausedLabel.textColor = .lightGray
        buttonDisable()
        UIView.animate(withDuration: 0.3) {
            self.pausedLabel.alpha = 1
            self.landscapePausedLabel.alpha = 1
        }
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            UIView.animate(withDuration: 0.3) {
                self.pausedLabel.alpha = 0
                self.landscapePausedLabel.alpha = 0
            }
        }
    }
    
    @IBAction func landscapeStutterButtonPressed(_ sender: UIButton) {
        stutterCountValues[sender.tag] += 1
    }
    
    
    func updateTimeLabels(){
        timerStringValue = timeElapsed.minuteSecondsMS
    }
    
    func updateSS(){
        if syllableCount > 0 {
            let ss = stutterCount/syllableCount
            //print("\(ss)")
            let roundedSS = (round(ss*1000)/1000)*100
            let formattedSS = String(format: "%.1f", roundedSS)
            ssLabel.text = "\(formattedSS)%"
            landscapeSSCountLabel.text = "\(formattedSS)%"
            //print(roundedSS)
        } else if stutterCount == 0 {
            ssLabel.text = "-"
            landscapeSSCountLabel.text = "-"
        }
    }
    
    func updateSPM(){
        if syllableCount > 0 {
            let minutes = timeElapsed/60
            spm = round(Double(syllableCount/Float(minutes))*10)/10
        } else {
            spmLabel.text = "-"
            landscapeSPMLabel.text = "-"
        }
    }
    
    func buttonEnable(){
        if UIDevice.current.orientation.isLandscape {
            landscapeSyllableButton.isEnabled = true
            landscapeSyllableButton.alpha = 1
            
            for x in stutterButtonArray.indices {
                stutterButtonArray[x].isEnabled = true
                stutterButtonArray[x].alpha = 1
            }
            
        } else if UIDevice.current.orientation.isPortrait {
            syllableButton.isEnabled = true
            stutterButton.isEnabled = true
            syllableButton.alpha = 1
            stutterButton.alpha = 1
        }
        
    }
    
    func buttonDisable(){
        if UIDevice.current.orientation.isLandscape {
            landscapeSyllableButton.isEnabled = false
            landscapeSyllableButton.alpha = 0.5
            
            for x in stutterButtonArray.indices {
                stutterButtonArray[x].isEnabled = false
                stutterButtonArray[x].alpha = 0.5
            }
            
        } else if UIDevice.current.orientation.isPortrait {
            syllableButton.isEnabled = false
            stutterButton.isEnabled = false
            syllableButton.alpha = 0.5
            stutterButton.alpha = 0.5
        }
    }
    
    //MARK: - Segue Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSettings"{
            let destinationVC = segue.destination as! SetupSettingsViewController
            destinationVC.delegate = self
            UIView.animate(withDuration: 0.3) {
                self.view.alpha = 0.5
            }
        }
    }
    
    //MARK: - Orientation Detection - Needs Serious Work
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        checkOrientation()
    }
    
    func checkOrientation(){
        if UIDevice.current.orientation.isLandscape {
            self.view = self.landscapeView
            viewSetup()
            reset()
        } else if UIDevice.current.orientation.isPortrait {
            self.view = self.portraitView
            viewSetup()
            reset()
        }
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
