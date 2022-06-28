//
//  ViewController.swift
//  fiveAngleStar
//
//  Created by 刘澄洋 on 2022/5/24.
//  Copyright © 2022 admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var metalView: fiveAngleStarView!
    @IBAction func triangleBtn(_ sender: UIButton) {
        metalView.setTriangleData()
    }
    
    @IBAction func fiveAngleBtn(_ sender: UIButton) {
        metalView.setFiveAngleData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

