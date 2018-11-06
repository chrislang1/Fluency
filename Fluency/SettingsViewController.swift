//
//  SettingsViewController.swift
//  Fluency
//
//  Created by Chris Lang on 6/11/18.
//  Copyright © 2018 Christopher Lang. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var hapticFeedbackSwitch: UISwitch!
    var delegate: SetupSettingsViewController?
    
    var standard = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hapticFeedbackSwitch.isOn = standard.bool(forKey: "HapticFeedback")
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func hapticFeedbackSwitchChanged(_ sender: UISwitch) {
        hapticFeedbackSwitch.isOn = !hapticFeedbackSwitch.isOn
        standard.set(hapticFeedbackSwitch.isOn, forKey: "HapticFeedback")
    }
    
    @IBAction func supportButtonPressed(_ sender: UIButton) {
        //Adjust with new URL
        if let url = NSURL(string: "http://christopherlang.com.au/expenses/"){
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
        
    }
    @IBAction func rateButtonPressed(_ sender: UIButton) {
        //Adjust for actual app id - links to expenses
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id1401279619"){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func exitButtonPressed(_ sender: UIButton) {
        if let delegate = delegate {
            let delegateParentVC = delegate.delegate as! MainViewController
            UIView.animate(withDuration: 0.3) {
                delegateParentVC.view.alpha = 1
            }
        }
        dismiss(animated: true, completion: nil)
    }
}
