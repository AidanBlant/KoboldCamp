//
//  FirstViewController.swift
//  Kobolds1
//
//  Created by Aidan Blant on 8/23/20.
//  Copyright © 2020 Aidan Blant. All rights reserved.
//

import UIKit

class CampViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
    }

    @objc func handeTap(_ sender: UITapGestureRecognizer? = nil)
    {
        
        print("screen tapped")
        
    }
    
    
}

