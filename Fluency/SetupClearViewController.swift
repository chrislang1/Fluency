//
//  SetupClearViewController.swift
//  Fluency
//
//  Created by Chris Lang on 15/11/18.
//  Copyright © 2018 Christopher Lang. All rights reserved.
//

import UIKit

class SetupClearViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var clearViewHeight: NSLayoutConstraint!
    @IBOutlet weak var clearViewWidth: NSLayoutConstraint!
    
    
    var delegate: MainViewController?
    let window = UIApplication.shared.keyWindow
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let bottomPadding = self.window?.safeAreaInsets.bottom {
            clearViewHeight.constant = clearViewHeight.constant + bottomPadding
        }
        containerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        if UIDevice.current.orientation.isPortrait {
            clearViewWidth.constant = self.view.frame.width
        }
    }
    

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ClearViewController
        destinationVC.delegate = self
    }

}
