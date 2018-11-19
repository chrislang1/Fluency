//
//  ClearViewController.swift
//  Fluency
//
//  Created by Chris Lang on 15/11/18.
//  Copyright © 2018 Christopher Lang. All rights reserved.
//

import UIKit

class ClearViewController: UIViewController {

    var delegate: SetupClearViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    @IBAction func clearDataPressed(_ sender: UIButton) {
        delegate?.delegate?.reset()
        if let delegate = delegate {
            let delegateParentVC = delegate.delegate as! MainViewController
            UIView.animate(withDuration: 0.3) {
                delegateParentVC.view.alpha = 1
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        if let delegate = delegate {
            let delegateParentVC = delegate.delegate as! MainViewController
            UIView.animate(withDuration: 0.3) {
                delegateParentVC.view.alpha = 1
            }
            delegateParentVC.start()
        }
        dismiss(animated: true, completion: nil)
    }
    

}
