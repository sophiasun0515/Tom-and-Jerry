//
//  ViewController.swift
//  Tom and Jerry
//
//  Created by Apple on 11/7/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var StartImage: UIImageView!
    
    
    @IBAction func LoginAction(_ sender: Any) {

    }
    
    @IBAction func RegisterAction(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StartImage.image = UIImage(named:"tomjerry")!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

