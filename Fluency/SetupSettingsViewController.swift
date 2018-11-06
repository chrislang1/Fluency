//
//  SetupSettingsViewController.swift
//  Fluency
//
//  Created by Chris Lang on 6/11/18.
//  Copyright © 2018 Christopher Lang. All rights reserved.
//

import UIKit

class SetupSettingsViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    var delegate: MainViewController?
    let window = UIApplication.shared.keyWindow
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let bottomPadding = self.window?.safeAreaInsets.bottom {
            containerViewHeight.constant = containerViewHeight.constant + bottomPadding
        }
        containerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SettingsViewController
        destinationVC.delegate = self
    }

}
