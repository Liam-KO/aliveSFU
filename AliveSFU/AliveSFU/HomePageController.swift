//
//  HomePageController.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-10-26.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit

class HomePageController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

