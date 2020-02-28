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
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var msLabel: UILabel!
    @IBOutlet weak var minuteDividerLabel: UILabel!
    @IBOutlet weak var secondDividerLabel: UILabel!
    
    @IBOutlet weak var syllableCountLabel: UILabel!
    @IBOutlet weak var spmLabel: UILabel!
    @IBOutlet weak var stutterCountLabel: UILabel!
    @IBOutlet weak var ssLabel: UILabel!
    
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var startIconImageView: UIImageView!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var syllableButton: UIButton!
    @IBOutlet weak var stutterButton: UIButton!
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var portraitBasicModeView: UIView!
    
    //MARK: - Landscape Outlets
    @IBOutlet weak var startButtonLandscape: UIButton!
    @IBOutlet var stutterButtonArray: [UIButton]!
    
    @IBOutlet weak var landscapePausedLabel: UILabel!
    @IBOutlet weak var landscapeTimerLabel: UILabel!
    @IBOutlet weak var landscapeMinuteLabel: UILabel!
    @IBOutlet weak var landscapeSecondLabel: UILabel!
    @IBOutlet weak var landscapeMsLabel: UILabel!
    @IBOutlet weak var landscapeMinuteDividerLabel: UILabel!
    @IBOutlet weak var landscapeSecondDividerLabel: UILabel!
    
    @IBOutlet weak var landscapeSyllableCountLabel: UILabel!
    @IBOutlet weak var landscapeSPMLabel: UILabel!
    @IBOutlet weak var landscapeStutterCountLabel: UILabel!
    @IBOutlet weak var landscapeSSCountLabel: UILabel!
    
    @IBOutlet var stutterButtonLabels: [UILabel]!
    @IBOutlet var stutterValueLabels: [UILabel]!
    @IBOutlet var labelColourTabs: [UIView]!
    
    @IBOutlet weak var landscapeSyllableButton: UIButton!
    @IBOutlet weak var landscapeShareButton: UIButton!
    
    @IBOutlet weak var landscapeAdvancedModeView: UIView!
    
    //MARK: - Landscape/Portrait Views
    @IBOutlet var portraitView: UIView!
    @IBOutlet var landscapeView: UIView!
    
    //MARK: - Variables
    let impact = UIImpactFeedbackGenerator(style: .medium)
    let defaults = UserDefaults.standard
    
    var bannerDown = false
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
                stutterValueLabels[x].text = "\(Int(stutterCountValues[x]))"
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
        buttonPadding()
        tabColourSetup()
        setupModeView(view: portraitBasicModeView)
        setupModeView(view: landscapeAdvancedModeView)
    }
    
    //MARK: - Setup Functions
    func viewSetup(){
        buttonDisable()
        pausedLabel.alpha = 0
        landscapePausedLabel.alpha = 0
        self.shareButton.alpha = 0
        self.landscapeShareButton.alpha = 0
        
        checkLandscapeFontSize()
    }
    
    func checkLandscapeFontSize() {
        switch UIDevice.modelName{
        case "iPhone 5s", "iPhone 5c", "iPhone 5", "iPhone 4s", "iPhone 4":
            self.landscapeMsLabel.font = UIFont.systemFont(ofSize: 8)
            self.landscapeSecondLabel.font = UIFont.systemFont(ofSize: 8)
            self.landscapeMinuteLabel.font = UIFont.systemFont(ofSize: 8)
            self.landscapeMinuteDividerLabel.font = UIFont.systemFont(ofSize: 8)
            self.landscapeSecondDividerLabel.font = UIFont.systemFont(ofSize: 8)
        default:
            break
        }
    }
    
    func setupLandscapeLabels(){
        for x in stutterButtonArray.indices {
            let buttonTag = stutterButtonArray[x].tag
            for y in stutterButtonLabels.indices {
                if stutterButtonLabels[y].tag == buttonTag {
                    stutterButtonLabels[y].text = stutterButtonArray[x].titleLabel?.text
                }
            }
        }
        for x in stutterCountValues.indices {
            stutterValueLabels[x].text = "\(Int(stutterCountValues[x]))"
        }
    }
    
    func buttonPadding(){
        for x in stutterButtonArray.indices {
            stutterButtonArray[x].contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        }
    }
    
    func tabColourSetup(){
        for x in labelColourTabs.indices {
            labelColourTabs[x].layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }
    }
    
    func setupModeView(view: UIView){
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: view.layer.cornerRadius).cgPath
        view.layer.shadowOpacity = 0.12
        view.layer.shadowRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.alpha = 0
    }
    
    func modeViewFade(view: UIView){
        _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
            UIView.animate(withDuration: 0.5) {
                view.alpha = 1
            }
        }
        _ = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
            UIView.animate(withDuration: 0.5) {
                view.alpha = 0
            }
        }
    }
    
    
    //MARK: - Button Actions
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        if startLabel.text == "Start" {
            start()
        } else if startLabel.text == "Pause" {
            pause()
        }
    }
    
    func start(){
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
            self.timeElapsed += 0.01
            self.updateTimeLabels()
        })
        startLabel.text = "Pause"
        startIconImageView.image = UIImage.init(named: "Pause")
        startButtonLandscape.setImage(UIImage.init(named: "Pause"), for: .normal)
        buttonEnable()
        colourLabelsForState(isPaused: false)
        UIView.animate(withDuration: 0.3) {
            self.pausedLabel.alpha = 0
            self.landscapePausedLabel.alpha = 0
            self.shareButton.alpha = 0
            self.landscapeShareButton.alpha = 0
        }
    }
    
    func pause(){
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
        }
        startLabel.text = "Start"
        startIconImageView.image = UIImage.init(named: "Start")
        startButtonLandscape.setImage(UIImage.init(named: "Start"), for: .normal)
        buttonDisable()
        
        pausedLabel.text = "Paused"
        landscapePausedLabel.text = "Paused"
        
        colourLabelsForState(isPaused: true)
        
        UIView.animate(withDuration: 0.3) {
            self.pausedLabel.alpha = 1
            self.landscapePausedLabel.alpha = 1
            self.shareButton.alpha = 1
            self.landscapeShareButton.alpha = 1
        }
    }
    
    func colourLabelsForState(isPaused: Bool) {
        let colour = isPaused ? UIColor.init(red: 0.92, green: 0.34, blue: 0.26, alpha: 1.0) : .black
        
        pausedLabel.textColor = UIColor.init(red: 0.92, green: 0.34, blue: 0.26, alpha: 1.0)
        landscapePausedLabel.textColor = UIColor.init(red: 0.92, green: 0.34, blue: 0.26, alpha: 1.0)
        
        timerLabel.textColor = colour
        minuteLabel.textColor = colour
        secondLabel.textColor = colour
        msLabel.textColor = colour
        minuteDividerLabel.textColor = colour
        secondDividerLabel.textColor = colour
        
        landscapeTimerLabel.textColor = colour
        landscapeMinuteLabel.textColor = colour
        landscapeSecondLabel.textColor = colour
        landscapeMsLabel.textColor = colour
        landscapeMinuteDividerLabel.textColor = colour
        landscapeSecondDividerLabel.textColor = colour
    }
    
    func resetTimerLabels() {
        minuteLabel.text = "00"
        secondLabel.text = "00"
        msLabel.text = "00"
        
        landscapeMinuteLabel.text = "00"
        landscapeSecondLabel.text = "00"
        landscapeMsLabel.text = "00"
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
        if timeElapsed > 0 {
            performSegue(withIdentifier: "goToClear", sender: self)
        }
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
        colourLabelsForState(isPaused: false)
        resetTimerLabels()
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
            self.shareButton.alpha = 0
            self.landscapeShareButton.alpha = 0
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
        if defaults.bool(forKey: "HapticFeedback") {
            impact.impactOccurred()
        }
    }
    
    @IBAction func landscapeSettingsPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToSettings", sender: self)
    }
    
    @IBAction func shareButton(_ sender: UIButton) {
        shareSessionData()
    }

    func updateTimeLabels(){
        timerStringValue = timeElapsed.minuteSecondsMS
        minuteLabel.text = String(format:"%02d", timeElapsed.minute)
        secondLabel.text = String(format:"%02d", timeElapsed.second)
        msLabel.text = String(format:"%02d", timeElapsed.millisecond)
        landscapeMinuteLabel.text = String(format:"%02d", timeElapsed.minute)
        landscapeSecondLabel.text = String(format:"%02d", timeElapsed.second)
        landscapeMsLabel.text = String(format:"%02d", timeElapsed.millisecond)
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
        landscapeSyllableButton.isEnabled = true
        landscapeSyllableButton.alpha = 1
        
        for x in stutterButtonArray.indices {
            stutterButtonArray[x].isEnabled = true
            stutterButtonArray[x].alpha = 1
        }

        syllableButton.isEnabled = true
        stutterButton.isEnabled = true
        syllableButton.alpha = 1
        stutterButton.alpha = 1
    }
    
    func buttonDisable(){
        landscapeSyllableButton.isEnabled = false
        landscapeSyllableButton.alpha = 0.5
        
        for x in stutterButtonArray.indices {
            stutterButtonArray[x].isEnabled = false
            stutterButtonArray[x].alpha = 0.5
        }
        
        syllableButton.isEnabled = false
        stutterButton.isEnabled = false
        syllableButton.alpha = 0.5
        stutterButton.alpha = 0.5
    }
    
    //MARK: - Segue Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSettings"{
            let destinationVC = segue.destination as! SetupSettingsViewController
            destinationVC.delegate = self
            UIView.animate(withDuration: 0.3) {
                self.view.alpha = 0.5
            }
        } else if segue.identifier == "goToClear"{
            pause()
            let destinationVC = segue.destination as! SetupClearViewController
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
            if timeElapsed > 0 {
                pause()
            }
            if bannerDown {
                modeViewFade(view: landscapeAdvancedModeView)
            }
            bannerDown = true
        } else if UIDevice.current.orientation.isPortrait {
            self.view = self.portraitView
            viewSetup()
            if timeElapsed > 0 {
                pause()
            }
            if bannerDown {
               modeViewFade(view: portraitBasicModeView)
            }
            bannerDown = true
        }
    }
    
    // MARK: - Share
    func shareSessionData() {
        let items = [createSessionData()]
        let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(vc, animated: true)
    }
    
    func createSessionData() -> String {
        let time = timeElapsed.minuteSecondsMS
        let syllables = syllableCountLabel.text ?? ""
        let stutters = stutterCountLabel.text ?? ""
        let spmString = spmLabel.text ?? ""
        let ssString = ssLabel.text ?? ""
        
        var stringArray = ["Time Elapsed: \(time)", "Syllables: \(syllables)", "Stutters: \(stutters)", "SPM: \(spmString)", "%SS: \(ssString)"]
        
        if self.view == self.landscapeView {
            for x in stutterCountValues.indices {
                let button = stutterButtonArray.first { $0.tag == x }
                if let b = button, let title = b.title(for: .normal) {
                    let stutterCount = "\(Int(stutterCountValues[x]))"
                    stringArray.append("\(title): \(stutterCount)")
                }
            }
        }
        
        var shareString = ""
        stringArray.forEach { shareString =  shareString + $0 + "\n"}
        return shareString
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
