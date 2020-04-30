//
//  SettingsViewController.swift
//  Fluency
//
//  Created by Chris Lang on 6/11/18.
//  Copyright © 2018 Christopher Lang. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController {

    @IBOutlet weak var hapticFeedbackSwitch: UISwitch!
    var delegate: SetupSettingsViewController?
    
    var standard = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hapticFeedbackSwitch.isOn = standard.bool(forKey: "HapticFeedback")
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    

    func closeSettings() {
        if let delegate = delegate {
            let delegateParentVC = delegate.delegate as! MainViewController
            UIView.animate(withDuration: 0.3) {
                delegateParentVC.view.alpha = 1
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func hapticFeedbackSwitchChanged(_ sender: UISwitch) {
        hapticFeedbackSwitch.isOn = !hapticFeedbackSwitch.isOn
        standard.set(hapticFeedbackSwitch.isOn, forKey: "HapticFeedback")
    }
    
    @IBAction func supportButtonPressed(_ sender: UIButton) {
        sendEmail()
    }
    @IBAction func rateButtonPressed(_ sender: UIButton) {
        //Adjust for actual app id - links to expenses
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id1441243948"){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func exitButtonPressed(_ sender: UIButton) {
        closeSettings()
    }
                                              
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        closeSettings()
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["chris@christopherlang.com.au"])

                present(mail, animated: true)
            } else if let emailUrl = createEmailUrl(to: "chris@christopherlang.com.au", subject: "", body: "") {
                UIApplication.shared.open(emailUrl)
        } else {
            if let url = NSURL(string: "http://christopherlang.com.au"){
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!

        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")

        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }

        return defaultUrl
    }
}
