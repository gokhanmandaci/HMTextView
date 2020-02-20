//
//  ViewController.swift
//  HMTextView
//
//  Created by gokhanmandaci on 02/20/2020.
//  Copyright (c) 2020 gokhanmandaci. All rights reserved.
//

import UIKit
import HMTextView

class ViewController: UIViewController {
    
    @IBOutlet weak var hmTextView: HMTextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hmTextView.textAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)
        ]
        hmTextView.linkAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.red
        ]
        hmTextView.hashtagFont = UIFont.boldSystemFont(ofSize: 20)
        hmTextView.mentionFont = UIFont.boldSystemFont(ofSize: 12)
    }
}

