//
//  CouponsViewController.swift
//  Entertainer
//
//  Created by Shubhankar Singh on 01/10/17.
//  Copyright © 2017 Shubhankar Singh. All rights reserved.
//

import UIKit

class CouponsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarItem.title = "•"
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.tabBarItem.title = " "
    }
}
